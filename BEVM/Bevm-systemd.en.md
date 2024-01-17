# Bevm
<img src="https://github.com/vnbnode/VNBnode-Guides/assets/76662222/7724db8a-a28e-452b-8431-ed5a748ba9bd" width="30"/> <a href="https://discord.gg/uBnrqrHBhD" target="_blank">Discord</a>
### 1. Server Requirements
| Component   |  Requirements  |
|-------------|----------------|
| CPU         | 2              |
| Storage     | 300 GB         |
| Ram         | 2 GB           |
| Port        | 20222 - P2P    |
|             | 8086 - RPC     |
|             | 8087 - WS      |
| OS          | Ubuntu 20.04+  |
### 2. Update & install the necessary utilities

# Change Your-address-wallet
```php
MONIKER=<Your-address-wallet>
```
```php
apt update && apt upgrade -y
apt install curl iptables build-essential git wget jq make gcc nano tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev libgmp3-dev tar clang bsdmainutils ncdu unzip llvm libudev-dev make protobuf-compiler -y
```
### 3. Download binaries files
```php
mkdir -p $HOME/.bevm && cd $HOME/.bevm
```
```php
wget -O bevm https://github.com/btclayer2/BEVM/releases/download/testnet-v0.1.1/bevm-v0.1.1-ubuntu20.04
chmod 744 bevm
mv bevm /usr/bin/
bevm --version
```
```php
# **Result should be**: bevm 0.1.1-ef190a5a903
```
```php
tee /etc/systemd/system/bevm.service > /dev/null << EOF
[Unit]
Description=Bevm Validator Node
After=network-online.target
StartLimitIntervalSec=0
[Service]
User=$USER
Restart=always
RestartSec=3
LimitNOFILE=65535
ExecStart=/usr/bin/bevm --name $MONIKER --chain testnet --pruning archive --telemetry-url "wss://telemetry.polkadot.io/submit 0"
[Install]
WantedBy=multi-user.target
EOF
```
```php
systemctl daemon-reload
systemctl enable bevm
```
### 4. Run service & check logs
```php
systemctl restart bevm && journalctl -u bevm -f -o cat
```
### 5. Check the node on dashboard
[Click here](https://telemetry.bevm.io/#/0x41cfeafc7177775a0e838b3725a0178b89ebf5dde1b5f766becbf975a24e297b) 

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
