# ALTHEA
Chain ID: `althea_417834-3`

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
curl -Ls https://go.dev/dl/go1.21.3.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```

### Build binary
```
cd $HOME
rm -rf althea-chain
git clone https://github.com/althea-net/althea-chain
cd althea-chain
git checkout v0.5.5
make build
mkdir -p $HOME/.althea/cosmovisor/genesis/bin
mv build/althea $HOME/.althea/cosmovisor/genesis/bin/
rm -rf build
sudo ln -s $HOME/.althea/cosmovisor/genesis $HOME/.althea/cosmovisor/current -f
sudo ln -s $HOME/.althea/cosmovisor/current/bin/althea /usr/local/bin/althea -f
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```

```
sudo tee /etc/systemd/system/althea.service > /dev/null << EOF
[Unit]
Description=althea node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.althea"
Environment="DAEMON_NAME=althea"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.althea/cosmovisor/current/bin"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable althea
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
althea config chain-id althea_417834-3
althea config keyring-backend test
althea config node tcp://localhost:21157
```
```
althea init $MONIKER --chain-id althea_417834-3
```

### Download Genesis & Addrbook
```
curl -Ls https://snap.nodex.one/althea-testnet/genesis.json > $HOME/.althea/config/genesis.json
curl -Ls https://snap.nodex.one/althea-testnet/addrbook.json > $HOME/.althea/config/addrbook.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:21110\"|" $HOME/.althea/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0aalthea\"|" $HOME/.althea/config/app.toml
```

### Pruning Setting
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.althea/config/app.toml
```

### Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:21158\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:21157\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:21160\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:21156\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":21166\"%" $HOME/.althea/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:21117\"%; s%^address = \":8080\"%address = \":21180\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:21190\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:21191\"%; s%:8545%:21145%; s%:8546%:21146%; s%:6065%:21165%" $HOME/.althea/config/app.toml
```

### Snapshot
```
curl -L https://snap.nodex.one/althea-testnet/althea-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.althea
[[ -f $HOME/.althea/data/upgrade-info.json ]] && cp $HOME/.althea/data/upgrade-info.json $HOME/.althea/cosmovisor/genesis/upgrade-info.json
```

### Start Node
```
sudo systemctl start althea
journalctl -u althea -f
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
