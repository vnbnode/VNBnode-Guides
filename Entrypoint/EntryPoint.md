# Automatic install by VNBnode

```php
wget -O ent https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/blob/main/Entrypoint/run.sh && chmod +x run.sh && ./run.sh
```

## Useful commands
#Add new key
```php
entrypointd keys add wallet
```
#Recover existing key
```php
entrypointd keys add wallet --recover
```
#List All Wallets
```php
entrypointd keys list
```
Delete wallet
```php
entrypointd keys delete wallet
```
#Query Wallet Balance
```php
entrypointd q bank balances $(entrypointd keys show wallet -a)
```
#Create Validator
```php
entrypointd tx staking create-validator \
--amount 1000000uentry \
--pubkey $(entrypointd tendermint show-validator) \
--moniker "MONIKER" \
--identity "KEYBASE_ID" \
--details "YOUR DETAILS" \
--website "YOUR WEBSITE" \
--chain-id entrypoint-pubtest-2 \
--commission-rate="0.05" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.01" \
--min-self-delegation "1" \
--gas-prices="0.01ibc/8A138BC76D0FB2665F8937EC2BF01B9F6A714F6127221A0E155106A45E09BCC5" \
--gas="auto" \
--gas-adjustment="1.5" \
--from wallet \
-y
```
#Edit Validator
```php
entrypointd tx staking edit-validator \
--new-moniker="MONIKER" \
--chain-id entrypoint-pubtest-2 \
--commission-rate=0.05 \
--gas-prices="0.01ibc/8A138BC76D0FB2665F8937EC2BF01B9F6A714F6127221A0E155106A45E09BCC5" \
--gas="auto" \
--gas-adjustment="1.5" \
--from wallet \
-y
```
#Unjail Validator
```php
entrypointd tx slashing unjail --from wallet --chain-id entrypoint-pubtest-2 --gas-prices=0.01ibc/8A138BC76D0FB2665F8937EC2BF01B9F6A714F6127221A0E155106A45E09BCC5 --gas-adjustment 1.5 --gas auto -y
```
#Withdraw rewards from validators
```php
entrypointd  tx distribution withdraw-all-rewards --from wallet --chain-id entrypoint-pubtest-2 --gas-prices=0.01ibc/8A138BC76D0FB2665F8937EC2BF01B9F6A714F6127221A0E155106A45E09BCC5 --gas-adjustment 1.5 --gas auto -y 
```
#Withdraw comission and rewards from your validator
```php
entrypointd tx distribution withdraw-rewards $(entrypointd keys show wallet --bech val -a) --commission --from wallet --chain-id entrypoint-pubtest-2 --gas-prices=0.01ibc/8A138BC76D0FB2665F8937EC2BF01B9F6A714F6127221A0E155106A45E09BCC5 --gas-adjustment 1.5 --gas auto -y 
```
#Delegate to your validator
```php
entrypointd tx staking delegate $(entrypointd keys show wallet --bech val -a) 1000000uentry --from wallet --chain-id entrypoint-pubtest-2 --gas-prices=0.01ibc/8A138BC76D0FB2665F8937EC2BF01B9F6A714F6127221A0E155106A45E09BCC5 --gas-adjustment 1.5 --gas auto -y 
```
#Check synch
```php
entrypointd status 2>&1 | jq .SyncInfo.catching_up
```

#Validator Details
```php
entrypointd q staking validator $(entrypointd keys show wallet --bech val -a)
```
#Jailing info
```php
entrypointd q slashing signing-info $(entrypointd tendermint show-validator)
```
