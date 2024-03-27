# Structs
Chain ID: `structstestnet-74`

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
wget -O $HOME/structsd https://testnet-files.itrocket.net/structs/structsd
chmod +x $HOME/structsd
mv $HOME/structsd $HOME/go/bin
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
echo "export WALLET="wallet"" >> $HOME/.bash_profile
echo "export STRUCTS_CHAIN_ID="structstestnet-74"" >> $HOME/.bash_profile
echo "export STRUCTS_PORT="28"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
```
structsd config node tcp://localhost:${STRUCTS_PORT}657
structsd config keyring-backend os
structsd config chain-id structstestnet-74
structsd init $MONIKER --chain-id structstestnet-74
```
### Download Genesis & Addrbook
```
wget -O $HOME/.structs/config/genesis.json https://testnet-files.itrocket.net/structs/genesis.json
wget -O $HOME/.structs/config/addrbook.json https://testnet-files.itrocket.net/structs/addrbook.json
```

### Configure
```
SEEDS="6970514ab71570df64ccee301370a3b42d429111@structs-testnet-seed.itrocket.net:28656"
PEERS="268d132e1922cbfa86efac38aea07d1465b8728d@structs-testnet-peer.itrocket.net:28656,165b513c192eed40701c786689a2b8f25ca5a26c@65.109.122.105:14656,7a946f6d235e6197bbb3da6eff32873c2201a0ff@104.37.192.93:26656,bad0b99e60df4e46076665219eceb36a38fdbc0d@104.37.195.101:26656,0cad70bdb7962c9e501e5f4ffc6f1f0a56d53ba0@65.108.79.241:60556"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.structs/config/config.toml
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0.0alpha"|g' $HOME/.structs/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.structs/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.structs/config/config.toml
```

### Pruning Setting
```
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.structs/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.structs/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.structs/config/app.toml
```

### Custom Port
```
sed -i.bak -e "s%:1317%:${STRUCTS_PORT}317%g;
s%:8080%:${STRUCTS_PORT}080%g;
s%:9090%:${STRUCTS_PORT}090%g;
s%:9091%:${STRUCTS_PORT}091%g;
s%:8545%:${STRUCTS_PORT}545%g;
s%:8546%:${STRUCTS_PORT}546%g;
s%:6065%:${STRUCTS_PORT}065%g" $HOME/.structs/config/app.toml
sed -i.bak -e "s%:26658%:${STRUCTS_PORT}658%g;
s%:26657%:${STRUCTS_PORT}657%g;
s%:6060%:${STRUCTS_PORT}060%g;
s%:26656%:${STRUCTS_PORT}656%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${STRUCTS_PORT}656\"%;
s%:26660%:${STRUCTS_PORT}660%g" $HOME/.structs/config/config.toml
```

### Create service
```
sudo tee /etc/systemd/system/structsd.service > /dev/null <<EOF
[Unit]
Description=Structs node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.structs
ExecStart=$(which structsd) start --home $HOME/.structs
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable structsd
```

### Snapshot
```
structsd tendermint unsafe-reset-all --home $HOME/.structs
if curl -s --head curl https://testnet-files.itrocket.net/structs/snap_structs.tar.lz4 | head -n 1 | grep "200" > /dev/null; then
  curl https://testnet-files.itrocket.net/structs/snap_structs.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.structs
    else
  echo no have snap
fi
```
### Start Node
```
sudo systemctl start structsd 
journalctl -u structsd -f
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
