# Ojo Network
Chain ID: `agamotto`

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
rm -rf ojo
git clone https://github.com/ojo-network/ojo.git
cd ojo
git checkout v0.3.0-rc5
make build
mkdir -p $HOME/.ojo/cosmovisor/genesis/bin
mv build/ojod $HOME/.ojo/cosmovisor/genesis/bin/
rm -rf build
sudo ln -s $HOME/.ojo/cosmovisor/genesis $HOME/.ojo/cosmovisor/current -f
sudo ln -s $HOME/.ojo/cosmovisor/current/bin/ojod /usr/local/bin/ojod -f
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```

```
sudo tee /etc/systemd/system/ojo.service > /dev/null << EOF
[Unit]
Description=ojo node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.ojo"
Environment="DAEMON_NAME=ojod"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.ojo/cosmovisor/current/bin"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable ojo
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
ojod config chain-id agamotto
ojod config keyring-backend test
ojod config node tcp://localhost:20857
```
```
ojod init $MONIKER --chain-id agamotto
```

### Download Genesis & Addrbook
```
curl -Ls https://snap.nodex.one/ojo-testnet/genesis.json > $HOME/.ojo/config/genesis.json
curl -Ls https://snap.nodex.one/ojo-testnet/addrbook.json > $HOME/.ojo/config/addrbook.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:20810\"|" $HOME/.ojo/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0uojo\"|" $HOME/.ojo/config/app.toml
```

### Pruning Setting
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.ojo/config/app.toml
```

### Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:20858\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:20857\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:20860\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:20856\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":20866\"%" $HOME/.ojo/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:20817\"%; s%^address = \":8080\"%address = \":20880\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:20890\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:20891\"%; s%:8545%:20845%; s%:8546%:20846%; s%:6065%:20865%" $HOME/.ojo/config/app.toml
```

### Snapshot
```
curl -L https://snap.nodex.one/ojo-testnet/ojo-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.ojo
[[ -f $HOME/.ojo/data/upgrade-info.json ]] && cp $HOME/.ojo/data/upgrade-info.json $HOME/.ojo/cosmovisor/genesis/upgrade-info.json
```

### Start Node
```
sudo systemctl start ojo
journalctl -u ojo -f
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
