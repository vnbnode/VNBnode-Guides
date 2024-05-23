# 0G

### Snapshot: https://github.com/vnbnode/VNBnode-Guides/blob/main/Testnet/0G/Snapshot.md

## End Points

https://rpc-0g.vnbnode.com

https://api-0g.vnbnode.com

https://grpc-0g.vnbnode.com

## Explorer

https://explorer.vnbnode.com/OG-Testnet

## Chain ID: `zgtendermint_16600-1`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        64 GB             |
| **Storage** |        1 TB Nvme         |
| **NETWORK** |        1 Gbps            |
|   **OS**    |        Ubuntu 22.04      |
|   **Port**  |        10156             | 

### Update and install packages for compiling
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/update-binary.sh)
```

### Build binary
```
git clone -b v0.1.0 https://github.com/0glabs/0g-chain.git
git checkout v1.0.0-testnet
cd 0g-chain
make install
mkdir -p $HOME/.0gchain/cosmovisor/genesis/bin
cp $HOME/go/bin/0gchaind $HOME/.0gchain/cosmovisor/genesis/bin/
sudo ln -s $HOME/.0gchain/cosmovisor/genesis $HOME/.0gchain/cosmovisor/current -f
sudo ln -s $HOME/.0gchain/cosmovisor/current/bin/0gchaind /usr/local/bin/0gchaind -f
cd $HOME
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
sudo tee /etc/systemd/system/0g.service > /dev/null << EOF
[Unit]
Description=0G node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.0gchain"
Environment="DAEMON_NAME=0gchaind"
Environment="UNSAFE_SKIP_BACKUP=true"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable 0g
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
echo 'export CHAIN_ID="zgtendermint_16600-1"' >> ~/.bash_profile
echo 'export WALLET_NAME="wallet"' >> ~/.bash_profile
source $HOME/.bash_profile
0gchaind init $MONIKER --chain-id $CHAIN_ID
0gchaind config chain-id $CHAIN_ID
0gchaind config keyring-backend test
```

### Download Genesis & Addrbook
```
rm $HOME/.0gchain/config/genesis.json
wget https://github.com/0glabs/0g-chain/releases/download/v0.1.0/genesis.json -O $HOME/.0gchain/config/genesis.json
```

### Configure
```
seeds=$(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/OG/seeds.txt)
sed -i.bak -e "s/^seeds *=.*/seeds = \"$seeds\"/" $HOME/.0gchain/config/config.toml
peers=$(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/OG/peers.txt)
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.0gchain/config/config.toml
sed -i.bak -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.0gchain/config/app.toml
sed -i.bak -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.0gchain/config/app.toml
sed -i.bak -e "s/^pruning-interval *=.*/pruning-interval = \"10\"/" $HOME/.0gchain/config/app.toml
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ua0gi\"/" $HOME/.0gchain/config/app.toml
sed -i "s/^indexer *=.*/indexer = \"kv\"/" $HOME/.0gchain/config/config.toml
```

### Custom Port
```
echo 'export 0g="101"' >> ~/.bash_profile
source $HOME/.bash_profile
sed -i.bak -e "s%:1317%:${0g}17%g;
s%:8080%:${0g}80%g;
s%:9090%:${0g}90%g;
s%:9091%:${0g}91%g;
s%:8545%:${0g}45%g;
s%:8546%:${0g}46%g;
s%:6065%:${0g}65%g" $HOME/.0gchain/config/app.toml
sed -i.bak -e "s%:26658%:${0g}58%g;
s%:26657%:${0g}57%g;
s%:6060%:${0g}60%g;
s%:26656%:${0g}56%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${0g}56\"%;
s%:26660%:${0g}60%g" $HOME/.0gchain/config/config.toml
sed -i \
  -e 's|^node *=.*|node = "tcp://localhost:10157"|' \
  $HOME/.0gchain/config/client.toml
```

### Start Node
```
sudo systemctl start 0g
journalctl -u 0g -f
```

### Backup Validator
```
mkdir -p $HOME/backup/.0gchain
cp $HOME/.0gchain/config/priv_validator_key.json $HOME/backup/.0gchain
```

### Remove Node
```
cd $HOME
sudo systemctl stop 0g
sudo systemctl disable 0g
sudo rm /etc/systemd/system/0g.service
sudo systemctl daemon-reload
sudo rm $HOME/go/bin/0gchaind
sudo rm -f $(which 0gchaind)
sudo rm -rf $HOME/0g-chain
sudo rm -rf $HOME/.0gchain
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
