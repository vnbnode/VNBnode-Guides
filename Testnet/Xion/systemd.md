# XION
Chain ID: `xion-testnet-1`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        16 GB             |
|   **SSD**   |        200 GB            |
| **NETWORK** |        100 Mbps          |

### Update and install packages for compiling
```
sudo apt update
sudo apt-get install git curl build-essential make jq gcc snapd chrony lz4 tmux unzip bc -y
```

### Install Go
```
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.21.3.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```

### Build binary
```
cd $HOME
rm -rf xion
git clone https://github.com/burnt-labs/xion.git
cd xion
git checkout v0.3.4
make build
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
xiond config chain-id xion-testnet-1
xiond config keyring-backend test
xiond config node tcp://localhost:22357
```
```
xiond init $MONIKER --chain-id xion-testnet-1
```

### Download Genesis & Addrbook
```
curl -Ls https://snap.nodex.one/xion-testnet/genesis.json > $HOME/.xiond/config/genesis.json
curl -Ls https://snap.nodex.one/xion-testnet/addrbook.json > $HOME/.xiond/config/addrbook.json 
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:22310\"|" $HOME/.xiond/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0uxion\"|" $HOME/.xiond/config/app.toml
```

### Pruning Setting
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.xiond/config/app.toml
```

### Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:22358\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:22357\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:22360\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:22356\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":22366\"%" $HOME/.xiond/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:22317\"%; s%^address = \":8080\"%address = \":22380\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:22390\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:22391\"%; s%:8545%:22345%; s%:8546%:22346%; s%:6065%:22365%" $HOME/.xiond/config/app.toml
```

## Create service
```
sudo tee /etc/systemd/system/xiond.service > /dev/null <<EOF
[Unit]
Description=Xion Daemon
After=network-online.target
[Service]
User=$USER
ExecStart=$(which xiond) start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable xiond
```

### Snapshot
```
curl -L https://snap.nodex.one/xion-testnet/xion-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.xiond
[[ -f $HOME/.xiond/data/upgrade-info.json ]] && cp $HOME/.xiond/data/upgrade-info.json $HOME/.xiond/cosmovisor/genesis/upgrade-info.json
```

### Start Node
```
sudo systemctl restart xiond
journalctl -u xiond -f
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
