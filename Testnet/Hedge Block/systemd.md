# Hedge Block
Chain ID: `berberis-1`

## Recommended Hardware Requirements

|   SPEC      |       Recommend       |       Minimum        |
| :---------: | :--------------------:|:--------------------:|
|   **CPU**   |        8 Cores        |        4 Cores       |
|   **RAM**   |        32 GB          |        16 GB         |
|   **SSD**   |        200 GB         |        200 GB        |
| **NETWORK** |        100 Mbps       |        100 Mbps      |

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
wget -O hedged https://github.com/hedgeblock/testnets/releases/download/v0.1.0/hedged_linux_amd64_v0.1.0
sudo chmod +x hedged
mkdir -p $HOME/.hedge/cosmovisor/genesis/bin
mv hedged $HOME/.hedge/cosmovisor/genesis/bin/
sudo ln -s $HOME/.hedge/cosmovisor/genesis $HOME/.hedge/cosmovisor/current -f
sudo ln -s $HOME/.hedge/cosmovisor/current/bin/hedged /usr/local/bin/hedged -f
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```
```
sudo tee /etc/systemd/system/hedge.service > /dev/null << EOF
[Unit]
Description=hedge node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.hedge"
Environment="DAEMON_NAME=hedged"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.hedge/cosmovisor/current/bin"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable hedge
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
hedged config chain-id berberis-1
hedged config keyring-backend test
hedged config node tcp://localhost:24057
```
```
hedged init $MONIKER --chain-id berberis-1
```

### Download Genesis & Addrbook
```
curl -Ls https://snap.nodex.one/hedge-testnet/genesis.json > $HOME/.hedge/config/genesis.json
curl -Ls https://snap.nodex.one/hedge-testnet/addrbook.json > $HOME/.hedge/config/addrbook.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:24010\"|" $HOME/.hedge/config/config.toml
sed -i -e 's|^persistent_peers *=.*|persistent_peers ="b2a0bfb93d98e62802ec21eac60eaf11f17354d8@89.117.145.86:11856,b5d5226ac957b8b384644e0aa2736be4b40f806c@46.38.232.86:14656,70f7dc74d3b6afa12b988d61707229e8e191d9a2@213.246.45.16:55656,7f53c0fba561febc278e00334a7d9af8d155c538@109.199.97.149:26656,e17e1afbd58c6262c6d6a8c991b4a1e570d6c1c4@84.247.128.239:26656,cd0c25fcfca4e8fc17a22f2bb6cec4923d078fd3@27.66.100.4:26656,56147d1f212f01bc68bec8161d537d93900d3414@45.85.147.82:11856,a5ce7811bc2a19e20b7ce1da0635f738ed9969ac@44.193.5.65:26656,e4ad93631cdb9da1015dd46347c5e7c34bb762c1@84.247.147.224:26656"|' $HOME/.alignedlayer/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025uhedge\"|" $HOME/.hedge/config/app.toml
```

### Pruning Setting
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.hedge/config/app.toml
```

### Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:24058\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:24057\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:24060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:24056\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":24066\"%" $HOME/.hedge/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:24017\"%; s%^address = \":8080\"%address = \":24080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:24090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:24091\"%; s%:8545%:24045%; s%:8546%:24046%; s%:6065%:24065%" $HOME/.hedge/config/app.toml
```


### Snapshot
```
curl -L https://snap.nodex.one/hedge-testnet/hedge-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.hedge
[[ -f $HOME/.hedge/data/upgrade-info.json ]] && cp $HOME/.hedge/data/upgrade-info.json $HOME/.hedge/cosmovisor/genesis/upgrade-info.json
```

### Start Node
```
sudo systemctl start hedge
journalctl -u hedge -f
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
