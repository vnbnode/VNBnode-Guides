#!/bin/bash

# Update system and install build tools
sudo apt update && sudo apt list --upgradable && sudo apt upgrade -y
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu net-tools -y

# Install go
ver="1.20.2"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile
source $HOME/.bash_profile
go version

# Install binary & build binary
mkdir -p .erbie/erbie
cd $HOME
git clone https://github.com/erbieio/erbie
cd erbie
git checkout v0.15.0
go build -o erbie cmd/erbie/main.go
sudo mv erbie /usr/local/bin

# Create & start service
sudo tee /etc/systemd/system/erbied.service > /dev/null <<EOF
[Unit]
Description=erbie
After=online.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME
ExecStart=/usr/local/bin/erbie \
  --datadir $HOME/.erbie \
  --devnet \
  --identity vnbnode \
  --mine \
  --miner.threads 1 \
  --rpc \
  --rpccorsdomain "*" \
  --rpcvhosts "*" \
  --http \
  --rpcaddr 127.0.0.1 \
  --rpcport 8544 \
  --port 30303 \
  --maxpeers 50 \
  --syncmode full
Restart=on-failure
RestartSec=5
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable erbied
sudo systemctl start erbied

sleep 10

NODE_KEY=$(cat $HOME/.erbie/erbie/nodekey)
echo -e "Your privatekey: \e[32m$NODE_KEY\e[39m"
