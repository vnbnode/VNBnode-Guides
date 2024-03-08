# Tanssi SystemD
Tanssi, an appchain infrastructure protocol, is currently under construction to simplify and enhance appchain deployment like never before.
[Tanssi](https://www.tanssi.network/)
# 1. Update system and install build tools
```
apt update && apt upgrade -y
apt install curl iptables build-essential git wget jq make gcc nano tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev libgmp3-dev tar clang bsdmainutils ncdu unzip llvm libudev-dev make protobuf-compiler -y
```
# 2. Download the Latest Release
```
wget https://github.com/moondance-labs/tanssi/releases/download/v0.5.0/tanssi-node && \
chmod +x ./tanssi-node
```
# 3. Creat new wallet
```
./tanssi-node key generate -w24
```
# 4. Creat tanssi-data
```
adduser tanssi_service --system --no-create-home
mkdir /var/lib/tanssi-data
sudo chown -R tanssi_service /var/lib/tanssi-data
mv ./tanssi-node /var/lib/tanssi-data
```
# 5. Create the Systemd Service Configuration File
(**Replace** _INSERT_YOUR_TANSSI_NODE_NAME_)
```
sudo tee /etc/systemd/system/tanssi.service > /dev/null << EOF
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
--rpc-port=9944 \
--name=INSERT_YOUR_TANSSI_NODE_NAME \
--base-path=/var/lib/tanssi-data/para \
--state-pruning=2000 \
--blocks-pruning=2000 \
--collator \
--database paritydb \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0'
-- \
--rpc-port=9946 \
--name=tanssi-appchain \
--base-path=/var/lib/tanssi-data/container \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0'
-- \
--name=INSERT_YOUR_TANSSI_NODE_NAME \
--chain=westend_moonbase_relay_testnet \
--rpc-port=9945 \
--sync=fast \
--base-path=/var/lib/tanssi-data/relay \
--state-pruning=2000 \
--blocks-pruning=2000 \
--database paritydb \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0'

[Install]
WantedBy=multi-user.target
EOF
systemctl enable tanssi.service
systemctl daemon-reload
```
```
systemctl restart tanssi.service && journalctl -f -u tanssi.service
```
# 6. [Check telemetry](https://telemetry.polkadot.io/#list/0x27aafd88e5921f5d5c6aebcd728dacbbf5c2a37f63e2eda301f8e0def01c43ea)
# 7. [Fill form](https://www.tanssi.network/block-producer-form)

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>

