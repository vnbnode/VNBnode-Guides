Key management
Add New Wallet
```
arkeod keys add wallet
```
Restore executing wallet
```
arkeod keys add wallet --recover
```
List All Wallets
```
arkeod keys list
```
Delete wallet
```
arkeod keys delete wallet
```
Check Balance
```
arkeod q bank balances $(arkeod keys show wallet -a)
```
Export Key (save to wallet.backup)
```
arkeod keys export wallet
```
Import Key (restore from wallet.backup)
```
arkeod keys import wallet wallet.backup
```
Withdraw all rewards
```
arkeod tx distribution withdraw-all-rewards --from wallet --chain-id arkeo --gas auto --gas-adjustment 1.5
```
Withdraw rewards and commission from your validator
```
arkeod tx distribution withdraw-rewards $VALOPER_ADDRESS --from wallet --commission --chain-id arkeo --gas auto --gas-adjustment 1.5 -y
```
Check your balance
```
arkeod query bank balances wallet_ADDRESS
```
Delegate to Yourself
```
arkeod tx staking delegate $(arkeod keys show wallet --bech val -a) 1000000uarkeo --from wallet --chain-id arkeo --gas auto --gas-adjustment 1.5 -y
```
Delegate
```
arkeod tx staking delegate <TO_VALOPER_ADDRESS> 1000000uarkeo --from wallet --chain-id arkeo --gas auto --gas-adjustment 1.5 -y
```
Redelegate Stake to Another Validator
```
arkeod tx staking redelegate $VALOPER_ADDRESS <TO_VALOPER_ADDRESS> 1000000uarkeo --from wallet --chain-id arkeo --gas auto --gas-adjustment 1.5 -y
```
Unbond
```
arkeod tx staking unbond $(arkeod keys show wallet --bech val -a) 1000000uarkeo --from wallet --chain-id arkeo --gas auto --gas-adjustment 1.5 -y
```
Transfer Funds
```
arkeod tx bank send wallet_ADDRESS <TO_WALLET_ADDRESS> 1000000uarkeo --gas auto --gas-adjustment 1.5 -y
```
Create New Validator
```
arkeod tx staking create-validator \
--amount 1000000uarkeo \
--from wallet \
--commission-rate 0.1 \
--commission-max-rate 0.2 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--pubkey $(arkeod tendermint show-validator) \
--moniker "$MONIKER" \
--identity "" \
--details "" \
--chain-id arkeo \
--gas auto --gas-adjustment 1.5 \
-y
```
Edit Existing Validator
```
arkeod tx staking edit-validator \
--commission-rate 0.1 \
--new-moniker "$MONIKER" \
--identity "" \
--details "" \
--from wallet \
--chain-id arkeo \
--gas auto --gas-adjustment 1.5 \
-y
```
Validator info
```
arkeod status 2>&1 | jq .ValidatorInfo
```
Validator Details
```
arkeod q staking validator $(arkeod keys show wallet --bech val -a)
```
Jailing info
```
arkeod q slashing signing-info $(arkeod tendermint show-validator)
```
Unjail validator
```
arkeod tx slashing unjail --from wallet --chain-id arkeo --gas auto --gas-adjustment 1.5 -y
```
Active Validators List
```
arkeod q staking validators -oj --limit=2000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " 	 " + .description.moniker' | sort -gr | nl
```
Check Validator key
```
[[ $(arkeod q staking validator $VALOPER_ADDRESS -oj | jq -r .consensus_pubkey.key) = $(arkeod status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "Your key status is ok" || echo -e "Your key status is error"
```
Signing info
```
arkeod q slashing signing-info $(arkeod tendermint show-validator)
```
```
arkeod  tx gov submit-proposal \
--title "" \
--description "" \
--deposit 1000000uarkeo \
--type Text \
--from wallet \
--gas auto --gas-adjustment 1.5 \
-y
```
🗳 Governance
List all proposals
```
arkeod query gov proposals
```
View proposal by id
```
arkeod query gov proposal 1
```
Vote 'Yes'
```
arkeod tx gov vote 78 yes --from wallet --chain-id arkeo --gas auto --gas-adjustment 1.5 -y
```
Vote 'No'
```
arkeod tx gov vote 1 no --from wallet --chain-id arkeo --gas auto --gas-adjustment 1.5 -y
```
Vote 'Abstain'
```
arkeod tx gov vote 1 abstain --from wallet --chain-id arkeo --gas auto --gas-adjustment 1.5 -y
```
Vote 'NoWithVeto'
```
arkeod tx gov vote 1 nowithveto --from wallet --chain-id arkeo --gas auto --gas-adjustment 1.5 -y
```
Remove node
```
sudo systemctl stop arkeod
sudo systemctl disable arkeod
sudo rm /etc/systemd/system/arkeod.service
sudo systemctl daemon-reload
rm -f $(which arkeod)
rm -rf $HOME/arkeod
rm -rf $HOME/.arkeo
rm -rf $HOME/arkeo.sh
```
