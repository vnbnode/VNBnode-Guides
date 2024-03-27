# BlockX
Chain ID: `alignedlayer`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        6 GB             |
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
curl -Ls https://go.dev/dl/go1.20.5.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```

### Build binary
```
cd $HOME
wget https://snap.nodex.one/blockx-testnet/blockxd
chmod +x blockxd
mkdir -p $HOME/.blockxd/cosmovisor/genesis/bin
mv blockxd $HOME/.blockxd/cosmovisor/genesis/bin/
rm -rf build
sudo ln -s $HOME/.blockxd/cosmovisor/genesis $HOME/.blockxd/cosmovisor/current -f
sudo ln -s $HOME/.blockxd/cosmovisor/current/bin/blockxd /usr/local/bin/blockxd -f
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```
```
sudo tee /etc/systemd/system/blockx.service > /dev/null << EOF
[Unit]
Description=blockx node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.blockxd"
Environment="DAEMON_NAME=blockxd"
Environment="UNSAFE_SKIP_BACKUP=true"
 
[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable blockx
```

### Initialize Node
Replace `Your moniker` with your own moniker
```
MONIKER="Your moniker"
```
```
blockxd config chain-id blockx_50-1
blockxd config keyring-backend test
blockxd config node tcp://localhost:20557
```
```
blockxd init $MONIKER --chain-id blockx_50-1
```

### Download Genesis & Addrbook
```
curl -Ls https://snap.nodex.one/blockx-testnet/genesis.json > $HOME/.blockxd/config/genesis.json
curl -Ls https://snap.nodex.one/blockx-testnet/addrbook.json > $HOME/.blockxd/config/addrbook.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:20510\"|" $HOME/.blockxd/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0abcx\"|" $HOME/.blockxd/config/app.toml
```

### Pruning Setting
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.blockxd/config/app.toml
```

### Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:20558\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:20557\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:20560\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:20556\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":20566\"%" $HOME/.blockxd/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:20517\"%; s%^address = \":8080\"%address = \":20580\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:20590\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:20591\"%; s%:8545%:20545%; s%:8546%:20546%; s%:6065%:20565%" $HOME/.blockxd/config/app.toml
```

### Snapshot
```
curl -L https://snap.nodex.one/blockx-testnet/blockx-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.blockxd
[[ -f $HOME/.blockxd/data/upgrade-info.json ]] && cp $HOME/.blockxd/data/upgrade-info.json $HOME/.blockxd/cosmovisor/genesis/upgrade-info.json
```

### Start Node
```
sudo systemctl start blockx
journalctl -u blockx -f
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
