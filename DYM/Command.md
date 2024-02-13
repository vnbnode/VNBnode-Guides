## Key management
- ADD NEW KEY
```
dymd keys add wallet
```
- RECOVER EXISTING KEY
```
dymd keys add wallet --recover
```
- LIST ALL KEYS
```
dymd keys list
```
- DELETE KEY
```
dymd keys delete wallet
```
- EXPORT KEY TO A FILE
```
dymd keys export wallet
```
- IMPORT KEY FROM A FILE
```
dymd keys import wallet wallet.backup
```
- QUERY WALLET BALANCE
```
dymd q bank balances $(dymd keys show wallet -a)
```
## Validator management
Please make sure you have adjusted moniker, identity, details and website to match your values.

- CREATE NEW VALIDATOR
```
dymd tx staking create-validator \
--amount 1000000adym \
--pubkey $(dymd tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id dymension_1100-1 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 20000000000adym \
-y
```
- EDIT EXISTING VALIDATOR
```
dymd tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id dymension_1100-1 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 20000000000adym \
-y
```
- UNJAIL VALIDATOR
```
dymd tx slashing unjail --from wallet --chain-id dymension_1100-1 --gas-adjustment 1.4 --gas auto --gas-prices 20000000000adym -y
```
- JAIL REASON
```
dymd query slashing signing-info $(dymd tendermint show-validator)
```
- LIST ALL ACTIVE VALIDATORS
```
dymd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- LIST ALL INACTIVE VALIDATORS
```
dymd q staking validators -oj --limit=3000 | jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " \t " + .description.moniker' | sort -gr | nl
```
- VIEW VALIDATOR DETAILS
```
dymd q staking validator $(dymd keys show wallet --bech val -a)
```
## Token management
- WITHDRAW REWARDS FROM ALL VALIDATORS
```
dymd tx distribution withdraw-all-rewards --from wallet --chain-id dymension_1100-1 --gas-adjustment 1.4 --gas auto --gas-prices 20000000000adym -y
```
- WITHDRAW COMMISSION AND REWARDS FROM YOUR VALIDATOR
```
dymd tx distribution withdraw-rewards $(dymd keys show wallet --bech val -a) --commission --from wallet --chain-id dymension_1100-1 --gas-adjustment 1.4 --gas auto --gas-prices 20000000000adym -y
```
- DELEGATE TOKENS TO YOURSELF
```
dymd tx staking delegate $(dymd keys show wallet --bech val -a) 1000000adym --from wallet --chain-id dymension_1100-1 --gas-adjustment 1.4 --gas auto --gas-prices 20000000000adym -y
```
- DELEGATE TOKENS TO VALIDATOR
```
dymd tx staking delegate <TO_VALOPER_ADDRESS> 1000000adym --from wallet --chain-id dymension_1100-1 --gas-adjustment 1.4 --gas auto --gas-prices 20000000000adym -y
```
- REDELEGATE TOKENS TO ANOTHER VALIDATOR
```
dymd tx staking redelegate $(dymd keys show wallet --bech val -a) <TO_VALOPER_ADDRESS> 1000000adym --from wallet --chain-id dymension_1100-1 --gas-adjustment 1.4 --gas auto --gas-prices 20000000000adym -y
```
- UNBOND TOKENS FROM YOUR VALIDATOR
```
dymd tx staking unbond $(dymd keys show wallet --bech val -a) 1000000adym --from wallet --chain-id dymension_1100-1 --gas-adjustment 1.4 --gas auto --gas-prices 20000000000adym -y
```
- SEND TOKENS TO THE WALLET
```
dymd tx bank send wallet <TO_WALLET_ADDRESS> 1000000adym --from wallet --chain-id dymension_1100-1 --gas-adjustment 1.4 --gas auto --gas-prices 20000000000adym -y
```
## Governance
- LIST ALL PROPOSALS
```
dymd query gov proposals
```
- VIEW PROPOSAL BY ID
```
dymd query gov proposal 1
```
- VOTE ‘YES’
```
dymd tx gov vote 1 yes --from wallet --chain-id dymension_1100-1 --gas-adjustment 1.4 --gas auto --gas-prices 20000000000adym -y
```
- VOTE ‘NO’
```
dymd tx gov vote 1 no --from wallet --chain-id dymension_1100-1 --gas-adjustment 1.4 --gas auto --gas-prices 20000000000adym -y
```
- VOTE ‘ABSTAIN’
```
dymd tx gov vote 1 abstain --from wallet --chain-id dymension_1100-1 --gas-adjustment 1.4 --gas auto --gas-prices 20000000000adym -y
```
- VOTE ‘NOWITHVETO’
```
dymd tx gov vote 1 NoWithVeto --from wallet --chain-id dymension_1100-1 --gas-adjustment 1.4 --gas auto --gas-prices 20000000000adym -y
```
## Utility
- UPDATE PORTS
```
CUSTOM_PORT=110
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CUSTOM_PORT}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CUSTOM_PORT}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CUSTOM_PORT}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CUSTOM_PORT}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CUSTOM_PORT}66\"%" $HOME/.dymension/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CUSTOM_PORT}17\"%; s%^address = \":8080\"%address = \":${CUSTOM_PORT}80\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CUSTOM_PORT}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CUSTOM_PORT}91\"%" $HOME/.dymension/config/app.toml
```
- UPDATE INDEXER
Disable indexer
```
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/.dymension/config/config.toml
```
Enable indexer
```
sed -i -e 's|^indexer *=.*|indexer = "kv"|' $HOME/.dymension/config/config.toml
```
- UPDATE PRUNING
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.dymension/config/app.toml
```
## Maintenance
- GET VALIDATOR INFO
```
dymd status 2>&1 | jq .ValidatorInfo
```
- GET SYNC INFO
```
dymd status 2>&1 | jq .SyncInfo
```
- GET NODE PEER
```
echo $(dymd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.dymension/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
- CHECK IF VALIDATOR KEY IS CORRECT
```
[[ $(dymd q staking validator $(dymd keys show wallet --bech val -a) -oj | jq -r .consensus_pubkey.key) = $(dymd status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "\n\e[1m\e[32mTrue\e[0m\n" || echo -e "\n\e[1m\e[31mFalse\e[0m\n"
```
- GET LIVE PEERS
```
curl -sS http://localhost:14657/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
- SET MINIMUM GAS PRICE
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"20000000000adym\"/" $HOME/.dymension/config/app.toml
```
- ENABLE PROMETHEUS
```
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.dymension/config/config.toml
```
- RESET CHAIN DATA
```
dymd tendermint unsafe-reset-all --keep-addr-book --home $HOME/.dymension --keep-addr-book
```
- REMOVE NODE
Please, before proceeding with the next step! All chain data will be lost! Make sure you have backed up your priv_validator_key.json!
```
cd $HOME
sudo systemctl stop dymension.service
sudo systemctl disable dymension.service
sudo rm /etc/systemd/system/dymension.service
sudo systemctl daemon-reload
rm -f $(which dymd)
rm -rf $HOME/.dymension
rm -rf $HOME/dymension
```
## Service Management
- RELOAD SERVICE CONFIGURATION
```
sudo systemctl daemon-reload
```
- ENABLE SERVICE
```
sudo systemctl enable dymension.service
```
- DISABLE SERVICE
```
sudo systemctl disable dymension.service
```
- START SERVICE
```
sudo systemctl start dymension.service
```
- STOP SERVICE
```
sudo systemctl stop dymension.service
```
- RESTART SERVICE
```
sudo systemctl restart dymension.service
```
- CHECK SERVICE STATUS
```
sudo systemctl status dymension.service
```
CHECK SERVICE LOGS
```
sudo journalctl -u dymension.service -f --no-hostname -o cat
```
