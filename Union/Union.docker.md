# Running Uniond
## Option 1: Automactic
```
cd $HOME && curl -o union-auto.sh https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Union/union-auto.sh && bash union-auto.sh
```
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
### Seeds
Edit ~/.union/config/config.toml. We'll set the seeds to ensure your node can connect to the peer-to-peer network.

For `union-testnet-4` replace seeds = "" with:
```
seeds = "a069a341154484298156a56ace42b6e6a71e7b9d@blazingbit.io:27656,8a07752a234bb16471dbb577180de7805ba6b5d9@union.testnet.4.seed.poisonphang.com:26656"
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
## Create a New Account
```
uniond keys add $KEY_NAME
```
## Recover an Existing Account
```
uniond keys add $KEY_NAME --recover
```
## [Receiving Testnet Tokens](https://7xv16fh3twz.typeform.com/to/eYTMvi11)
## Finding your Union Address
```
uniond keys show $KEY_NAME --address
```
## Finding your Validator Address
```
uniond keys show $KEY_NAME --bech=val --address
```
## Creating your validator
```
uniond tx staking create-validator \
  --amount 1000000muno \
  --pubkey $(uniond tendermint show-validator) \
  --moniker $MONIKER \
  --chain-id union-testnet-4 \
  --from $KEY_NAME \
  --commission-max-change-rate "0.1" \
  --commission-max-rate "0.20" \
  --commission-rate "0.1" \
  --min-self-delegation "1"
```
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
