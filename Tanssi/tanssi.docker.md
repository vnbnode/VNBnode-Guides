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
## Run Node
- CPU INTEL
  
Please change `INSERT_YOUR_TANSSI_NODE_NAME` to your name

```
docker run --name tanssi --network="host" -v "$HOME/dancebox:/data" \
-u $(id -u ${USER}):$(id -g ${USER}) \
--entrypoint "/tanssi/tanssi-node-skylake" \
moondancelabs/tanssi \
--chain=dancebox \
--name=INSERT_YOUR_TANSSI_NODE_NAME \
--base-path=/data/para \
--state-pruning=2000 \
--blocks-pruning=2000 \
--collator \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
--database paritydb \
-- \
--name=INSERT_YOUR_TANSSI_NODE_NAME \
--base-path=/data/container \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
-- \
--name=INSERT_YOUR_TANSSI_NODE_NAME \
--chain=westend_moonbase_relay_testnet \
--sync=fast \
--base-path=/data/relay \
--state-pruning=2000 \
--blocks-pruning=2000 \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
--database paritydb
```
- CPU AMD
  
Please change `INSERT_YOUR_TANSSI_NODE_NAME` to your name

```
docker run --name tanssi --network="host" -v "$HOME/dancebox:/data" \
-u $(id -u ${USER}):$(id -g ${USER}) \
--entrypoint "/tanssi/tanssi-node-znver3" \
moondancelabs/tanssi \
--chain=dancebox \
--name=INSERT_YOUR_TANSSI_NODE_NAME \
--base-path=/data/para \
--state-pruning=2000 \
--blocks-pruning=2000 \
--collator \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
--database paritydb \
-- \
--name=INSERT_YOUR_TANSSI_NODE_NAME \
--base-path=/data/container \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
-- \
--name=INSERT_YOUR_TANSSI_NODE_NAME \
--chain=westend_moonbase_relay_testnet \
--sync=fast \
--base-path=/data/relay \
--state-pruning=2000 \
--blocks-pruning=2000 \
--telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
--database paritydb
```
### Check log node
```
docker logs -f tanssi
```
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
### [Explorer](https://polkadot.js.org/apps/?rpc=wss://fraa-dancebox-rpc.a.dancebox.tanssi.network#/extrinsics)
### [Check telemetry](https://telemetry.polkadot.io/#list/0x27aafd88e5921f5d5c6aebcd728dacbbf5c2a37f63e2eda301f8e0def01c43ea)

### [Fill form](https://www.tanssi.network/block-producer-form)

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>

