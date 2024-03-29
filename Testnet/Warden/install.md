# WARDEN
Chain ID: `alfama`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        4 GB             |
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
mkdir -p $HOME/.warden/cosmovisor/genesis/bin
mv wardend $HOME/.warden/cosmovisor/genesis/bin/
sudo ln -s $HOME/.warden/cosmovisor/genesis $HOME/.warden/cosmovisor/current -f
sudo ln -s $HOME/.warden/cosmovisor/current/bin/wardend /usr/local/bin/wardend -f
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
sudo tee /etc/systemd/system/warden.service > /dev/null << EOF
[Unit]
Description=warden node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.warden"
Environment="DAEMON_NAME=wardend"
Environment="UNSAFE_SKIP_BACKUP=true"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable warden
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
curl -Ls https://snap.nodex.one/warden-testnet/genesis.json > $HOME/.warden/config/genesis.json
curl -Ls https://snap.nodex.one/warden-testnet/addrbook.json > $HOME/.warden/config/addrbook.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"ff0885377c44d58164f29d356b9d3d3a755c6213@warden-testnet-seed.itrocket.net:18656\"|" $HOME/.warden/config/config.toml
sed -i -e 's|^persistent_peers *=.*|persistent_peers ="f995c84635c099329bfaaa255389d63e052cb0ac@warden-testnet-peer.itrocket.net:18656,55c5b6ab09002dfba354ff924775ea9ba319f226@81.31.197.120:26656,9eb15351ad2d1fd9cd866e4f9e4153f6dddcf151@51.178.92.69:16656,4b5777664aacfeeb76a51dea8d1264c2983e6aed@65.109.104.111:56103,225054d5ddf2386762450e21075c0e8677c3d0fc@144.76.29.90:26656,00c0b45d650def885fcbcc0f86ca515eceede537@152.53.18.245:15656,f362d57aa6f78e035c8924e7144b7225392b921d@213.239.217.52:38656,ad6db1f33c559707509a777c26a5db86b5dddd0c@37.27.97.16:26656,27994efdba4df95118dc2748f0ebbccf72d8bd0a@65.108.232.156:29656,7e9adbd0a34fcab219c3a818a022248c575f622b@65.108.227.207:16656,2992ea96175253603828620b3bab8688ef5d7517@65.109.92.148:61556"|' $HOME/.warden/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025uward\"|" $HOME/.warden/config/app.toml
sed -i \
  -e 's|^chain-id *=.*|chain-id = "alfama"|' \
  -e 's|^keyring-backend *=.*|keyring-backend = "test"|' \
  -e 's|^node *=.*|node = "tcp://localhost:24157"|' \
  $HOME/.warden/config/client.toml
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.warden/config/app.toml
```

### Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:24158\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:24157\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:24160\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:24156\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":24166\"%" $HOME/.warden/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:24117\"%; s%^address = \":8080\"%address = \":24180\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:24190\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:24191\"%; s%:8545%:24145%; s%:8546%:24146%; s%:6065%:24165%" $HOME/.warden/config/app.toml
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
sudo systemctl start warden
journalctl -u warden -f
```


## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
