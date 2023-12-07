# Entrypoint version V1.3.0

```
curl -o auto-run.sh https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Entrypoint/auto-run.sh && bash auto-run.sh
```

## Useful commands
### Add new key
```
entrypointd keys add wallet
```
### Recover existing key
```
entrypointd keys add wallet --recover
```
### List All Wallets
```
entrypointd keys list
```
### Delete wallet
```
entrypointd keys delete wallet
```
### Query Wallet Balance
```
entrypointd q bank balances $(entrypointd keys show wallet -a)
```
### Create Validator
```
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
### Edit Validator
```
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
### Unjail Validator
```
entrypointd tx slashing unjail --from wallet --chain-id entrypoint-pubtest-2 --gas-prices=0.01ibc/8A138BC76D0FB2665F8937EC2BF01B9F6A714F6127221A0E155106A45E09BCC5 --gas-adjustment 1.5 --gas auto -y
```
### Withdraw rewards from validators
```
entrypointd  tx distribution withdraw-all-rewards --from wallet --chain-id entrypoint-pubtest-2 --gas-prices=0.01ibc/8A138BC76D0FB2665F8937EC2BF01B9F6A714F6127221A0E155106A45E09BCC5 --gas-adjustment 1.5 --gas auto -y 
```
### Withdraw comission and rewards from your validator
```
entrypointd tx distribution withdraw-rewards $(entrypointd keys show wallet --bech val -a) --commission --from wallet --chain-id entrypoint-pubtest-2 --gas-prices=0.01ibc/8A138BC76D0FB2665F8937EC2BF01B9F6A714F6127221A0E155106A45E09BCC5 --gas-adjustment 1.5 --gas auto -y 
```
### Delegate to your validator
```
entrypointd tx staking delegate $(entrypointd keys show wallet --bech val -a) 1000000uentry --from wallet --chain-id entrypoint-pubtest-2 --gas-prices=0.01ibc/8A138BC76D0FB2665F8937EC2BF01B9F6A714F6127221A0E155106A45E09BCC5 --gas-adjustment 1.5 --gas auto -y 
```
### Check synch
```
entrypointd status 2>&1 | jq .SyncInfo.catching_up
```

### Validator Details
```
entrypointd q staking validator $(entrypointd keys show wallet --bech val -a)
```
### Jailing info
```
entrypointd q slashing signing-info $(entrypointd tendermint show-validator)
```
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
