- Chain ID:dymension_1100-1
- Port: 150
- Version: v3.0.0
## Setup validator name
Replace YOUR_MONIKER with your validator name
```
MONIKER="YOUR_MONIKER"
```
## Install dependencies

- UPDATE SYSTEM AND INSTALL BUILD TOOLS
```
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade
```
- INSTALL GO
```
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.21.7.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```
## Download and build binaries

- Clone project repository
```
cd $HOME
rm -rf dymension
git clone https://github.com/dymensionxyz/dymension.git
cd dymension
git checkout v3.0.0
```
- Build binaries
```
make build
```
- Prepare binaries for Cosmovisor
```
mkdir -p $HOME/.dymension/cosmovisor/genesis/bin
mv build/dymd $HOME/.dymension/cosmovisor/genesis/bin/
rm -rf build
```
- Create application symlinks
```
sudo ln -s $HOME/.dymension/cosmovisor/genesis $HOME/.dymension/cosmovisor/current -f
sudo ln -s $HOME/.dymension/cosmovisor/current/bin/dymd /usr/local/bin/dymd -f
```

## Install Cosmovisor and create a service
- Download and install Cosmovisor

go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```
# Create service
sudo tee /etc/systemd/system/dymension.service > /dev/null << EOF
[Unit]
Description=dymension node service
After=network-online.target

[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.dymension"
Environment="DAEMON_NAME=dymd"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.dymension/cosmovisor/current/bin"

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable dymension.service
```

## Initialize the node
- Set node configuration
```
dymd config chain-id dymension_1100-1
dymd config keyring-backend file
dymd config node tcp://localhost:15057
```
- Initialize the node
```
dymd init $MONIKER --chain-id dymension_1100-1
```
- Download genesis and addrbook
```
curl -Ls https://snapshots.kjnodes.com/dymension/genesis.json > $HOME/.dymension/config/genesis.json
curl -Ls https://snapshots.kjnodes.com/dymension/addrbook.json > $HOME/.dymension/config/addrbook.json
```
- Add seeds
```
sed -i -e "s|^seeds *=.*|seeds = \"a8d11f345c358b2b41e6e916e04a3d87ff845d02@84.46.245.250:14656\"|" $HOME/.dymension/config/config.toml
```
- Set minimum gas price
```
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"20000000000adym\"|" $HOME/.dymension/config/app.toml
```
- Set pruning
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.dymension/config/app.toml
```
- Set custom ports
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:15057\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:15060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:15056\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":15066\"%" $HOME/.dymension/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:15017\"%; s%^address = \":8080\"%address = \":15080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:15090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:15091\"%; s%:8545%:15045%; s%:8546%:15046%; s%:6065%:15065%" $HOME/.dymension/config/app.toml
```
## Download latest chain snapshot
```
curl -L https://snapshots.kjnodes.com/dymension/snapshot_latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.dymension
[[ -f $HOME/.dymension/data/upgrade-info.json ]] && cp $HOME/.dymension/data/upgrade-info.json $HOME/.dymension/cosmovisor/genesis/upgrade-info.json
```
## Start service and check the logs
```
sudo systemctl start dymension.service && sudo journalctl -u dymension.service -f --no-hostname -o cat
```
