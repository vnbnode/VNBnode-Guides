# Tanssi SystemD
Tanssi, an appchain infrastructure protocol, is currently under construction to simplify and enhance appchain deployment like never before.
[Tanssi](https://www.tanssi.network/)

## Recommended Hardware Requirements 

|   SPEC	    |        Recommend          |
| :---------: | :-----------------------: |
|   **CPU**   |        ≥ 4 Cores          |
|   **RAM**   |        ≥ 8 GB             |
| **Storage** |        ≥ 200 GB SSD       |
| **NETWORK** |        ≥ 100 Mbps         |
## 1. Update system and install build tools
```
apt update && apt upgrade -y
apt install curl iptables build-essential git wget jq make gcc nano tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev libgmp3-dev tar clang bsdmainutils ncdu unzip llvm libudev-dev make protobuf-compiler -y
```
## 2. Download the Latest Release
```
wget https://github.com/moondance-labs/tanssi/releases/download/v0.5.1/tanssi-node && \
chmod +x ./tanssi-node
```
## 3. Creat new wallet
```
./tanssi-node key generate -w24
```
## 4. Creat tanssi-data
```
adduser tanssi_service --system --no-create-home
mkdir /var/lib/tanssi-data
sudo chown -R tanssi_service /var/lib/tanssi-data
mv ./tanssi-node /var/lib/tanssi-data
```
## 5. Create the Systemd Service Configuration File
(**Replace** _INSERT_YOUR_TANSSI_NODE_NAME_)
Creat tanssi.service & save file
```
sudo nano /etc/systemd/system/tanssi.service
```
```
[Unit]
Description="Tanssi systemd service"
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=on-failure
RestartSec=10
User=tanssi_service
SyslogIdentifier=tanssi
SyslogFacility=local7
KillSignal=SIGHUP
ExecStart=/var/lib/tanssi-data/tanssi-node \
--chain=dancebox \
--name=INSERT_YOUR_TANSSI_NODE_NAME \
--sync=warp \
--base-path=/var/lib/tanssi-data/para \
--state-pruning=2000 \
--blocks-pruning=2000 \
--collator \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
--database paritydb \
-- \
--name=INSERT_YOUR_TANSSI_NODE_NAME \
--base-path=/var/lib/tanssi-data/container \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
-- \
--chain=westend_moonbase_relay_testnet \
--name=INSERT_YOUR_TANSSI_NODE_NAME \
--sync=fast \
--base-path=/var/lib/tanssi-data/relay \
--state-pruning=2000 \
--blocks-pruning=2000 \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
--database paritydb \

[Install]
WantedBy=multi-user.target
```
```
systemctl enable tanssi.service
systemctl daemon-reload
```
```
systemctl restart tanssi.service && journalctl -f -u tanssi.service
```
## 6. [Check telemetry](https://telemetry.polkadot.io/#list/0x27aafd88e5921f5d5c6aebcd728dacbbf5c2a37f63e2eda301f8e0def01c43ea)
## 7. [Fill form](https://www.tanssi.network/block-producer-form)
## Generate Session Keys
```
curl http://127.0.0.1:9944 -H \
"Content-Type:application/json;charset=utf-8" -d \
  '{
    "jsonrpc":"2.0",
    "id":1,
    "method":"author_rotateKeys",
    "params": []
  }'
```
## Update New Version
```
systemctl stop tanssi.service
https://github.com/moondance-labs/tanssi/releases/download/v0.5.2/tanssi-node && \
chmod +x ./tanssi-node
mv ./tanssi-node /var/lib/tanssi-data
```
```
systemctl restart tanssi.service && journalctl -f -u tanssi.service
```
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>

