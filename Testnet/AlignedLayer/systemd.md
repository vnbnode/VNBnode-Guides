# AlignedLayer

### Website: https://alignedlayer.com

### Telegram: https://t.me/aligned_layer

### Twitter: https://twitter.com/alignedlayer

### Faucet: https://faucet.alignedlayer.com

### Explorer: https://explorer.alignedlayer.com/alignedlayer

## Chain ID: `alignedlayer`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        16 GB             |
|   **SSD**   |        200 GB            |
| **NETWORK** |        100 Mbps          |
|   **Port**  | 24256, 24257, 24258 (Local please open)|

### Update and install packages for compiling
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/update-binary.sh)
```

### Build binary
```
cd $HOME
rm -rf $HOME/aligned_layer_tendermint && wget https://github.com/yetanotherco/aligned_layer_tendermint/releases/download/v0.1.0/alignedlayerd && chmod +x alignedlayerd
mv alignedlayerd $HOME/go/bin/
alignedlayerd version
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
alignedlayerd init $MONIKER --chain-id alignedlayer
```
```
sed -i \
  -e 's|^chain-id *=.*|chain-id = "alignedlayer"|' \
  -e 's|^keyring-backend *=.*|keyring-backend = "test"|' \
  -e 's|^node *=.*|node = "tcp://localhost:24257"|' \
  $HOME/.alignedlayer/config/client.toml
```

### Download Genesis & Addrbook
```
curl -Ls https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/AlignedLayer/genesis.json > $HOME/.alignedlayer/config/genesis.json
curl -Ls https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/AlignedLayer/addrbook.json > $HOME/.alignedlayer/config/addrbook.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:24210\"|" $HOME/.alignedlayer/config/config.toml
sed -i -e 's|^persistent_peers *=.*|persistent_peers ="d5f2890998932efb906eaa0070030ef3b5480a72@176.57.150.2:24256,6190cd77e6f17763fa6553f355bb4c8088560068@62.171.130.196:24256,68f7bbbeaa79fe5d1043d67f0ad75c03fce8d078@109.199.118.239:24256,2514706bb8a168d3e12e07c66e37a9b585abeeb4@37.60.232.236:24256"|' $HOME/.alignedlayer/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0001stake\"|" $HOME/.alignedlayer/config/app.toml
sed -i \
  -e 's|^chain-id *=.*|chain-id = "alignedlayer"|' \
  -e 's|^keyring-backend *=.*|keyring-backend = "test"|' \
  -e 's|^node *=.*|node = "tcp://localhost:24257"|' \
  $HOME/.alignedlayer/config/client.toml
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.alignedlayer/config/app.toml
```

### Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://0.0.0.0:24258\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:24257\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:24260\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:24256\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":24266\"%" $HOME/.alignedlayer/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:24217\"%; s%^address = \":8080\"%address = \":24280\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:24290\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:24291\"%; s%:8545%:24245%; s%:8546%:24246%; s%:6065%:24265%" $HOME/.alignedlayer/config/app.toml
```

### Create service
```
sudo tee /etc/systemd/system/alignedlayer.service > /dev/null <<EOF
[Unit]
Description=alignedlayer Daemon
After=network-online.target
[Service]
User=$USER
ExecStart=$(which alignedlayerd) start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable alignedlayer
```

### Snapshot
```
cp $HOME/.alignedlayer/data/priv_validator_state.json $HOME/.alignedlayer/priv_validator_state.json.backup
rm -rf $HOME/.alignedlayer/data && mkdir -p $HOME/.alignedlayer/data
curl -L https://snap.vnbnode.com/alignedlayer/alignedlayer_snapshot_latest.tar.lz4 | tar -I lz4 -xf - -C $HOME/.alignedlayer/data
mv $HOME/.alignedlayer/priv_validator_state.json.backup $HOME/.alignedlayer/data/priv_validator_state.json
```

### Start Node
```
sudo systemctl start alignedlayer
journalctl -u alignedlayer -f
```

### Create wallet
```
alignedlayerd keys add wallet
```

### Create validator.json
```
cd $HOME
alignedlayerd tendermint show-validator
```

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/b64a2a03-e384-4b8b-b962-22bad6cfe422)

Please create `validator.json` replace {...} inside like below
```
nano $HOME/.alignedlayer/config/validator.json
```
```
{
    "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"IkGeamll8JFsV5jqoT37JfI37Ey/viBTZJLvLv8hlF0="},
    "amount": "1000000stake",
    "moniker": "Name-VNBnode",
    "identity": "06F5F34BD54AA6C7",
    "website": "https://vnbnode.com",
    "details": "VNBnode is a group of professional validators",
    "commission-rate": "0.1",
    "commission-max-rate": "0.2",
    "commission-max-change-rate": "0.01",
    "min-self-delegation": "1"
}
```
### Proceed to create validation
```
alignedlayerd tx staking create-validator $HOME/.alignedlayer/config/validator.json \
--from wallet --chain-id alignedlayer \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.0001stake
--node tcp://rpc-node.alignedlayer.com:26657
```
### Command
Delegate
```
alignedlayerd tx staking delegate $(alignedlayerd keys show wallet --bech val -a) 1000000stake --from wallet --chain-id alignedlayer --gas-adjustment 1.4 --gas auto --gas-prices 0.0001stake -y
```
Unjail
```
alignedlayerd tx slashing unjail --from wallet --chain-id alignedlayer --gas-adjustment 1.4 --gas auto --gas-prices 0.0001stake -y
```
Edit validator
```
alignedlayerd tx staking edit-validator \
--new-moniker "Name-VNBnode" \
--identity "06F5F34BD54AA6C7" \
--website "https://vnbnode.com" \
--details "VNBnode is a group of professional validators" \
--security-contact "email" \
--chain-id alignedlayer \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.0001stake \
-y
```

### Backup Validator
```
mkdir $HOME/backup
cp $HOME/.alignedlayer/config/priv_validator_key.json $HOME/backup
cp $HOME/.alignedlayer/data/priv_validator_state.json.json $HOME/backup
```

### Remove Node
```
cd $HOME
sudo systemctl stop alignedlayer
sudo systemctl disable alignedlayer
sudo rm /etc/systemd/system/alignedlayer.service
sudo systemctl daemon-reload
sudo rm $HOME/go/bin/alignedlayerd
sudo rm -f $(which alignedlayerd)
sudo rm -rf $HOME/.alignedlayer
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
