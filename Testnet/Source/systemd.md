# Source
Chain ID: `sourcetest-1`

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
rm -rf source
git clone https://github.com/Source-Protocol-Cosmos/source.git
cd source
git checkout v3.0.1
make install
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
echo "export WALLET="wallet"" >> $HOME/.bash_profile
echo "export SOURCE_CHAIN_ID="sourcetest-1"" >> $HOME/.bash_profile
echo "export SOURCE_PORT="24"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
```
sourced config node tcp://localhost:${SOURCE_PORT}657
sourced config keyring-backend os
sourced config chain-id sourcetest-1
sourced init $MONIKER --chain-id sourcetest-1
```
### Download Genesis & Addrbook
```
wget -O $HOME/.source/config/genesis.json https://testnet-files.itrocket.net/source/genesis.json
wget -O $HOME/.source/config/addrbook.json https://testnet-files.itrocket.net/source/addrbook.json
```

### Configure
```
SEEDS="eca738b67fd23381f9a72717bea757c1d291ed2b@source-testnet-seed.itrocket.net:24656"
PEERS="a47f3b354e75478c0dfe22ad2b937ad07c9bcf3c@source-testnet-peer.itrocket.net:24656,e127f3f7277b76887423458d8f775e33f58ff80a@65.109.65.248:28656,c491f30afac53c66ce5ed8650591e5275fd4b42b@75.119.132.25:34656,854048fcfb453297742b76cc5c6b7555eeb25110@213.239.207.175:31656,c5eccf228a25f979592297311bfe2cc8ef94e482@95.111.229.159:26656,0e03201599c8b4314b66c90639b0d776e6691ba2@164.92.98.17:26656,8145d4d13511e7f89dbd257f51ed5d076941f12f@164.92.98.12:26656,330b14f94d3bbe6c4059f31bd8fbf9960cf1387e@185.144.99.3:26656,1107d5a5e05113d7fd4520ad0756685da387f0e8@212.23.222.220:26356"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.source/config/config.toml
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "1usource"|g' $HOME/.source/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.source/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.source/config/config.toml
```

### Pruning Setting
```
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.source/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.source/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.source/config/app.toml
```

### Custom Port
```
sed -i.bak -e "s%:1317%:${SOURCE_PORT}317%g;
s%:8080%:${SOURCE_PORT}080%g;
s%:9090%:${SOURCE_PORT}090%g;
s%:9091%:${SOURCE_PORT}091%g;
s%:8545%:${SOURCE_PORT}545%g;
s%:8546%:${SOURCE_PORT}546%g;
s%:6065%:${SOURCE_PORT}065%g" $HOME/.source/config/app.toml
sed -i.bak -e "s%:26658%:${SOURCE_PORT}658%g;
s%:26657%:${SOURCE_PORT}657%g;
s%:6060%:${SOURCE_PORT}060%g;
s%:26656%:${SOURCE_PORT}656%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${SOURCE_PORT}656\"%;
s%:26660%:${SOURCE_PORT}660%g" $HOME/.source/config/config.toml
```

### Create service
```
sudo tee /etc/systemd/system/sourced.service > /dev/null <<EOF
[Unit]
Description=Source node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.source
ExecStart=$(which sourced) start --home $HOME/.source
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable sourced
```

### Snapshot
```
sourced tendermint unsafe-reset-all --home $HOME/.source
if curl -s --head curl https://testnet-files.itrocket.net/source/snap_source.tar.lz4 | head -n 1 | grep "200" > /dev/null; then
  curl https://testnet-files.itrocket.net/source/snap_source.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.source
    else
  echo no have snap
fi
```
### Start Node
```
sudo systemctl start sourced
journalctl -u sourced -f
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
