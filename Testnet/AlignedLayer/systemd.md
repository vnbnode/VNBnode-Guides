# AlignedLayer
Chain ID: `alignedlayer`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        16 GB             |
|   **SSD**   |        200 GB            |
| **NETWORK** |        100 Mbps          |

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
sed -i -e 's|^persistent_peers *=.*|persistent_peers ="c355b86c882d05a83f84afba379291d7b954b28f@65.108.236.43:26656,b499b9eb88c1c78ae25fdc7c390090f7542160eb@167.235.12.38:26656,18e1adeadb8cc596375e4212288fcd00690df067@213.199.48.195:26656"|' $HOME/.alignedlayer/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.0001stake\"|" $HOME/.alignedlayer/config/app.toml
```

### Pruning Setting
```
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
sudo tee /etc/systemd/system/alignedlayerd.service > /dev/null <<EOF
[Unit]
Description=alignedlayerd Daemon
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
sudo systemctl enable alignedlayerd
```

### Snapshot

### Start Node
```
sudo systemctl start alignedlayerd
journalctl -u alignedlayerd -f
```

### Create wallet
```
alignedlayerd keys add wallet
```

### Faucet: https://faucet.alignedlayer.com/

### Explorer: https://explorer.alignedlayer.com/alignedlayer

### Telegram: https://t.me/aligned_layer

### Create validator
```
cd $HOME
cd aligned_layer_tendermint
```
```
alignedlayerd tendermint show-validator
```

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/133b30b7-b830-4802-beac-7d8296b95c70)

Please create `validator.json`
```
nano $HOME/.alignedlayer/config/validator.json
```
```
{
    "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"xxxxxx"},
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
Edit line `cat << EOF > $NODE_HOME/config/validator.json`

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/75c51844-5bf2-4dfb-a8d0-a288081a0023)

```
cd $HOME && wget https://raw.githubusercontent.com/yetanotherco/aligned_layer_tendermint/main/setup_validator.sh
chmod +x setup_validator.sh
nano $HOME/setup_validator.sh
```
```
{
	"pubkey": $VALIDATOR_KEY,
	"amount": "$STAKING_AMOUNT",
	"moniker": $MONIKER,
	"identity": "06F5F34BD54AA6C7",
        "website": "https://vnbnode.com",
        "details": "VNBnode is a group of professional validators",
	"commission-rate": "0.1",
	"commission-max-rate": "0.2",
	"commission-max-change-rate": "0.01",
	"min-self-delegation": "1"
}
```
```
bash setup_validator.sh wallet 1050000stake
```

### Edit validator
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

### Remove Node
```
cd $HOME
sudo systemctl stop alignedlayerd
sudo systemctl disable alignedlayerd
sudo rm /etc/systemd/system/alignedlayerd.service
sudo systemctl daemon-reload
sudo rm -f $(which alignedlayerd)
sudo rm -rf $HOME/.alignedlayer
sudo rm -rf $HOME/aligned_layer_tendermint
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
