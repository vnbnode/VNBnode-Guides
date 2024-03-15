# Tanssi Docker Guide

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
Please change `INSERT_YOUR_TANSSI_NODE_NAME` to your name

```
docker run --name tanssi --network="host" -d -v "/var/lib/dancebox:/data" \
-u $(id -u ${USER}):$(id -g ${USER}) \
moondancelabs/tanssi \
--chain=dancebox \
--name=INSERT_YOUR_TANSSI_NODE_NAME \
--sync=warp \
--base-path=/data/para \
--state-pruning=2000 \
--blocks-pruning=2000 \
--collator \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
--database paritydb \
-- \
--name=INSERT_YOUR_BLOCK_PRODUCER_NODE_NAME \
--base-path=/data/container \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
-- \
--chain=westend_moonbase_relay_testnet \
--name=INSERT_YOUR_RELAY_NODE_NAME \
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
docker pull moondancelabs/tanssi
docker restart tanssi
```
### [Explorer](https://polkadot.js.org/apps/?rpc=wss://fraa-dancebox-rpc.a.dancebox.tanssi.network#/extrinsics)
### [Check telemetry](https://telemetry.polkadot.io/#list/0x27aafd88e5921f5d5c6aebcd728dacbbf5c2a37f63e2eda301f8e0def01c43ea)

### [Fill form](https://www.tanssi.network/block-producer-form)

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>

