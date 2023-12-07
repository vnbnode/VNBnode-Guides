#!/bin/bash

# Logo

echo -e "\033[0;34m"
echo "/===============================================================================\\"
echo "|| __        ______     __ ______    ____     __ _______  ______     ________   ||"
echo "||   ██\       ██████\    ██|██████\\  ████\    ██|████████|██████\\  |████████|  ||"
echo "||  ██\     ██/██| ██\  ██|██|   ██  ██| ██\  ██|██|   ██|██|   ██| |██|        ||"                                 
echo "||   ██\   ██/ ██|  ██\ ██|██████    ██|  ██\ ██|██|   ██|██|    ██||██████|    ||"
echo "||    ██\ ██/  ██|   ██\██|██|   ██  ██|   ██\██|██|   ██|██|_  ██| |██|        ||"
echo "||     ████/   ██|    ████|██████//  ██|    ████|████████|██████//  |████████|  ||"
echo "||                                                                              ||"
echo "\\==============================================================================/"
echo "Website: https://vnbnode.com"
echo "VNBnode is group of professional validators/researchers in blockchain"
echo -e "\e[0m"

read -r -p "Enter node moniker: " NODE_MONIKER

CHAIN_ID="entrypoint-pubtest-2"
CHAIN_DENOM="uentry"
BINARY_NAME="entrypointd"
GITHUB="https://github.com/vnbnode/VNBnode-Guides"
BINARY_VERSION_TAG="v1.2.0"

echo -e "Node Name: ${CYAN}$NODE_MONIKER${NC}"
echo -e "Chain id:     ${CYAN}$CHAIN_ID${NC}"
echo -e "Chain demon:  ${CYAN}$CHAIN_DENOM${NC}"
echo -e "Binary version tag:  ${CYAN}$BINARY_VERSION_TAG${NC}"

sleep 1

echo -e "\e[1m\e[32m1. Updating packages and dependencies--> \e[0m" && sleep 1
#UPDATE APT
sudo apt update && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev libleveldb-dev jq build-essential bsdmainutils git make ncdu htop lz4 screen unzip bc fail2ban htop -y

echo -e "\e[1m\e[32m2. Installing GO--> \e[0m" && sleep 1
#INSTALL GO
ver="1.20.5" 
cd $HOME 
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" 

sudo rm -rf /usr/local/go 
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" 
rm "go$ver.linux-amd64.tar.gz"

echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile

echo -e "\e[1m\e[32m3. Downloading and building binaries--> \e[0m" && sleep 1

cd $HOME
wget https://github.com/entrypoint-zone/testnets/releases/download/v1.2.0/entrypointd-1.2.0-linux-amd64
sudo chmod +x entrypointd
sudo mv entrypointd /usr/local/bin
entrypointd version

entrypointd config chain-id $CHAIN_ID
entrypointd config keyring-backend test
entrypointd init "$NODE_MONIKER" --chain-id $CHAIN_ID

# Add Genesis File and Addrbook
wget -O $HOME/.entrypoint/config/genesis.json "https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/blob/main/Entrypoint/genesis.json"
wget -O $HOME/.entrypoint/config/addrbook.json "https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/blob/main/Entrypoint/addrbook.json"

#Configure Seeds and Peers
peers="81bf2ade773a30eccdfee58a041974461f1838d8@185.107.68.148:26656,d57c7572d58cb3043770f2c0ba412b35035233ad@80.64.208.169:26656"
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.entrypoint/config/config.toml
seeds=""
sed -i.bak -e "s/^seeds =.*/seeds = \"$seeds\"/" $HOME/.entrypoint/config/config.toml

# Set Pruning, Enable Prometheus, Gas Prices, and Indexer
PRUNING="custom"
PRUNING_KEEP_RECENT="100"
PRUNING_INTERVAL="10"

sed -i -e "s/^pruning *=.*/pruning = \"$PRUNING\"/" $HOME/.entrypoint/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \
\"$PRUNING_KEEP_RECENT\"/" $HOME/.entrypoint/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \
\"$PRUNING_INTERVAL\"/" $HOME/.entrypoint/config/app.toml
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.entrypoint/config/config.toml
sed -i 's|^prometheus *=.*|prometheus = true|' $HOME/.entrypoint/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.01ibc/8A138BC76D0FB2665F8937EC2BF01B9F6A714F6127221A0E155106A45E09BCC5\"|" $HOME/.entrypoint/config/app.toml

# Set Service file
sudo tee /etc/systemd/system/entrypointd.service > /dev/null <<EOF
[Unit]
Description=entrypointd testnet node
After=network-online.target
[Service]
User=$USER
ExecStart=$(which entrypointd) start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable entrypointd

# Download Snapshot for fast sync
rm -rf $HOME/.entrypoint/data $HOME/.entrypoint/wasmPath
curl https://testnet-files.itrocket.net/entrypoint/snap_entrypoint.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.entrypoint

# Start the Node
sudo systemctl restart entrypointd

echo '=============== SETUP FINISHED ==================='
echo -e "Check logs:            ${CYAN}sudo journalctl -u $BINARY_NAME -f --no-hostname -o cat ${NC}"
echo -e "Check synchronization: ${CYAN}$BINARY_NAME status 2>&1 | jq .SyncInfo.catching_up${NC}"
echo -e "More commands:         ${CYAN}$GITHUB${NC}"
