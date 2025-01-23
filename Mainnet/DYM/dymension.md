# Dymension Mainnet validator
|  Chain ID       |  Port  |  Version  |
|-----------------|--------|-----------|
|dymension_1100-1 |  150   |  v3.0.0   |
# Minimum hardware
|   Spec  |        Requirements      |
| :---------: | :-----------------------: |
|   **CPU**   |          8 Cores (Intel / AMD)        |
|   **RAM**   |          16 GB            |
|   **NVME**   |          1 TB            | 

## RPC, API, gRPC and Snapshot
✅ RPC:  https://rpc-dym.vnbnode.com/

✅ API:  https://api-dym.vnbnode.com/

✅ gRPC: https://grpc-dym.vnbnode.com/

✅ Auto Snapshot daily: 
```
https://github.com/vnbnode/VNBnode-Guides/blob/main/DYM/snapshot.md
```

## Setup validator name
Replace YOUR_MONIKER with your validator name
```
MONIKER="YOUR_MONIKER"
```
## Install dependencies
```
# UPDATE SYSTEM AND INSTALL BUILD TOOLS
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade
```
```
# INSTALL GO
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.21.7.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```
## Download and build binaries
```
# Clone project repository
cd $HOME
rm -rf dymension
git clone https://github.com/dymensionxyz/dymension.git
cd dymension
git checkout v3.0.0
```
```
# Build binaries
make build
```
```
# Prepare binaries for Cosmovisor
mkdir -p $HOME/.dymension/cosmovisor/genesis/bin
mv build/dymd $HOME/.dymension/cosmovisor/genesis/bin/
rm -rf build
```
```
# Create application symlinks
sudo ln -s $HOME/.dymension/cosmovisor/genesis $HOME/.dymension/cosmovisor/current -f
sudo ln -s $HOME/.dymension/cosmovisor/current/bin/dymd /usr/local/bin/dymd -f
```
## Install Cosmovisor and create a service
```
# Download and install Cosmovisor
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
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
```
# Initialize the node
dymd init $MONIKER --chain-id dymension_1100-1

# Set node configuration
dymd config chain-id dymension_1100-1
dymd config keyring-backend file
dymd config node tcp://localhost:15057
```
```
# Download genesis and addrbook
curl -Ls https://snap.vnbnode.com/dymension/genesis.json > $HOME/.dymension/config/genesis.json
curl -Ls https://snap.vnbnode.com/dymension/addrbook.json > $HOME/.dymension/config/addrbook.json
```
```
# Add seeds
sed -i -e "s|^seeds *=.*|seeds = \"400f3d9e30b69e78a7fb891f60d76fa3c73f0ecc@dymension.rpc.kjnodes.com:14659\"|" $HOME/.dymension/config/config.toml
```
```
# Set minimum gas price
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"5000000000adym\"|" $HOME/.dymension/config/app.toml
```
```
# Set pruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.dymension/config/app.toml
```
```
# Set custom ports
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:15057\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:15060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:15056\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":15066\"%" $HOME/.dymension/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:15017\"%; s%^address = \":8080\"%address = \":15080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:15090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:15091\"%; s%:8545%:15045%; s%:8546%:15046%; s%:6065%:15065%" $HOME/.dymension/config/app.toml
```
## Start service and check the logs
```
sudo systemctl start dymension.service && sudo journalctl -u dymension.service -f --no-hostname -o cat
```
## Snapshot
_Stop Node and Reset Data_
```
sudo systemctl stop dymension
cp $HOME/.dymension/data/priv_validator_state.json $HOME/.dymension/priv_validator_state.json.backup
rm -rf $HOME/.dymension/data && mkdir -p $HOME/.dymension/data
```
_Download Snapshot_
```
curl -L https://snap.vnbnode.com/dymension/dymension_1100-1_snapshot_latest.tar.lz4 | tar -I lz4 -xf - -C $HOME/.dymension/data
```
```
mv $HOME/.dymension/priv_validator_state.json.backup $HOME/.dymension/data/priv_validator_state.json
```
_Restart Node_
```
sudo systemctl start dymension.service && sudo journalctl -u dymension -f --no-hostname -o cat
```
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
