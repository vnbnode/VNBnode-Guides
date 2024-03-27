# ENTANGLE
Chain ID: `entangle_33133-1	`

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
rm -rf entangle-blockchain
git clone https://github.com/Entangle-Protocol/entangle-blockchain.git
cd entangle-blockchain
make build
mkdir -p $HOME/.entangled/cosmovisor/genesis/bin
mv build/entangled $HOME/.entangled/cosmovisor/genesis/bin/
rm -rf build
sudo ln -s $HOME/.entangled/cosmovisor/genesis $HOME/.entangled/cosmovisor/current -f
sudo ln -s $HOME/.entangled/cosmovisor/current/bin/entangled /usr/local/bin/entangled -f
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```

```
sudo tee /etc/systemd/system/entangle.service > /dev/null << EOF
[Unit]
Description=entangle node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.entangled"
Environment="DAEMON_NAME=entangled"
Environment="UNSAFE_SKIP_BACKUP=true"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable entangle
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
entangled config chain-id entangle_33133-1
entangled config keyring-backend test
entangled config node tcp://localhost:21857
```
```
entangled init $MONIKER --chain-id entangle_33133-1
```

### Download Genesis & Addrbook
```
curl -Ls https://snap.nodex.one/entangle-testnet/genesis.json > $HOME/.entangled/config/genesis.json
curl -Ls https://snap.nodex.one/entangle-testnet/addrbook.json > $HOME/.entangled/config/addrbook.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:21810\"|" $HOME/.entangled/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"10aNGL\"|" $HOME/.entangled/config/app.toml
```

### Pruning Setting
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.entangled/config/app.toml
```

### Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:21858\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:21857\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:21860\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:21856\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":21866\"%" $HOME/.entangled/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:21817\"%; s%^address = \":8080\"%address = \":21880\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:21890\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:21891\"%; s%:8545%:21845%; s%:8546%:21846%; s%:6065%:21865%" $HOME/.entangled/config/app.toml
```

### Snapshot
```
curl -L https://snap.nodex.one/entangle-testnet/entangle-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.entangled
[[ -f $HOME/.entangled/data/upgrade-info.json ]] && cp $HOME/.entangled/data/upgrade-info.json $HOME/.entangled/cosmovisor/genesis/upgrade-info.json
```

### Start Node
```
sudo systemctl start entangle
journalctl -u entangle -f
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
