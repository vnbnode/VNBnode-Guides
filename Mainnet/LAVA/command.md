## Key management
### ADD NEW KEY
```
lavad keys add wallet
```
### RECOVER EXISTING KEY
```
lavad keys add wallet --recover
```
### LIST ALL KEYS
```
lavad keys list
```
### DELETE KEY
```
lavad keys delete wallet
```
### EXPORT KEY TO A FILE
```
lavad keys export wallet
```
### IMPORT KEY FROM A FILE
```
lavad keys import wallet wallet.backup
```
### QUERY WALLET BALANCE
```
lavad q bank balances $(lavad keys show wallet -a)
```

## Validator management
### CREATE NEW VALIDATOR
```
lavad tx staking create-validator \
--amount 1000000ulava \
--pubkey $(lavad tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id lava-mainnet-1 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.05 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.000000001ulava \
-y
```

### EDIT EXISTING VALIDATOR
```
lavad tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id lava-mainnet-1 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.000000001ulava \
-y
```
### UNJAIL VALIDATOR
```
lavad tx slashing unjail --from wallet --chain-id lava-mainnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.000000001ulava -y
```
### JAIL REASON
```
lavad query slashing signing-info $(lavad tendermint show-validator)
```
### VALIDATOR DETAILS
```
lavad q staking validator $(lavad keys show wallet --bech val -a)
```
### VALIDATOR INFO
```
lavad status 2>&1 | jq .ValidatorInfo
```
### SYNC CHECK
```
lavad status 2>&1 | jq .SyncInfo
```
### CHECK SERVICE LOGS
```
sudo journalctl -u lava.service -f --no-hostname -o cat
```
## Token management
### WITHDRAW COMMISSION AND REWARDS FROM YOUR VALIDATOR
```
lavad tx distribution withdraw-rewards $(lavad keys show wallet --bech val -a) --commission --from wallet --chain-id lava-mainnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.000000001ulava -y
```
### DELEGATE TOKENS TO YOURSELF
```
lavad tx staking delegate $(lavad keys show wallet --bech val -a) 1000000ulava --from wallet --chain-id lava-mainnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.000000001ulava -y
```
### DELEGATE TOKENS TO VALIDATOR
```
lavad tx staking delegate <TO_VALOPER_ADDRESS> 1000000ulava --from wallet --chain-id lava-mainnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.000000001ulava -y
```
### UNBOND TOKENS FROM YOUR VALIDATOR
```
lavad tx staking unbond $(lavad keys show wallet --bech val -a) 1000000ulava --from wallet --chain-id lava-mainnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.000000001ulava -y
```
### SEND TOKENS TO THE WALLET
```
lavad tx bank send wallet <TO_WALLET_ADDRESS> 1000000ulava --from wallet --chain-id lava-mainnet-1 --gas-adjustment 1.4 --gas auto --gas-prices 0.000000001ulava -y
```

### GET NODE PEER
```
echo $(lavad tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.lava/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
### REMOVE NODE
```
cd $HOME
sudo systemctl stop lava.service
sudo systemctl disable lava.service
sudo rm /etc/systemd/system/lava.service
sudo systemctl daemon-reload
rm -f $(which lavad)
rm -rf $HOME/.lava
rm -rf $HOME/lava

```


