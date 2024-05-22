# Airchain
## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        8 GB              |
| **Storage** |        500 GB            |
| **NETWORK** |        1 Gbps            |
|   **OS**    |        Ubuntu 22.04      |
|   **Port**  |        10556             | 

## End Points

https://rpc-airchain.vnbnode.com

https://api-airchain.vnbnode.com

https://grpc-airchain.vnbnode.com

### Update and install packages for compiling
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/update-binary.sh)
```

### Build binary
```
wget https://github.com/airchains-network/junction/releases/download/v0.1.0/junctiond
chmod +x junctiond
mkdir -p $HOME/.junction/cosmovisor/genesis/bin
mv junctiond $HOME/.junction/cosmovisor/genesis/bin/
sudo ln -s $HOME/.junction/cosmovisor/genesis $HOME/.junction/cosmovisor/current -f
sudo ln -s $HOME/.junction/cosmovisor/current/bin/junctiond /usr/local/bin/junctiond -f
cd $HOME
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
sudo tee /etc/systemd/system/junction.service > /dev/null << EOF
[Unit]
Description=junction node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.junction"
Environment="DAEMON_NAME=junctiond"
Environment="UNSAFE_SKIP_BACKUP=true"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable junction
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
junctiond init $MONIKER --chain-id junction
```

### Download Genesis & Addrbook
```
rm $HOME/.junction/config/genesis.json
wget https://github.com/airchains-network/junction/releases/download/v0.1.0/genesis.json -O $HOME/.junction/config/genesis.json
```

### Configure
```
seeds=$(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/junction/seeds.txt)
sed -i.bak -e "s/^seeds *=.*/seeds = \"$seeds\"/" $HOME/.junction/config/config.toml
peers=$(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/junction/peers.txt)
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.junction/config/config.toml
sed -i.bak -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.junction/config/app.toml
sed -i.bak -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.junction/config/app.toml
sed -i.bak -e "s/^pruning-interval *=.*/pruning-interval = \"10\"/" $HOME/.junction/config/app.toml
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0amf\"/" $HOME/.junction/config/app.toml
sed -i "s/^indexer *=.*/indexer = \"kv\"/" $HOME/.junction/config/config.toml
```

### Custom Port
```
echo 'export junction="105"' >> ~/.bash_profile
source $HOME/.bash_profile
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://0.0.0.0:${junction}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${junction}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${junction}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${junction}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${junction}60\"%" $HOME/.junction/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${junction}17\"%; s%^address = \":8080\"%address = \":${junction}80\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:${junction}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${junction}91\"%; s%:8545%:${junction}45%; s%:8546%:${junction}46%; s%:6065%:${junction}65%" $HOME/.junction/config/app.toml
sed -i.bak -e "s%:1317%:${junction}17%g;
s%:8080%:${junction}80%g;
s%:9090%:${junction}90%g;
s%:9091%:${junction}91%g;
s%:8545%:${junction}45%g;
s%:8546%:${junction}46%g;
s%:6065%:${junction}65%g" $HOME/.junction/config/app.toml
sed -i.bak -e "s%:26658%:${junction}58%g;
s%:26657%:${junction}57%g;
s%:6060%:${junction}60%g;
s%:26656%:${junction}56%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${junction}56\"%;
s%:26660%:${junction}60%g" $HOME/.junction/config/config.toml
sed -i \
  -e 's|^chain-id *=.*|chain-id = "function"|' \
  -e 's|^keyring-backend *=.*|keyring-backend = "test"|' \
  -e 's|^node *=.*|node = "tcp://localhost:${junction}57"|' \
  $HOME/.junction/config/client.toml
```

### Start Node
```
sudo systemctl start junction
journalctl -u junction -f
```

### Backup Validator
```
mkdir -p $HOME/backup/.junction
cp $HOME/.junction/config/priv_validator_key.json $HOME/backup/.junction
```

### Remove Node
```
cd $HOME
sudo systemctl stop junction
sudo systemctl disable junction
sudo rm /etc/systemd/system/junction.service
sudo systemctl daemon-reload
sudo rm -f $(which junctiond)
sudo rm -rf $HOME/.junction
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
