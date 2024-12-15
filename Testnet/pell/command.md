## Open terminal container.
```
docker exec -it pell-validator /bin/bash
```
### 🔑 Key management
- Add new key
```
pellcored keys add wallet
```
- Recover existing key
```
pellcored keys add wallet --recover
```
- List all keys
```
pellcored keys list
```
- Delete key
```
pellcored keys delete wallet
```
- Export key to a file
```
pellcored keys export wallet
```
- Import key from a file
```
pellcored keys import wallet wallet.backup
```
- Query wallet balance
```
pellcored q bank balances $(pellcored keys show wallet -a)
```
### 👷 Validator management
Please make sure you have adjusted moniker, identity, details and website to match your values.
- Create new validator
```
pellcored tx staking create-validator \
--amount 1000000000000000000apell \
--pubkey $(pellcored tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id ignite_186-1 \
--commission-rate "0.10" \
--commission-max-rate "0.20" \
--commission-max-change-rate "0.01" \
--min-self-delegation "1000000" \
--gas=1000000 \
--fees 0.000001pell \
--from wallet
-y
```
- Edit existing validator
```
pellcored tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id ignite_186-1 \
--commission-rate 0.05 \
--gas=1000000 \
--fees 0.000001pell \
--from wallet
-y
```
- Unjail validator
```
pellcored tx slashing unjail --chain-id ignite_186-1 --gas=1000000 --fees 0.000001pell --from wallet
```
- Jail reason
```
pellcored query slashing signing-info $(pellcored tendermint show-validator)
```
- List all active validators
```
pellcored q staking validators -oj | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- List all inactive validators
```
pellcored q staking validators -oj | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- View validator details
```
pellcored q staking validator $(pellcored keys show wallet --bech val -a)
```
### 💲 Token management
- Withdraw rewards from all validators
```
pellcored tx distribution withdraw-all-rewards --from wallet --chain-id ignite_186-1 --gas=1000000 --fees 0.000001pell --from wallet
```
- Withdraw commission and rewards from your validator
```
pellcored tx distribution withdraw-rewards $(pellcored keys show wallet --bech val -a) --commission --from wallet --chain-id ignite_186-1 --gas=1000000 --fees 0.000001pell --from wallet
```
- Delegate tokens to yourself
```
pellcored tx staking delegate $(pellcored keys show wallet --bech val -a) 1000000apell --from wallet --chain-id ignite_186-1 --gas=1000000 --fees 0.000001pell --from wallet
```
- Delegate tokens to validator
```
pellcored tx staking delegate <TO_VALOPER_ADDRESS> 1000000apell --from wallet --chain-id ignite_186-1 --gas=1000000 --fees 0.000001pell --from wallet
```
- Redelegate tokens to another validator
```
pellcored tx staking redelegate $(pellcored keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000apell --from wallet --chain-id ignite_186-1 --gas=1000000 --fees 0.000001pell --from wallet
```
- Unbond tokens from your validator
```
pellcored tx staking unbond $(pellcored keys show wallet --bech val -a) 1000000apell --from wallet --chain-id ignite_186-1 --gas=1000000 --fees 0.000001pell --from wallet
```
- Send tokens to the wallet
```
pellcored tx bank send wallet <TO_WALLET_ADDRESS> 1000000apell --from wallet --chain-id ignite_186-1 --gas=1000000 --fees 0.000001pell --from wallet
```
### 🗳 Governance
- List all proposals
```
pellcored query gov proposals
```
- View proposal by id
```
pellcored query gov proposal 1
```
- Vote ‘Yes’
```
pellcored tx gov vote 1 yes --from wallet --chain-id ignite_186-1 --gas=1000000 --fees 0.000001pell --from wallet
```
- Vote ‘No’
```
pellcored tx gov vote 1 no --from wallet --chain-id ignite_186-1 --gas=1000000 --fees 0.000001pell --from wallet
```
- Vote ‘Abstain’
```
pellcored tx gov vote 1 abstain --from wallet --chain-id ignite_186-1 --gas=1000000 --fees 0.000001pell --from wallet
```
- Vote ‘NoWithVeto’
```
pellcored tx gov vote 1 NoWithVeto --from wallet --chain-id ignite_186-1 --gas=1000000 --fees 0.000001pell --from wallet
```
### ⚡️ Utility
- Update ports
```
CUSTOM_PORT=110
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}66\"%" $HOME/.pellcored/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}17\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}80\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}91\"%" $HOME/.pellcored/config/app.toml
```
- Update Indexer
  - Disable indexer
  ```
  sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.pellcored/config/config.toml
  ```
  - Enable indexer
  ```
  sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.pellcored/config/config.toml
  ```
- Update pruning
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.pellcored/config/app.toml
```
### 🚨 Maintenance
- Get validator info
```
curl http://localhost:26657/status | jq .result.validator_info
```
- Get sync info
```
curl http://localhost:26657/status | jq .result.sync_info
```
- Get node peer
```
echo $(pellcored tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.pellcored/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
- Check if validator key is correct
```
[[ $(pellcored q staking validator $(pellcored keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(pellcored status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
- Get live peers
```
curl -sS http://localhost:26657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
- Set minimum gas price
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"20000000000apell\"/" $HOME/.pellcored/config/app.toml
```
- Enable prometheus
```
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.pellcored/config/config.toml
```
- Reset chain data
```
pellcored tendermint unsafe-reset-all --keep-addr-book --home $HOME/.pellcored --keep-addr-book
```
- Remove node

_Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your priv_validator_key.json!_
```
cd $HOME
docker stop pell-validator
docker rm pell-validator
docker rmi pellnetwork/pellnode-devnet:v0.1.0
rm -rf $HOME/.pellcored
```
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnode_Inside</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/twitter_icon.png" width="30" height="30"/> <a href="https://x.com/vnbnode" target="_blank">VNBnode Twitter</a>

