# Bitcanna Global
Chain ID: `bitcanna-dev-1	`

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
curl -Ls https://go.dev/dl/go1.21.7.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```

### Build binary
```
cd $HOME
rm -rf bcna
git clone https://github.com/BitCannaGlobal/bcna.git
cd bcna
git checkout v3.0.2-rc1
make build
mkdir -p $HOME/.bcna/cosmovisor/genesis/bin
mv build/bcnad $HOME/.bcna/cosmovisor/genesis/bin/
rm -rf build
sudo ln -s $HOME/.bcna/cosmovisor/genesis $HOME/.bcna/cosmovisor/current -f
sudo ln -s $HOME/.bcna/cosmovisor/current/bin/bcnad /usr/local/bin/bcnad -f
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```
```
sudo tee /etc/systemd/system/bitcanna.service > /dev/null << EOF
[Unit]
Description=bitcanna node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.bcna"
Environment="DAEMON_NAME=bcnad"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.bcna/cosmovisor/current/bin"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable bitcanna
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
bcnad config chain-id bitcanna-dev-1
bcnad config keyring-backend test
bcnad config node tcp://localhost:22957
```
```
bcnad init $MONIKER --chain-id bitcanna-dev-1
```

### Download Genesis & Addrbook
```
curl -Ls https://snap.nodex.one/bitcanna-testnet/genesis.json > $HOME/.bcna/config/genesis.json
curl -Ls https://snap.nodex.one/bitcanna-testnet/addrbook.json > $HOME/.bcna/config/addrbook.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:22910\"|" $HOME/.bcna/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0ubcna\"|" $HOME/.bcna/config/app.toml
```

### Pruning Setting
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.bcna/config/app.toml
```

### Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:22958\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:22957\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:22960\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:22956\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":22966\"%" $HOME/.bcna/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:22917\"%; s%^address = \":8080\"%address = \":22980\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:22990\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:22991\"%; s%:8545%:22945%; s%:8546%:22946%; s%:6065%:22965%" $HOME/.bcna/config/app.toml
```

### Snapshot
```
curl -L https://snap.nodex.one/bitcanna-testnet/bitcanna-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.bcna
[[ -f $HOME/.bcna/data/upgrade-info.json ]] && cp $HOME/.bcna/data/upgrade-info.json $HOME/.bcna/cosmovisor/genesis/upgrade-info.json
```

### Start Node
```
sudo systemctl start bitcanna
journalctl -u bitcanna -f
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
