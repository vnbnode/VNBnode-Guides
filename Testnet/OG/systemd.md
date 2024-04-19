# OG

Run the node using systemd

## Chain ID: `zgtendermint_9000-1`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        8 GB              |
| **Storage** |    500 GB SSD or Nvme    |
| **NETWORK** |        100 Mbps          |
|   **OS**    |   Ubuntu 20.04 - 22.04   |
|   **Port**  |          10156           |

### Update and install packages for compiling
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/update-binary.sh)
```

### Build binary
```
git clone https://github.com/0glabs/0g-evmos.git
cd 0g-evmos
git checkout v1.0.0-testnet
make install
evmosd version
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
echo 'export CHAIN_ID="zgtendermint_9000-1"' >> ~/.bash_profile
echo 'export WALLET_NAME="wallet"' >> ~/.bash_profile
source $HOME/.bash_profile
evmosd init $MONIKER --chain-id $CHAIN_ID
evmosd config chain-id $CHAIN_ID
evmosd config keyring-backend test 
```

### Download Genesis & Addrbook
```
wget https://github.com/0glabs/0g-evmos/releases/download/v1.0.0-testnet/genesis.json -O $HOME/.evmosd/config/genesis.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"1248487ea585730cdf5d3c32e0c2a43ad0cda973@peer-zero-gravity-testnet.trusted-point.com:26326\"|" $HOME/.evmosd/config/config.toml
peers=$(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/OG/peers.txt)
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.evmosd/config/config.toml
sed -i.bak -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.evmosd/config/app.toml
sed -i.bak -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.evmosd/config/app.toml
sed -i.bak -e "s/^pruning-interval *=.*/pruning-interval = \"10\"/" $HOME/.evmosd/config/app.toml
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00252aevmos\"/" $HOME/.evmosd/config/app.toml
sed -i "s/^indexer *=.*/indexer = \"kv\"/" $HOME/.evmosd/config/config.toml
```

### Custom Port
```
echo 'export og="101"' >> ~/.bash_profile
source $HOME/.bash_profile
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://0.0.0.0:${og}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${og}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${og}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${og}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${og}60\"%" $HOME/.evmosd/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${og}17\"%; s%^address = \":8080\"%address = \":${og}80\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:${og}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${og}91\"%; s%:8545%:${og}45%; s%:8546%:${og}46%; s%:6065%:${og}65%" $HOME/.evmosd/config/app.toml
evmosd config node tcp://localhost:${og}57
```

### Create service
```
sudo tee /etc/systemd/system/og.service > /dev/null <<EOF
[Unit]
Description=OG Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$(which evmosd) start --home $HOME/.evmosd
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable og
```

### Snapshot
```
cp $HOME/.evmosd/data/priv_validator_state.json $HOME/.evmosd/priv_validator_state.json.backup
rm -rf $HOME/.evmosd/data && mkdir -p $HOME/.fairyring/data
evmosd tendermint unsafe-reset-all --home $HOME/.evmosd --keep-addr-book
wget https://rpc-zero-gravity-testnet.trusted-point.com/latest_snapshot.tar.lz4
lz4 -d -c ./latest_snapshot.tar.lz4 | tar -xf - -C $HOME/.evmosd
mv $HOME/.evmosd/priv_validator_state.json.backup $HOME/.evmosd/data/priv_validator_state.json
```

### Start Node
```
sudo systemctl start og
journalctl -u og -f
```

### Faucet
```
echo "0x$(evmosd debug addr $(evmosd keys show wallet -a) | grep hex | awk '{print $3}')"
```

Link Faucet: https://faucet.0g.ai

### Backup Validator
```
mkdir -p $HOME/backup/evmosd
cp $HOME/.evmosd/config/priv_validator_key.json $HOME/backup/evmosd
```

### Remove Node
```
cd $HOME
sudo systemctl stop og
sudo systemctl disable og
sudo rm /etc/systemd/system/og.service
sudo systemctl daemon-reload
sudo rm $HOME/go/bin/evmosd
sudo rm -f $(which evmosd)
sudo rm -rf $HOME/.evmosd
sudo rm -rf $HOME/0g-evmos
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
