# OG

Run the node using systemd

## Chain ID: `zgtendermint_9000-1`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        8 GB              |
| **Storage** |        500 GB SSD        |
| **NETWORK** |        100 Mbps          |
|   **OS**    |   Ubuntu 20.04 - 22.04   |

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
evmosd init $MONIKER --chain-id zgtendermint_9000-1
evmosd config zgtendermint_9000-1
evmosd config keyring-backend os
echo 'export CHAIN_ID="zgtendermint_9000-1"' >> ~/.bash_profile
echo 'export WALLET_NAME="wallet"' >> ~/.bash_profile
source $HOME/.bash_profile
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
Edit the port to any number you like
```
port=21
```
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://0.0.0.0:${port}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${port}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:24260\"%; s%^laddr = \"tcp://0.0.0.0:${port}56\"%laddr = \"tcp://0.0.0.0:24256\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":24266\"%" $HOME/.evmosd/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:24217\"%; s%^address = \":8080\"%address = \":24280\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:24290\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:24291\"%; s%:8545%:24245%; s%:8546%:24246%; s%:6065%:24265%" $HOME/.evmosd/config/app.toml
evmosd config node tcp://localhost:${port}57
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

### Create wallet
```
evmosd keys add $WALLET_NAME
evmosd keys list
```

### Faucet
```
echo "0x$(evmosd debug addr $(evmosd keys show wallet -a) | grep hex | awk '{print $3}')"
```
![image](https://github.com/vnbnode/docs/assets/76662222/007a32ee-fc07-454e-b8ee-f9202e722e07)

[Link Faucet](https://faucet.0g.ai)

### Create validator
```
evmosd tx staking create-validator \
  --amount=10000000000000000aevmos \
  --commission-max-change-rate 0.01 \
  --commission-max-rate 0.1 \
  --commission-rate 0.1 \
  --from $WALLET_NAME \
  --min-self-delegation 1 \
  --moniker $MONIKER \
  --security-contact "" \
  --identity "06F5F34BD54AA6C7" \
  --website "https://vnbnode.com" \
  --details "VNBnode is a group of professional validators" \
  --pubkey $(evmosd tendermint show-validator) \
  --chain-id zgtendermint_9000-1 \
  --gas=500000 --gas-prices=99999aevmos \
  -y
```

Delegate
```
evmosd tx staking delegate fairyvaloper1l89kp2ut04s8svltg9j9ue3z88hejypnnjk8c4 10000000000000000aevmos --from wallet --gas auto --gas-adjustment 1.5 --gas-prices=99999aevmos --chain-id zgtendermint_9000-1
```
Unjail
```
evmosd tx slashing unjail --from wallet --chain-id zgtendermint_9000-1 --gas-adjustment 1.4 --gas auto --gas-prices=99999aevmos -y
```
Edit validator
```
evmosd tx staking edit-validator \
--new-moniker "NewName-VNBnode" \
--identity "06F5F34BD54AA6C7" \
--website "https://vnbnode.com" \
--details "VNBnode is a group of professional validators" \
--security-contact "" \
--commission-rate 0.05 \
--from $WALLET_NAME \
--gas-adjustment 1.4 \
-chain-id zgtendermint_9000-1 \
--gas=500000 --gas-prices=99999aevmos \
-y
```

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
