# BABYLON
Chain ID: `bbn-test-2	`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        4 GB             |
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
curl -Ls https://go.dev/dl/go1.20.10.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```

### Build binary
```
cd $HOME
rm -rf babylon
git clone https://github.com/babylonchain/babylon.git
cd babylon
git checkout v0.7.2
make build
mkdir -p $HOME/.babylond/cosmovisor/genesis/bin
mv build/babylond $HOME/.babylond/cosmovisor/genesis/bin/
rm -rf build
sudo ln -s $HOME/.babylond/cosmovisor/genesis $HOME/.babylond/cosmovisor/current -f
sudo ln -s $HOME/.babylond/cosmovisor/current/bin/babylond /usr/local/bin/babylond -f
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```

```
sudo tee /etc/systemd/system/babylon.service > /dev/null << EOF
[Unit]
Description=babylon node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.babylond"
Environment="DAEMON_NAME=babylond"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.babylond/cosmovisor/current/bin"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable babylon
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
babylond config chain-id bbn-test-2
babylond config keyring-backend test
babylond config node tcp://localhost:21757
```
```
babylond init $MONIKER --chain-id bbn-test-2
```

### Download Genesis & Addrbook
```
curl -Ls https://snap.nodex.one/babylon-testnet/genesis.json > $HOME/.babylond/config/genesis.json
curl -Ls https://snap.nodex.one/babylon-testnet/addrbook.json > $HOME/.babylond/config/addrbook.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:21710\"|" $HOME/.babylond/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.00001ubbn\"|" $HOME/.babylond/config/app.toml
```

### Pruning Setting
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.babylond/config/app.toml
```

### Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:21758\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:21757\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:21760\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:21756\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":21766\"%" $HOME/.babylond/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:21717\"%; s%^address = \":8080\"%address = \":21780\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:21790\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:21791\"%; s%:8545%:21745%; s%:8546%:21746%; s%:6065%:21765%" $HOME/.babylond/config/app.toml
```

### Snapshot
```
curl -L https://snap.nodex.one/babylon-testnet/babylon-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.babylond
[[ -f $HOME/.babylond/data/upgrade-info.json ]] && cp $HOME/.babylond/data/upgrade-info.json $HOME/.babylond/cosmovisor/genesis/upgrade-info.json
```

### Start Node
```
sudo systemctl start babylon
journalctl -u babylon -f
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
