# Tanssi Docker Guide

### Website: https://www.tanssi.network

### Telegram (Tanssi Network Official): https://t.me/tanssiofficial 

### Telegram (Tanssi Vietnam): https://t.me/tanssivietnam

### Twitter: https://twitter.com/TanssiNetwork

### Discord: https://discord.gg/zrHsyVUnrR

### Docs: https://docs.tanssi.network

### Explorer: https://polkadot.js.org/apps/?rpc=wss://fraa-dancebox-rpc.a.dancebox.tanssi.network

### Check telemetry: https://telemetry.polkadot.io/#list/0x27aafd88e5921f5d5c6aebcd728dacbbf5c2a37f63e2eda301f8e0def01c43ea

### Fill form: https://www.tanssi.network/block-producer-form

## Recommended Hardware Requirements 

|   SPEC	    |        Recommend          |
| :---------: | :-----------------------: |
|   **CPU**   |        ≥ 4 Cores          |
|   **RAM**   |        ≥ 8 GB             |
| **Storage** |        ≥ 200 GB SSD       |
| **NETWORK** |        ≥ 100 Mbps          |

## Update ubuntu and install Docker
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/docker-install.sh)
```
## Pull image
```
docker pull moondancelabs/tanssi
```
## Run Node
Please change `TANSSI_NAME` to your name

```
docker run --name tanssi --network="host" -d -v "$HOME/dancebox:/data" \
-u $(id -u ${USER}):$(id -g ${USER}) \
moondancelabs/tanssi \
--chain=dancebox \
--name=TANSSI_NAME \
--sync=full \
--base-path=/data/para \
--state-pruning=2000 \
--blocks-pruning=2000 \
--collator \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
--database paritydb \
-- \
--name=TANSSI_NAME \
--base-path=/data/container \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
-- \
--chain=westend_moonbase_relay_testnet \
--name=TANSSI_NAME \
--sync=fast \
--base-path=/data/relay \
--state-pruning=2000 \
--blocks-pruning=2000 \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
--database paritydb
docker update --restart=unless-stopped tanssi
```
### Check log node
```
docker logs -f tanssi
```
## Update Node
```
docker stop tanssi
docker rm tanssi
docker pull moondancelabs/tanssi
```
- Please change `TANSSI_NAME` to your name

```
docker run --name tanssi --network="host" -d -v "$HOME/dancebox:/data" \
-u $(id -u ${USER}):$(id -g ${USER}) \
moondancelabs/tanssi \
--chain=dancebox \
--name=TANSSI_NAME \
--sync=full \
--base-path=/data/para \
--state-pruning=2000 \
--blocks-pruning=2000 \
--collator \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
--database paritydb \
-- \
--name=TANSSI_NAME \
--base-path=/data/container \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
-- \
--chain=westend_moonbase_relay_testnet \
--name=TANSSI_NAME \
--sync=fast \
--base-path=/data/relay \
--state-pruning=2000 \
--blocks-pruning=2000 \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
--database paritydb
docker update --restart=unless-stopped tanssi
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>

