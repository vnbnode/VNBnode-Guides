# Testnest
| System Required | Minimum Hardwares |
| --- | --- |
| CPUS |  4 CPUs |
| Memory | 8 GB Memory |
| Data Disk | 200+ GB Data Disk |
| RPC | 	26657 |
| REST API | 1317 |
| gRPC | 9090 |
| Prometheus| 26660 |
## Update & Upgrade
```bash
sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y
sudo apt-get install -y libssl-dev
```
## Install GO
```
cd $HOME
VER="1.22.3"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"
[ ! -f ~/.bash_profile ] && touch ~/.bash_profile
echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
source $HOME/.bash_profile
[ ! -d ~/go/bin ] && mkdir -p ~/go/bin
```
```
go version
```
## Download and build binaries
```
cd $HOME
wget -O pellcored https://github.com/0xPellNetwork/network-config/releases/download/v1.1.6/pellcored-v1.1.6-linux-amd64
chmod +x $HOME/pellcored
mv $HOME/pellcored $HOME/go/bin/pellcored
WASMVM_VERSION="v2.1.2"
export LD_LIBRARY_PATH=$HOME/.pellcored/lib
mkdir -p $LD_LIBRARY_PATH
wget "https://github.com/CosmWasm/wasmvm/releases/download/$WASMVM_VERSION/libwasmvm.$(uname -m).so" -O "$LD_LIBRARY_PATH/libwasmvm.$(uname -m).so"
echo "export LD_LIBRARY_PATH=$HOME/.pellcored/lib:$LD_LIBRARY_PATH" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
## Set Variable
```
pellcored config node tcp://localhost:26657
pellcored config keyring-backend os
pellcored config chain-id ignite_186-1
pellcored init "$MONIKER" --chain-id ignite_186-1
```
## Download Genesis and Addrbook
```
wget -O $HOME/.pellcored/config/genesis.json https://raw.githubusercontent.com/CoinHuntersTR/props/refs/heads/main/pellnetwork/genesis.json
wget -O $HOME/.pellcored/config/addrbook.json https://raw.githubusercontent.com/CoinHuntersTR/props/refs/heads/main/pellnetwork/addrbook.json
```
## Config Pruning
```
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.pellcored/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.pellcored/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.pellcored/config/app.toml
# Set minimum gas price, enable Prometheus, and disable indexing
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "0apell"|g' $HOME/.pellcored/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.pellcored/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.pellcored/config/config.toml
```
## Set seeds and peers
```
URL="https://pell-testnet-rpc.itrocket.net/net_info"
response=$(curl -s $URL)
SEEDS="5f10959cc96b5b7f9e08b9720d9a8530c3d08d19@pell-testnet-seed.itrocket.net:58656"
PEERS=$(echo $response | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):" + (.node_info.listen_addr | capture("(?<ip>.+):(?<port>[0-9]+)$").port)' | paste -sd "," -)
echo "PEERS=\"$PEERS\""
sed -i -e "s|^seeds *=.*|seeds = \"$SEEDS\"|; s|^persistent_peers *=.*|persistent_peers = \"$PEERS\"|" $HOME/.pellcored/config/config.toml
```
## Create service 
```
sudo tee /etc/systemd/system/pellcored.service > /dev/null <<EOF
[Unit]
Description=Pell node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.pellcored
ExecStart=$(which pellcored) start --home $HOME/.pellcored
Environment=LD_LIBRARY_PATH=$HOME/.pellcored/lib/
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```
## Enable and Start service
```
sudo systemctl daemon-reload
sudo systemctl enable pellcored
sudo systemctl restart pellcored && sudo journalctl -fu pellcored -o cat
```
## Thank to support VNBnode.
### Visit us at:
<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnode_Inside</a>
<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>
<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
<img src="https://github.com/vnbnode/binaries/blob/main/Logo/twitter_icon.png" width="30"/> <a href="https://x.com/vnbnode" target="_blank">VNBnode Twitter</a>
