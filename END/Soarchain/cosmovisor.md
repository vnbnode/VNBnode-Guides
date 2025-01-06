# Soarchain
Run the node using systemd

Chain ID: `soarchaintestnet`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        4 GB              |
|   **SSD**   |        200 GB            |
| **NETWORK** |        100 Mbps          |
|   **OS**    |        Ubuntu 22.04      |

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
wget https://snap.nodex.one/soarchain-testnet/soarchaind
chmod +x soarchaind
sudo wget -O /usr/lib/libwasmvm.x86_64.so https://github.com/CosmWasm/wasmvm/releases/download/v1.3.0/libwasmvm.x86_64.so
mkdir -p $HOME/.soarchain/cosmovisor/genesis/bin
mv soarchaind $HOME/.soarchain/cosmovisor/genesis/bin/
rm -rf build
sudo ln -s $HOME/.soarchain/cosmovisor/genesis $HOME/.soarchain/cosmovisor/current -f
sudo ln -s $HOME/.soarchain/cosmovisor/current/bin/soarchaind /usr/local/bin/soarchaind -f
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```

```
sudo tee /etc/systemd/system/soarchain.service > /dev/null << EOF
[Unit]
Description=soarchain node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.soarchain"
Environment="DAEMON_NAME=soarchaind"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.soarchain/cosmovisor/current/bin"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable soarchain
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
soarchaind config chain-id soarchaintestnet
soarchaind config keyring-backend test
soarchaind config node tcp://localhost:23557
```
```
soarchaind init $MONIKER --chain-id soarchaintestnet
```

### Download Genesis & Addrbook
```
curl -Ls https://snap.nodex.one/soarchain-testnet/genesis.json > $HOME/.soarchain/config/genesis.json
curl -Ls https://snap.nodex.one/soarchain-testnet/addrbook.json > $HOME/.soarchain/config/addrbook.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:23510\"|" $HOME/.soarchain/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0001utmotus\"|" $HOME/.soarchain/config/app.toml
sed -i -e "s|^timeout_commit *=.*|timeout_commit = \"15s\"|" $HOME/.soarchain/config/app.toml
```

### Pruning Setting
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.soarchain/config/app.toml
```

### Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:23558\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:23557\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:23560\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:23556\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":23566\"%" $HOME/.soarchain/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:23517\"%; s%^address = \":8080\"%address = \":23580\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:23590\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:23591\"%; s%:8545%:23545%; s%:8546%:23546%; s%:6065%:23565%" $HOME/.soarchain/config/app.toml
```

### Snapshot
```
curl -L https://snap.nodex.one/soarchain-testnet/soarchain-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.soarchain
[[ -f $HOME/.soarchain/data/upgrade-info.json ]] && cp $HOME/.soarchain/data/upgrade-info.json $HOME/.soarchain/cosmovisor/genesis/upgrade-info.json
```

### Start Node
```
sudo systemctl start soarchain
journalctl -u soarchain -f
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
