# Warden
Run the node using systemd

Chain ID: `alfama`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        4 GB              |
|   **SSD**   |        200 GB            |
| **NETWORK** |        100 Mbps          |
|   **OS**    |        Ubuntu 22.04      |
|   **Port**  |        10356             | 

### Update and install packages for compiling
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/update-binary.sh)
```

### Build binary
```
cd $HOME
rm -rf wardenprotocol
git clone --depth 1 --branch v0.3.0 https://github.com/warden-protocol/wardenprotocol/
cd wardenprotocol/cmd/wardend
go build
mkdir -p $HOME/.warden/cosmovisor/genesis/bin
cp $HOME/wardenprotocol/cmd/wardend/wardend $HOME/.warden/cosmovisor/genesis/bin/
sudo ln -s $HOME/.warden/cosmovisor/genesis $HOME/.warden/cosmovisor/current -f
sudo ln -s $HOME/.warden/cosmovisor/current/bin/wardend /usr/local/bin/wardend -f
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
sudo tee /etc/systemd/system/warden.service > /dev/null << EOF
[Unit]
Description=warden node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.warden"
Environment="DAEMON_NAME=wardend"
Environment="UNSAFE_SKIP_BACKUP=true"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable warden
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
wardend config chain-id buenavista-1
wardend config keyring-backend test 
wardend init $MONIKER --chain-id buenavista-1
```

### Download Genesis & Addrbook
```
curl -Ls https://testnet-files.itrocket.net/warden/genesis.json > $HOME/.warden/config/genesis.json
curl -Ls https://testnet-files.itrocket.net/warden/addrbook.json > $HOME/.warden/config/addrbook.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:24010\"|" $HOME/.warden/config/config.toml
peers=$(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Warden/peers.txt)
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.warden/config//config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025uward\"|" $HOME/.warden/config/app.toml
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.warden/config/app.toml
```

### Custom Port
```
echo 'export warden="103"' >> ~/.bash_profile
source $HOME/.bash_profile
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://0.0.0.0:${warden}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${warden}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${warden}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${warden}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${warden}60\"%" $HOME/.warden/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${warden}17\"%; s%^address = \":8080\"%address = \":${warden}80\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:${warden}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${warden}91\"%; s%:8545%:${warden}45%; s%:8546%:${warden}46%; s%:6065%:${warden}65%" $HOME/.warden/config/config.toml
wardend config node tcp://localhost:${warden}57
```

### Snapshot
```
cp $HOME/.warden/data/priv_validator_state.json $HOME/.warden/priv_validator_state.json.backup
wardend tendermint unsafe-reset-all --home $HOME/.warden
rm -rf $HOME/.warden/data $HOME/.warden/wasmPath
curl https://testnet-files.itrocket.net/warden/snap_warden.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.warden
mv $HOME/.warden/priv_validator_state.json.backup $HOME/.warden/data/priv_validator_state.json
```

### Start Node
```
sudo systemctl start warden
journalctl -u warden -f
```

### Backup Validator
```
mkdir -p $HOME/backup/warden
cp $HOME/.warden/config/priv_validator_key.json $HOME/backup/warden
```

### Remove Node
```
cd $HOME
sudo systemctl stop warden
sudo systemctl disable warden
sudo rm /etc/systemd/system/warden.service
sudo systemctl daemon-reload
sudo rm -f $(which warden)
sudo rm -rf $HOME/.warden
sudo rm -rf $HOME/wardenprotocol
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
