# Crossfi testnet validator
|        Chain ID       |    Port    |      Version     |
|-----------------------|------------|------------------|
| crossfi-evm-testnet-1 |     239    | v0.3.0-prebuild3 |
# Minimum hardware
|      Spec   |        Requirements       |
| :---------: | :-----------------------: |
|   **CPU**   |          8 Cores          |
|   **RAM**   |           16 GB           |
|   **SSD**   |           1 TB            | 

## RPC, API, gRPC and Snapshot
✅ RPC:  http:/109.199.118.239:23957

✅ API:  http:/109.199.118.239:23917

✅ Auto Snapshot daily: 
```
https://github.com/vnbnode/VNBnode-Guides/blob/main/Testnet/CrossFI/snapshot.md
```
## Update and install packages for compiling
```
sudo apt update
sudo apt-get install git curl build-essential make jq gcc snapd chrony lz4 tmux unzip bc -y
```

## Install Go
```
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.21.7.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```

## Build binary
```
cd $HOME
wget https://github.com/crossfichain/crossfi-node/releases/download/v0.3.0-prebuild3/crossfi-node_0.3.0-prebuild3_linux_amd64.tar.gz && sudo mv crossfi-node_0.3.0-prebuild3_linux_amd64.tar.gz crossfid-v0.3.0.tar.gz && sudo tar -xvf crossfid-v0.3.0.tar.gz
mkdir -p $HOME/.mineplex-chain/cosmovisor/genesis/bin
mv bin/crossfid $HOME/.mineplex-chain/cosmovisor/genesis/bin/
rm -rf build
sudo ln -s $HOME/.mineplex-chain/cosmovisor/genesis $HOME/.mineplex-chain/cosmovisor/current -f
sudo ln -s $HOME/.mineplex-chain/cosmovisor/current/bin/crossfid /usr/local/bin/crossfid -f
```

## Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```
```
sudo tee /etc/systemd/system/crossfi.service > /dev/null << EOF
[Unit]
Description=crossfi node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.mineplex-chain"
Environment="DAEMON_NAME=crossfid"
Environment="UNSAFE_SKIP_BACKUP=true"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable crossfi
```

## Initialize Node
Replace `Name-VNBnode` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
crossfid config chain-id crossfi-evm-testnet-1
crossfid config keyring-backend test
crossfid config node tcp://localhost:23957
```
```
crossfid init $MONIKER --chain-id crossfi-evm-testnet-1
```

### Download Genesis & Addrbook
```
curl -Ls https://snap.vnbnode.com/crossfi/genesis.json > $HOME/.mineplex-chain/config/genesis.json
curl -Ls https://snap.vnbnode.com/crossfi/addrbook.json > $HOME/.mineplex-chain/config/addrbook.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:23910\"|" $HOME/.mineplex-chain/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"10000000000000mpx\"|" $HOME/.mineplex-chain/config/app.toml
```

### Pruning Setting
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.mineplex-chain/config/app.toml
```

### Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:23958\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:23957\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:23960\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:23956\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":23966\"%" $HOME/.mineplex-chain/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:23917\"%; s%^address = \":8080\"%address = \":23980\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:23990\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:23991\"%; s%:8545%:23945%; s%:8546%:23946%; s%:6065%:23965%" $HOME/.mineplex-chain/config/app.toml
```

### Snapshot
```
curl -L https://snap.vnbnode.com/crossfi/crossfi-evm-testnet-1_snapshot_latest.tar.lz4 | tar -I lz4 -xf - -C $HOME/.mineplex-chain/data
```

### Start Node
```
sudo systemctl start crossfi
journalctl -u crossfi -f
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
