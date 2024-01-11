### 1. Server Requirements
| Component   |  Requirements  |
|-------------|----------------|
| CPU         | 8              |
| Storage     | 500 GB         |
| Ram         | 16 GB          |
| Port        | 30333 - P2P    |
|             | 9933 - RPC     |
|             |9615 - Prometh  |
| OS          |Ubuntu 22.04    |
### 2. Update & install the necessary utilities
```php
# Change Your-name
MONIKER=<Your-name_VNBnode>
```
```php
apt update && apt upgrade -y
apt install curl iptables build-essential git wget jq make gcc nano tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev libgmp3-dev tar clang bsdmainutils ncdu unzip llvm libudev-dev make protobuf-compiler -y
```
### 3. Download binaries files
```php
mkdir -p $HOME/.tangle && cd $HOME/.tangle
```
```php
wget -O tangle https://github.com/webb-tools/tangle/releases/download/v0.6.1/tangle-testnet-linux-amd64
chmod 744 tangle
mv tangle /usr/bin/
tangle --version
```
```php
# **Result should be**: 0.x.x-e892e17-x86_64-linux-gnu
```
### 4. Download json file
```php
wget -O $HOME/.tangle/tangle-standalone.json "https://raw.githubusercontent.com/webb-tools/tangle/main/chainspecs/testnet/tangle-testnet.json"
```
```php
chmod 744 ~/.tangle/tangle-standalone.json
```
```php
# Check json file
sha256sum ~/.tangle/tangle-standalone.json
```
```php
tee /etc/systemd/system/tangle.service > /dev/null << EOF
[Unit]
Description=Tangle Validator Node
After=network-online.target
StartLimitIntervalSec=0
[Service]
User=$USER
Restart=always
RestartSec=3
LimitNOFILE=65535
ExecStart=/usr/bin/tangle \
  --base-path $HOME/.tangle/data/ \
  --name $MONIKER \
  --chain $HOME/.tangle/tangle-standalone.json \
  --node-key-file "$HOME/.tangle/node-key" \
  --port 30333 \
  --rpc-port 9933 \
  --prometheus-port 9615 \
  --auto-insert-keys \
  --validator \
  --telemetry-url "wss://telemetry.polkadot.io/submit 0" \
  --no-mdns
[Install]
WantedBy=multi-user.target
EOF
```
```php
systemctl daemon-reload
systemctl enable tangle
```
### 5. Run service & check logs
```php
systemctl restart tangle && journalctl -u tangle -f -o cat
```
![image](https://github.com/vnbnode/VNBnode-Guides/assets/91002010/850e3682-4c3f-4251-a3c4-1ab794e5e996)
![image](https://github.com/vnbnode/VNBnode-Guides/assets/91002010/577e917e-1f5d-4dfb-af47-c468eb3e04f5)
### 6. Check the node on dashboard
[Click here](https://telemetry.polkadot.io/#list/0xea63e6ac7da8699520af7fb540470d63e48eccb33f7273d2e21a935685bf1320) 

![image](https://github.com/vnbnode/VNBnode-Guides/assets/91002010/e32d14b6-2548-4f67-99e1-c90ef50c515d)
### 7.Validator setup
[Click here](https://polkadot.js.org/apps/?rpc=wss%3A%2F%2Ftestnet-rpc.tangle.tools#/staking/targets)
```php
# get your session key
curl -H "Content-Type: application/json" -d '{ "id": 1, "jsonrpc": "2.0", "method": "author_rotateKeys", "params": [] }' http://localhost:9933
```
![image](https://github.com/vnbnode/VNBnode-Guides/assets/91002010/6204657b-6406-471c-920b-f23696a49082)
***insert session key***
![image](https://github.com/vnbnode/VNBnode-Guides/assets/91002010/a33c0009-14ee-471e-a2e7-4beb3847868a)
### 8.Fill the form
[Apply form](https://forms.gle/amtHuDQP1rbnXg7V9)
### 9. [Leaderboard](https://leaderboard.tangle.tools/)
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
