# Initia

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        16 GB             |
| **Storage** |        1 TB SSD          |
| **NETWORK** |        100 Mbps          |
|   **OS**    |        Ubuntu 22.04      |
|   **Port**  |        10656             | 

## End Points

https://rpc-initia.vnbnode.com

https://api-initia.vnbnode.com

https://grpc-initia.vnbnode.com

### Update and install packages for compiling
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/update-binary.sh)
```

### Build binary
```
git clone -b v0.2.11 https://github.com/initia-labs/initia.git
cd initia
git checkout v0.2.11
make install
mkdir -p $HOME/.initia/cosmovisor/genesis/bin
cp $HOME/go/bin/initiad $HOME/.initia/cosmovisor/genesis/bin/
sudo ln -s $HOME/.initia/cosmovisor/genesis $HOME/.initia/cosmovisor/current -f
sudo ln -s $HOME/.initia/cosmovisor/current/bin/initiad /usr/local/bin/initiad -f
cd $HOME
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
sudo tee /etc/systemd/system/initia.service > /dev/null << EOF
[Unit]
Description=initia node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.initia"
Environment="DAEMON_NAME=initiad"
Environment="UNSAFE_SKIP_BACKUP=true"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable initia
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
initiad init $MONIKER --chain-id initation-1
```

### Download Genesis & Addrbook
```
wget https://initia.s3.ap-southeast-1.amazonaws.com/initiation-1/genesis.json -O $HOME/.initia/config/genesis.json
wget https://rpc-initia-testnet.trusted-point.com/addrbook.json -O $HOME/.initia/config/addrbook.json
```

### Configure
```
seeds=$(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Initia/seeds.txt)
sed -i.bak -e "s/^seeds *=.*/seeds = \"$seeds\"/" $HOME/.initia/config/config.toml
peers=$(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Initia/peers.txt)
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.initia/config/config.toml
sed -i.bak -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.initia/config/app.toml
sed -i.bak -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.initia/config/app.toml
sed -i.bak -e "s/^pruning-interval *=.*/pruning-interval = \"10\"/" $HOME/.initia/config/app.toml
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0amf\"/" $HOME/.initia/config/app.toml
sed -i "s/^indexer *=.*/indexer = \"kv\"/" $HOME/.initia/config/config.toml
sed -i \
  -e 's|^chain-id *=.*|chain-id = "initation-1"|' \
  -e 's|^keyring-backend *=.*|keyring-backend = "test"|' \
  -e 's|^node *=.*|node = "tcp://localhost:10657"|' \
  $HOME/.initia/config/client.toml
```

### Custom Port
```
echo 'export initia="106"' >> ~/.bash_profile
source $HOME/.bash_profile
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://0.0.0.0:${initia}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${initia}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${initia}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${initia}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${initia}60\"%" $HOME/.initia/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${initia}17\"%; s%^address = \":8080\"%address = \":${initia}80\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:${initia}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${initia}91\"%; s%:8545%:${initia}45%; s%:8546%:${initia}46%; s%:6065%:${initia}65%" $HOME/.initia/config/app.toml
```

### Start Node
```
sudo systemctl start initia
journalctl -u initia -f
```

### Backup Validator
```
mkdir -p $HOME/backup/.initia
cp $HOME/.initia/config/priv_validator_key.json $HOME/backup/.initia
```

### Remove Node
```
cd $HOME
sudo systemctl stop initia
sudo systemctl disable initia
sudo rm /etc/systemd/system/initia.service
sudo systemctl daemon-reload
sudo rm -f $(which initiad)
sudo rm -rf $HOME/.initia
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
