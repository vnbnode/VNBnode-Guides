# Running Uniond
## Option 1: Automactic

## Option 2: Manual
### Export Binary
```
export CHAIN_ID=union-testnet-4
export MONIKER="Name-VNBnode"
export KEY_NAME=union
export GENESIS_URL="https://rpc.cryptware.io/genesis"
export UNIOND_VERSION='v0.14.0'
```
### Download Docker Image
```
docker pull ghcr.io/unionlabs/uniond:$UNIOND_VERSION
```
### Initializing the Chain Config & State Folder
```
mkdir ~/.union
```
```
curl https://rpc.cryptware.io/genesis | jq '.result.genesis' > ~/.union/config/genesis.json
```
```
docker run -u $(id -u):$(id -g) -v ~/.union:/.union -it ghcr.io/unionlabs/uniond:$UNIOND_VERSION init $MONIKER bn254 --home /.union
```
```
alias uniond='docker run -v ~/.union:/.union --network host -it ghcr.io/unionlabs/uniond:$UNIOND_VERSION --home /.union'
```
### Run Node Uniond
```
nano compose.yaml
```
* Add everything below
```
services:
  node:
    image: ghcr.io/unionlabs/uniond:${UNIOND_VERSION}
    volumes:
      - ~/.union:/.union
      - /tmp:/tmp
    network_mode: "host"
    restart: unless-stopped
    command: start --home /.union
```
* Run Node
```
docker compose up -d
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
