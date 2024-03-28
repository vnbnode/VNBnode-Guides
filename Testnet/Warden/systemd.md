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
rm -rf wardenprotocol
git clone --depth 1 --branch v0.2.0 https://github.com/warden-protocol/wardenprotocol/
cd wardenprotocol/warden/cmd/wardend
go build
mv wardend $HOME/go/bin
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
echo "export WALLET="wallet"" >> $HOME/.bash_profile
echo "export WARDEN_CHAIN_ID="alfama"" >> $HOME/.bash_profile
echo "export WARDEN_PORT="18"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
```
wardend config node tcp://localhost:${WARDEN_PORT}657
wardend config keyring-backend os
wardend config chain-id alfama
wardend init $MONIKER
```
### Download Genesis & Addrbook
```
wget -O $HOME/.warden/config/genesis.json https://testnet-files.itrocket.net/warden/genesis.json
wget -O $HOME/.warden/config/addrbook.json https://testnet-files.itrocket.net/warden/addrbook.json
```

### Configure
```
SEEDS="ff0885377c44d58164f29d356b9d3d3a755c6213@warden-testnet-seed.itrocket.net:18656"
PEERS="f995c84635c099329bfaaa255389d63e052cb0ac@warden-testnet-peer.itrocket.net:18656,55c5b6ab09002dfba354ff924775ea9ba319f226@81.31.197.120:26656,59178a321454cb7cf630397bb0fbfca6a3d00c43@213.199.49.229:26656,9eb15351ad2d1fd9cd866e4f9e4153f6dddcf151@51.178.92.69:16656,4b5777664aacfeeb76a51dea8d1264c2983e6aed@65.109.104.111:56103,225054d5ddf2386762450e21075c0e8677c3d0fc@144.76.29.90:26656,00c0b45d650def885fcbcc0f86ca515eceede537@152.53.18.245:15656,f362d57aa6f78e035c8924e7144b7225392b921d@213.239.217.52:38656,ad6db1f33c559707509a777c26a5db86b5dddd0c@37.27.97.16:26656,27994efdba4df95118dc2748f0ebbccf72d8bd0a@65.108.232.156:29656,7e9adbd0a34fcab219c3a818a022248c575f622b@65.108.227.207:16656,12caf2f5e3618cb6c57f45e93ac713b2bc6243b1@164.90.205.67:26656,2992ea96175253603828620b3bab8688ef5d7517@65.109.92.148:61556"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.warden/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025uward\"|" $HOME/.warden/config/app.toml
```

### Pruning Setting
```
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.warden/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.warden/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.warden/config/app.toml
```

### Custom Port
```
sed -i.bak -e "s%:1317%:${WARDEN_PORT}317%g;
s%:8080%:${WARDEN_PORT}080%g;
s%:9090%:${WARDEN_PORT}090%g;
s%:9091%:${WARDEN_PORT}091%g;
s%:8545%:${WARDEN_PORT}545%g;
s%:8546%:${WARDEN_PORT}546%g;
s%:6065%:${WARDEN_PORT}065%g" $HOME/.warden/config/app.toml
sed -i.bak -e "s%:26658%:${WARDEN_PORT}658%g;
s%:26657%:${WARDEN_PORT}657%g;
s%:6060%:${WARDEN_PORT}060%g;
s%:26656%:${WARDEN_PORT}656%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${WARDEN_PORT}656\"%;
s%:26660%:${WARDEN_PORT}660%g" $HOME/.warden/config/config.toml
```

### Create service
```
sudo tee /etc/systemd/system/wardend.service > /dev/null <<EOF
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
sudo systemctl enable wardend
```

### Snapshot
```
wardend tendermint unsafe-reset-all --home $HOME/.warden
if curl -s --head curl https://testnet-files.itrocket.net/warden/snap_warden.tar.lz4 | head -n 1 | grep "200" > /dev/null; then
  curl https://testnet-files.itrocket.net/warden/snap_warden.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.warden
    else
  echo no have snap
fi
```
### Start Node
```
sudo systemctl start wardend
journalctl -u wardend -f
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
