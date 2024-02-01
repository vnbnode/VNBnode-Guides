### 1. Server Requirements
| Component   |  Requirements  |
|-------------|----------------|
| CPU         | 8-Core (16-Thread) Intel i7/Xeon or equivalent with AVX support              |
| Storage     | 1 TB NVMe SSD is recommended         |
| Ram         | 20GB DDR4         |
| OS          |Ubuntu 22.04    |

### CPU must support AVX, check by
```php
lscpu | grep -oh avx
```
##### If result returns nothing, that means CPU does not support AVX.

### Get Rust
```php
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
# Add the wasm toolchain
rustup target add wasm32-unknown-unknown
```
### Install neccessaries
```php
apt update
```
```php
apt install -y git binutils-dev libcurl4-openssl-dev zlib1g-dev libdw-dev libiberty-dev cmake gcc g++ python2 docker.io protobuf-compiler libssl-dev pkg-config clang llvm cargo awscli
```
### Install Nearcore binaries
```php
git clone https://github.com/near/nearcore
cd nearcore
git fetch origin --tags
```
```php
git checkout tags/1.36.4 -b mynode
```
```php
make release
```
### Initiate node
```php
./target/release/neard --home ~/.near init --chain-id mainnet --download-genesis --download-config
```
### Replace config.json
```php
rm ~/.near/config.json
wget https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/mainnet/config.json -P ~/.near/
```
# Create service
```php
sudo tee /etc/systemd/system/neard.service > /dev/null << EOF
[Unit]
Description=Near Daemon
After=network-online.target
[Service]
User=$USER
ExecStart=$(which neard) --home $HOME/.near run
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```
```php
sudo systemctl daemon-reload
sudo systemctl enable neard
```
### Download snap
```php
aws s3 --no-sign-request cp s3://near-protocol-public/backups/mainnet/rpc/latest .
LATEST=$(cat latest)
aws s3 --no-sign-request cp --no-sign-request --recursive s3://near-protocol-public/backups/mainnet/rpc/$LATEST ~/.near/data
```
### Start service and Check logs
```php
sudo systemctl start neard && sudo journalctl -u neard -f --no-hostname -o cat
```
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
