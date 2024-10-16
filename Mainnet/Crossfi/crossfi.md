# Crossfi
|  Chain ID  |  Port  |  Version  |
|------------|--------|-----------|
| crossfi-mainnet-1  |  35   |   v0.3.0   |
<img src="https://github.com/vnbnode/VNBnode-Guides/assets/76662222/7724db8a-a28e-452b-8431-ed5a748ba9bd" width="30"/> <a href="https://discord.gg/crossfi" target="_blank">Discord</a>
## Server Requirements
| Component   |  Requirements  |
|-------------|----------------|
| CPU         | 6 cores CPU  |
| Storage     | 500 GB (NVME)  |
| Ram         | 32 GB          |
| OS          | Ubuntu 22.04+  |
## Install
# install dependencies, if needed
```
sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y
```
# install go, if needed
```
cd $HOME
VER="1.21.3"
wget "https://golang.org/dl/go$VER.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$VER.linux-amd64.tar.gz"
rm "go$VER.linux-amd64.tar.gz"
[ ! -f ~/.bash_profile ] && touch ~/.bash_profile
echo "export PATH=$PATH:/usr/local/go/bin:~/go/bin" >> ~/.bash_profile
source $HOME/.bash_profile
[ ! -d ~/go/bin ] && mkdir -p ~/go/bin
```
# set vars 
_(Replace Your Moniker)_
```
echo "export WALLET="wallet"" >> $HOME/.bash_profile
echo "export MONIKER="Your Mokiner"" >> $HOME/.bash_profile
echo "export CROSSFI_CHAIN_ID="crossfi-mainnet-1"" >> $HOME/.bash_profile
echo "export CROSSFI_PORT="35"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```
# download binary
```
cd $HOME
rm -rf bin
wget https://github.com/crossfichain/crossfi-node/releases/download/v0.3.0/crossfi-node_0.3.0_linux_amd64.tar.gz && tar -xf crossfi-node_0.3.0_linux_amd64.tar.gz
rm crossfi-node_0.3.0_linux_amd64.tar.gz
mv $HOME/bin/crossfid $HOME/go/bin/crossfid
```
# config and init app
```
rm -rf testnet ~/.mineplex-chain
git clone https://github.com/crossfichain/mainnet.git
mv $HOME/mainnet/ $HOME/.crossfid/
sed -i '99,114 s/^\( *enable =\).*/\1 "false"/' $HOME/.crossfid/config/config.toml
```
# download genesis and addrbook
```
wget -O $HOME/.crossfid/config/genesis.json https://server-3.itrocket.net/mainnet/crossfi/genesis.json
wget -O $HOME/.crossfid/config/addrbook.json  https://server-3.itrocket.net/mainnet/crossfi/addrbook.json
```
# set seeds and peers
```
SEEDS="693d9fe729d41ade244717176ab1415b2c06cf86@crossfi-mainnet-seed.itrocket.net:48656"
PEERS="641157ecbfec8e0ec37ca4c411c1208ca1327154@crossfi-mainnet-peer.itrocket.net:11656,9dd9a718a70c17eda4a2f2e262a6fcdafa380b04@95.217.45.201:23656,c482ab7bb52202149477fded22d6741d746d7e45@95.217.204.58:26056,d996012096cfef860bf24543740d58da45e5b194@37.27.183.62:26656,6b90dd8399533bca9066030f6193dca37f1565e1@65.109.234.80:26656,adb475675d97a9ce67bcea8cfdd66f23b92f1162@89.110.91.158:26656,9c8bf508ead86588f41ecc76cc6021c88493c199@57.129.32.223:26656,f27eff68f2f3542a317bad66fdf9f1cc93a80dc1@49.13.76.170:26656,f8cbc62fb487ae825edf79c580206d0e34ee9f51@5.161.229.160:26656,90fd2ad4f2b57bf6fa0c40cd579310f5ceebf0f5@5.78.128.70:26656,f5d2b1a6ab68ac9357366afe424564ab42a9d444@185.107.82.171:26656"
sed -i -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*seeds *=.*/seeds = \"$SEEDS\"/}" \
       -e "/^\[p2p\]/,/^\[/{s/^[[:space:]]*persistent_peers *=.*/persistent_peers = \"$PEERS\"/}" $HOME/.crossfid/config/config.toml
```
# set custom ports in app.toml
```
sed -i.bak -e "s%:1317%:${CROSSFI_PORT}317%g;
s%:8080%:${CROSSFI_PORT}080%g;
s%:9090%:${CROSSFI_PORT}090%g;
s%:9091%:${CROSSFI_PORT}091%g;
s%:8545%:${CROSSFI_PORT}545%g;
s%:8546%:${CROSSFI_PORT}546%g;
s%:6065%:${CROSSFI_PORT}065%g" $HOME/.crossfid/config/app.toml
```
# set custom ports in config.toml file
```
sed -i.bak -e "s%:26658%:${CROSSFI_PORT}658%g;
s%:26657%:${CROSSFI_PORT}657%g;
s%:6060%:${CROSSFI_PORT}060%g;
s%:26656%:${CROSSFI_PORT}656%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${CROSSFI_PORT}656\"%;
s%:26660%:${CROSSFI_PORT}660%g" $HOME/.crossfid/config/config.toml
```
# config pruning
```
sed -i -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.crossfid/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.crossfid/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"50\"/" $HOME/.crossfid/config/app.toml
```
# set minimum gas price, enable prometheus and disable indexing
```
sed -i 's|minimum-gas-prices =.*|minimum-gas-prices = "10000000000000mpx"|g' $HOME/.crossfid/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.crossfid/config/config.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.crossfid/config/config.toml
```
# create service file
```
sudo tee /etc/systemd/system/crossfid.service > /dev/null <<EOF
[Unit]
Description=Crossfi node
After=network-online.target
[Service]
User=$USER
WorkingDirectory=$HOME/.crossfid
ExecStart=$(which crossfid) start --home $HOME/.crossfid
Restart=on-failure
RestartSec=5
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```
# reset and download snapshot
```
crossfid tendermint unsafe-reset-all --home $HOME/.crossfid
if curl -s --head curl https://server-3.itrocket.net/mainnet/crossfi/crossfi_2024-10-16_8610_snap.tar.lz4 | head -n 1 | grep "200" > /dev/null; then
  curl https://server-3.itrocket.net/mainnet/crossfi/crossfi_2024-10-16_8610_snap.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.crossfid
    else
  echo "no snapshot founded"
fi
```
# enable and start service
```
sudo systemctl daemon-reload
sudo systemctl enable crossfid
sudo systemctl restart crossfid && sudo journalctl -u crossfid -f
```
