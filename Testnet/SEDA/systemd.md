# SEDA
Chain ID: `seda-1-testnet`

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
curl -Ls https://go.dev/dl/go1.21.7.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```

### Build binary
```
cd $HOME
rm -rf seda-chain
git clone https://github.com/sedaprotocol/seda-chain.git
cd seda-chain
git checkout v0.0.6
make build
mkdir -p $HOME/.sedad/cosmovisor/genesis/bin
mv build/sedad $HOME/.sedad/cosmovisor/genesis/bin/
rm -rf build
sudo ln -s $HOME/.sedad/cosmovisor/genesis $HOME/.sedad/cosmovisor/current -f
sudo ln -s $HOME/.sedad/cosmovisor/current/bin/sedad /usr/local/bin/sedad -f
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```

```
sudo tee /etc/systemd/system/seda.service > /dev/null << EOF
[Unit]
Description=Seda node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.sedad"
Environment="DAEMON_NAME=sedad"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.sedad/cosmovisor/current/bin"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable seda
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
sed -i \
  -e 's|^chain-id *=.*|chain-id = "seda-1-testnet"|' \
  -e 's|^keyring-backend *=.*|keyring-backend = "test"|' \
  -e 's|^node *=.*|node = "tcp://localhost:23657"|' \
  $HOME/.sedad/config/client.toml
```
```
sedad init $MONIKER --chain-id seda-1-testnet
```

### Download Genesis & Addrbook
```
curl -Ls https://snap.nodex.one/seda-testnet/genesis.json > $HOME/.sedad/config/genesis.json
curl -Ls https://snap.nodex.one/seda-testnet/addrbook.json > $HOME/.sedad/config/addrbook.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:23610\"|" $HOME/.sedad/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0aseda\"|" $HOME/.sedad/config/app.toml
```

### Pruning Setting
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.sedad/config/app.toml
```

### Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:23658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:23657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:23660\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:23656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":23666\"%" $HOME/.sedad/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:23617\"%; s%^address = \":8080\"%address = \":23680\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:23690\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:23691\"%; s%:8545%:23645%; s%:8546%:23646%; s%:6065%:23665%" $HOME/.sedad/config/app.toml
```

### Snapshot
```
curl -L https://snap.nodex.one/seda-testnet/seda-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.sedad
[[ -f $HOME/.sedad/data/upgrade-info.json ]] && cp $HOME/.sedad/data/upgrade-info.json $HOME/.sedad/cosmovisor/genesis/upgrade-info.json
```

### Start Node
```
sudo systemctl start seda
journalctl -u seda -f
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
