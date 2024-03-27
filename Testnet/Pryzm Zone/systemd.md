# PRYZM ZONE
Chain ID: `indigo-1	`

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
curl -Ls https://go.dev/dl/go1.22.0.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```

### Build binary
```
cd $HOME
wget https://storage.googleapis.com/pryzm-zone/core/0.11.1/pryzmd-0.11.1-linux-amd64
sudo mv pryzmd-0.11.1-linux-amd64 pryzmd
sudo chmod +x pryzmd
mkdir -p $HOME/.pryzm/cosmovisor/genesis/bin
mv pryzmd $HOME/.pryzm/cosmovisor/genesis/bin/
sudo ln -s $HOME/.pryzm/cosmovisor/genesis $HOME/.pryzm/cosmovisor/current -f
sudo ln -s $HOME/.pryzm/cosmovisor/current/bin/pryzmd /usr/local/bin/pryzmd -f
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```

```
sudo tee /etc/systemd/system/pryzm.service > /dev/null << EOF
[Unit]
Description=pryzm node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.pryzm"
Environment="DAEMON_NAME=pryzmd"
Environment="UNSAFE_SKIP_BACKUP=true"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable pryzm
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
pryzmd config chain-id indigo-1
pryzmd config keyring-backend test
pryzmd config node tcp://localhost:23257
```
```
pryzmd init $MONIKER --chain-id indigo-1
```

### Download Genesis & Addrbook
```
curl -Ls https://snap.nodex.one/pryzm-testnet/genesis.json > $HOME/.pryzm/config/genesis.json
curl -Ls https://snap.nodex.one/pryzm-testnet/addrbook.json > $HOME/.pryzm/config/addrbook.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:23210\"|" $HOME/.pryzm/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.015upryzm,0.01factory/pryzm15k9s9p0ar0cx27nayrgk6vmhyec3lj7vkry7rx/uusdsim\"|" $HOME/.pryzm/config/app.toml
```

### Pruning Setting
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.pryzm/config/app.toml
```

### Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:23258\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:23257\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:23260\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:23256\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":23266\"%" $HOME/.pryzm/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:23217\"%; s%^address = \":8080\"%address = \":23280\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:23290\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:23291\"%; s%:8545%:23245%; s%:8546%:23246%; s%:6065%:23265%" $HOME/.pryzm/config/app.toml
```

### Snapshot
```
curl -L https://snap.nodex.one/pryzm-testnet/pryzm-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.pryzm
[[ -f $HOME/.pryzm/data/upgrade-info.json ]] && cp $HOME/.pryzm/data/upgrade-info.json $HOME/.pryzm/cosmovisor/genesis/upgrade-info.json
```

### Start Node
```
sudo systemctl start pryzm
journalctl -u pryzm -f
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
