# Hedge Block
Chain ID: `berberis-1`

## Recommended Hardware Requirements

|   SPEC      |       Recommend       |       Minimum        |
| :---------: | :--------------------:|:--------------------:|
|   **CPU**   |        8 Cores        |        4 Cores       |
|   **RAM**   |        32 GB          |        16 GB         |
|   **SSD**   |        200 GB         |        200 GB        |
| **NETWORK** |        100 Mbps       |        100 Mbps      |
| **Port**    |        10256          |

### Update and install packages for compiling
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/update-binary.sh)
```

### Build binary
```
cd $HOME
wget -O hedged https://github.com/hedgeblock/testnets/releases/download/v0.1.0/hedged_linux_amd64_v0.1.0
sudo chmod +x hedged
sudo wget -O /usr/lib/libwasmvm.x86_64.so https://github.com/CosmWasm/wasmvm/releases/download/v1.3.0/libwasmvm.x86_64.so
mkdir -p $HOME/.hedge/cosmovisor/genesis/bin
cp hedged $HOME/.hedge/cosmovisor/genesis/bin/
sudo ln -s $HOME/.hedge/cosmovisor/genesis $HOME/.hedge/cosmovisor/current -f
sudo ln -s $HOME/.hedge/cosmovisor/current/bin/hedged /usr/local/bin/hedged -f
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
sudo tee /etc/systemd/system/hedge.service > /dev/null << EOF
[Unit]
Description=hedge node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.hedge"
Environment="DAEMON_NAME=hedged"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.hedge/cosmovisor/current/bin"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable hedge
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
hedged config chain-id berberis-1
hedged config keyring-backend test
hedged init $MONIKER --chain-id berberis-1
```

### Download Genesis & Addrbook
```
curl -Ls https://snap.nodex.one/hedge-testnet/genesis.json > $HOME/.hedge/config/genesis.json
curl -Ls https://snap.nodex.one/hedge-testnet/addrbook.json > $HOME/.hedge/config/addrbook.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:24010\"|" $HOME/.hedge/config/config.toml
peers=$(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Hedge/peers.txt)
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.hedge/config//config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025uhedge\"|" $HOME/.hedge/config/app.toml
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.hedge/config/app.toml
```

### Custom Port
```
echo 'export hedge="102"' >> ~/.bash_profile
source $HOME/.bash_profile
sed -i.bak -e "s%:1317%:${hedge}17%g;
s%:8080%:${hedge}80%g;
s%:9090%:${hedge}90%g;
s%:9091%:${hedge}91%g;
s%:8545%:${hedge}45%g;
s%:8546%:${hedge}46%g;
s%:6065%:${hedge}65%g" $HOME/.hedge/config/app.toml
sed -i.bak -e "s%:26658%:${hedge}58%g;
s%:26657%:${hedge}57%g;
s%:6060%:${hedge}60%g;
s%:26656%:${hedge}56%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${hedge}56\"%;
s%:26660%:${hedge}60%g" $HOME/.hedge/config/config.toml
hedged config node tcp://localhost:${hedge}57
```

### Snapshot
```
sudo systemctl stop hedge
cp $HOME/.hedge/data/priv_validator_state.json $HOME/.hedge/priv_validator_state.json.backup
rm -rf $HOME/.hedge/data && mkdir $HOME/.hedge/data
curl -o - -L https://snapshot-de-1.genznodes.dev/hedgeblock/hedge-testnet-1853234.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.hedge
mv $HOME/.hedge/priv_validator_state.json.backup $HOME/.hedge/data/priv_validator_state.json
```

### Start Node
```
sudo systemctl restart hedge
journalctl -u hedge -f
```

### Backup Node
```
mkdir -p $HOME/backup/hedge
cp $HOME/.hedge/config/priv_validator_key.json $HOME/backup/hedge
```

### Remove Node
```
cd $HOME
sudo systemctl stop hedge
sudo systemctl disable hedge
sudo rm /etc/systemd/system/hedge.service
sudo systemctl daemon-reload
sudo rm -f $(which hedge)
sudo rm -rf $HOME/.hedge
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
