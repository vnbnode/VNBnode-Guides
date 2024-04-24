# SIDE
Chain ID: `side-testnet-3`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        8 GB              |
|   **SSD**   |        500 GB            |
| **NETWORK** |        1 Gbps            |
|   **Port**  |        10456             |

### Update and install packages for compiling
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/update-binary.sh)
```

### Install Node
```
cd $HOME
rm -rf sidechain
git clone -b v0.7.0 https://github.com/sideprotocol/sidechain.git
cd sidechain
git checkout v0.7.0
make install
sided version
mkdir -p $HOME/.side/cosmovisor/genesis/bin
cp $HOME/go/bin/sided $HOME/.side/cosmovisor/genesis/bin/
sudo ln -s $HOME/.side/cosmovisor/genesis $HOME/.side/cosmovisor/current -f
sudo ln -s $HOME/.side/cosmovisor/current/bin/sided /usr/local/bin/sided -f
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
sudo tee /etc/systemd/system/side.service > /dev/null << EOF
[Unit]
Description=Side node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.side"
Environment="DAEMON_NAME=sided"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.side/cosmovisor/current/bin"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable side
```

### Initialize Node
Replace Yourmoniker with your own moniker
```
MONIKER="Name-VNBnode"
```
```
sided config chain-id side-testnet-3	
sided config keyring-backend test
```
```
sided init $MONIKER --chain-id=side-testnet-3
```

### Download Genesis & Addrbook
```
curl -Ls https://testnet-files.itrocket.net/side/genesis.json > $HOME/.side/config/genesis.json
curl -Ls https://testnet-files.itrocket.net/side/addrbook.json > $HOME/.side/config/addrbook.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"9c14080752bdfa33f4624f83cd155e2d3976e303@side-testnet-seed.itrocket.net:45656\"|" $HOME/.side/config/config.toml
peers=$(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Side/peers.txt)
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.side/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0001stake\"|" $HOME/.side/config/app.toml
sed -i \
  -e 's|^chain-id *=.*|chain-id = "side-testnet-3"|' \
  -e 's|^keyring-backend *=.*|keyring-backend = "test"|' \
  -e 's|^node *=.*|node = "tcp://localhost:24257"|' \
  $HOME/.side/config/client.toml
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.side/config/app.toml
```

### Custom Port
```
echo 'export side="104"' >> ~/.bash_profile
source $HOME/.bash_profile
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://0.0.0.0:${side}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${side}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${side}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${side}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${side}60\"%" $HOME/.side/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${side}17\"%; s%^address = \":8080\"%address = \":${side}80\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:${side}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${side}91\"%; s%:8545%:${side}45%; s%:8546%:${side}46%; s%:6065%:${side}65%" $HOME/.side/config/app.toml
sided config node tcp://localhost:${side}57
```

### Snapshot
```
cp $HOME/.side/data/priv_validator_state.json $HOME/.side/priv_validator_state.json.backup
rm -rf $HOME/.side/data && mkdir -p $HOME/.side/data
curl https://testnet-files.itrocket.net/side/snap_side.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.side
mv $HOME/.side/priv_validator_state.json.backup $HOME/.side/data/priv_validator_state.json
```

### Start Node
```
sudo systemctl start side
journalctl -fu side -o cat
```

### Backup Validator
```
mkdir -p $HOME/backup/side
cp $HOME/.side/config/priv_validator_key.json $HOME/backup/side
```

### Remove Node
```
cd $HOME
sudo systemctl stop side
sudo systemctl disable side
sudo rm /etc/systemd/system/side.service
sudo systemctl daemon-reload
sudo rm -f $(which side)
sudo rm -rf $HOME/.side
sudo rm -rf $HOME/sidechain
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
