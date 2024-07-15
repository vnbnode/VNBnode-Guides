### 1. Server Requirements
| Component   |  Requirements  |
|-------------|----------------|
| CPU         | 8              |
| Storage     | 500 GB         |
| Ram         | 32 GB          |
| Port        | 30333 - P2P    |
|             | 9944 - RPC     |
|             |9615 - Prometh  |
| OS          |Ubuntu 22.04    |
### 2. Update & install the necessary utilities

- Change YOUR-MONIKER
```
MONIKER=YOUR-MONIKER
```
```
apt update && apt upgrade -y
apt install curl iptables build-essential git wget jq make gcc nano tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev libgmp3-dev tar clang bsdmainutils ncdu unzip llvm libudev-dev make protobuf-compiler -y
```
### 3. Download binaries files
```
mkdir -p $HOME/.tangle && cd $HOME/.tangle
wget -O tangle https://github.com/webb-tools/tangle/releases/download/v1.0.6/tangle-default-linux-amd64

chmod 744 tangle
mv tangle /usr/bin/
tangle --version
```
- **Result should be**: tangle 1.0.12-ff0251a-x86_64-linux-gnu
### 4. Download json file & creat tangle service
```
wget -O $HOME/.tangle/tangle-standalone.json "https://raw.githubusercontent.com/webb-tools/tangle/main/chainspecs/mainnet/tangle-mainnet.json"
chmod 744 ~/.tangle/tangle-standalone.json
```
- Check json file
```
sha256sum ~/.tangle/tangle-standalone.json
```
```
sudo tee /etc/systemd/system/tangle.service > /dev/null << EOF
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
  --validator \
  --chain $HOME/.tangle/tangle-standalone.json \
  --node-key-file "$HOME/.tangle/node-key" \
  --no-mdns \
  --telemetry-url "wss://telemetry.polkadot.io/submit 1" 

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable tangle
```
### 5. Add key 
_(Replace your seed phrase)_
- 4.1. Account Key
```
tangle key insert --base-path $HOME/.tangle/data/ \
--chain $HOME/.tangle/tangle-standalone.json \
--scheme Sr25519 \
--suri "Your seed phrase" \
--key-type acco
```
- 4.2. Babe Key
```
tangle key insert --base-path $HOME/.tangle/data/ \
--chain $HOME/.tangle/tangle-standalone.json \
--scheme Sr25519 \
--suri "Your seed phrase" \
--key-type babe
```
- 4.3. Im-online Key
```
tangle key insert --base-path $HOME/.tangle/data/ \
--chain $HOME/.tangle/tangle-standalone.json \
--scheme Sr25519 \
--suri "Your seed phrase" \
--key-type imon
```
- 4.4. Role Key
```
tangle key insert --base-path $HOME/.tangle/data/ \
--chain $HOME/.tangle/tangle-standalone.json \
--scheme Sr25519 \
--suri "Your seed phrase" \
--key-type role
```
- 4.5. Grandpa Key
```
tangle key insert --base-path $HOME/.tangle/data/ \
--chain $HOME/.tangle/tangle-standalone.json \
--scheme Sr25519 \
--suri "Your seed phrase" \
--key-type gran
```
### 6. Run service & check logs
```
systemctl restart tangle && journalctl -u tangle -f -o cat
```
### Get your session key
```
curl -H "Content-Type: application/json" -d '{ "id": 1, "jsonrpc": "2.0", "method": "author_rotateKeys", "params": [] }' http://localhost:9944
```
### Remove tangle
```
systemctl stop tangle
systemctl disable tangle
systemctl daemon-reload
rm /etc/systemd/system/tangle.service
rm /usr/bin/tangle
rm -rf $HOME/.tangle
```
### Telemetry
```
https://telemetry.polkadot.io/#list/0x44f68476df71ebf765b630bf08dc1e0fedb2bf614a1aa0563b3f74f20e47b3e0
```
### Explorer
```
https://polkadot.js.org/apps/?rpc=wss://rpc.tangle.tools#/explorer
```
```
https://tangle.statescan.io/
```
