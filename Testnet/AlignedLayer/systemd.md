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
rm -rf $HOME/aligned_layer_tendermint && wget https://github.com/yetanotherco/aligned_layer_tendermint/releases/download/v0.1.0/alignedlayerd && chmod +x alignedlayerd
mkdir -p $HOME/.alignedlayer/cosmovisor/genesis/bin
mv alignedlayerd $HOME/.alignedlayer/cosmovisor/genesis/bin/
sudo ln -s $HOME/.alignedlayer/cosmovisor/genesis $HOME/.alignedlayer/cosmovisor/current -f
sudo ln -s $HOME/.alignedlayer/cosmovisor/current/bin/alignedlayerd /usr/local/bin/alignedlayerd -f
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```
```
sudo tee /etc/systemd/system/alignedlayer.service > /dev/null << EOF
[Unit]
Description=alignedlayer node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.alignedlayer"
Environment="DAEMON_NAME=alignedlayerd"
Environment="UNSAFE_SKIP_BACKUP=true"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable alignedlayer
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
curl -Ls https://snap.nodex.one/alignedlayer-testnet/genesis.json > $HOME/.alignedlayer/config/genesis.json
curl -Ls https://snap.nodex.one/alignedlayer-testnet/addrbook.json > $HOME/.alignedlayer/config/addrbook.json 
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
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:24258\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:24257\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:24260\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:24256\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":24266\"%" $HOME/.alignedlayer/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:24217\"%; s%^address = \":8080\"%address = \":24280\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:24290\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:24291\"%; s%:8545%:24245%; s%:8546%:24246%; s%:6065%:24265%" $HOME/.alignedlayer/config/app.toml
```

### Snapshot
```
curl -L https://snap.nodex.one/alignedlayer-testnet/alignedlayer-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.alignedlayer
[[ -f $HOME/.alignedlayer/data/upgrade-info.json ]] && cp $HOME/.alignedlayer/data/upgrade-info.json $HOME/.alignedlayer/cosmovisor/genesis/upgrade-info.json
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

### Faucet: https://faucet.alignedlayer.com/

### Explorer: https://testnet.alignedlayer.explorers.guru/validators

### Telegram: https://t.me/aligned_layer

### Create validator
```
cd $HOME
cd aligned_layer_tendermint
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

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
