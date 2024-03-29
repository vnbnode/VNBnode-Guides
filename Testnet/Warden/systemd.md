# WARDEN
Chain ID: `alfama`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        4 GB              |
|   **SSD**   |        200 GB            |
| **NETWORK** |        100 Mbps          |

### Update and install packages for compiling
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/update-binary.sh)
```

### Build binary
```
cd $HOME
rm -rf wardenprotocol
git clone --depth 1 --branch v0.2.0 https://github.com/warden-protocol/wardenprotocol/
cd wardenprotocol/cmd/wardend
go build
mv wardend $HOME/go/bin
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
wardend init $MONIKER --chain-id alfama
```
### Download Genesis & Addrbook
```
curl -Ls https://testnet-files.itrocket.net/warden/genesis.json > $HOME/.warden/config/genesis.json
curl -Ls https://testnet-files.itrocket.net/warden/addrbook.json > $HOME/.warden/config/addrbook.json
```

### Configure
```
SEEDS="ff0885377c44d58164f29d356b9d3d3a755c6213@warden-testnet-seed.itrocket.net:18656"
PEERS="f995c84635c099329bfaaa255389d63e052cb0ac@warden-testnet-peer.itrocket.net:18656,55c5b6ab09002dfba354ff924775ea9ba319f226@81.31.197.120:26656,9eb15351ad2d1fd9cd866e4f9e4153f6dddcf151@51.178.92.69:16656,4b5777664aacfeeb76a51dea8d1264c2983e6aed@65.109.104.111:56103,225054d5ddf2386762450e21075c0e8677c3d0fc@144.76.29.90:26656,00c0b45d650def885fcbcc0f86ca515eceede537@152.53.18.245:15656,f362d57aa6f78e035c8924e7144b7225392b921d@213.239.217.52:38656,ad6db1f33c559707509a777c26a5db86b5dddd0c@37.27.97.16:26656,27994efdba4df95118dc2748f0ebbccf72d8bd0a@65.108.232.156:29656,7e9adbd0a34fcab219c3a818a022248c575f622b@65.108.227.207:16656,2992ea96175253603828620b3bab8688ef5d7517@65.109.92.148:61556,a5c872823b6a010e10f7afba24b1904da5ecfb20@45.76.150.121:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.warden/config/config.toml
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.warden/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.warden/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.warden/config/app.toml
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0.0025uward"|g' $HOME/.warden/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.warden/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.warden/config/config.toml
```

### Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:24158\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:24157\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:24160\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:24156\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":24166\"%" $HOME/.warden/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:24117\"%; s%^address = \":8080\"%address = \":24180\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:24190\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:24191\"%; s%:8545%:24145%; s%:8546%:24146%; s%:6065%:24165%" $HOME/.warden/config/app.toml
```

### Create service
```
sudo tee /etc/systemd/system/warden.service > /dev/null <<EOF
[Unit]
Description=Warden node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.warden
ExecStart=$(which wardend) start --home $HOME/.warden
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable warden
```

### Snapshot
```
cp $HOME/.warden/data/priv_validator_state.json $HOME/.warden/priv_validator_state.json.backup
wardend tendermint unsafe-reset-all --home $HOME/.warden
rm -rf $HOME/.warden/data $HOME/.warden/wasmPath
curl https://testnet-files.itrocket.net/warden/snap_warden.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.warden
mv $HOME/.warden/priv_validator_state.json.backup $HOME/.warden/data/priv_validator_state.json
```

### Start Node
```
sudo systemctl start warden
journalctl -u warden -f
```

### Backup Validator
```
mkdir $HOME/backup
cp $HOME/.warden/config/priv_validator_key.json $HOME/backup
```

### Remove Node
```
cd $HOME
sudo systemctl stop warden
sudo systemctl disable warden
sudo rm /etc/systemd/system/warden.service
sudo systemctl daemon-reload
sudo rm -f $(which warden)
sudo rm -rf $HOME/.warden
sudo rm $HOME/go/bin/wardend
sudo rm -rf $HOME/wardenprotocol
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
