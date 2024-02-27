Key management
Add New Wallet
```
selfchaind keys add wallet
```
Restore executing wallet
```
selfchaind keys add wallet --recover
```
List All Wallets
```
selfchaind keys list
```
Delete wallet
```
selfchaind keys delete wallet
```
Check Balance
```
selfchaind q bank balances $(selfchaind keys show wallet -a)
```
Export Key (save to wallet.backup)
```
selfchaind keys export wallet
```
Import Key (restore from wallet.backup)
```
selfchaind keys import wallet wallet.backup
```
Withdraw all rewards
```
selfchaind tx distribution withdraw-all-rewards --from wallet --chain-id self-dev-1 --gas auto --gas-adjustment 1.5
```
Withdraw rewards and commission from your validator
```
selfchaind tx distribution withdraw-rewards $(selfchaind keys show wallet --bech val -a) --commission --from wallet --chain-id self-dev-1 --gas-prices=0.005uself --gas-adjustment 1.5 --gas "auto" -y 
```
Delegate to Yourself
```
selfchaind tx staking delegate $(selfchaind keys show wallet --bech val -a) 1000000uself --from wallet --chain-id self-dev-1 --gas auto --gas-adjustment 1.5 -y
```
Delegate
```
selfchaind tx staking delegate <TO_VALOPER_ADDRESS> 1000000uself --from wallet --chain-id self-dev-1 --gas auto --gas-adjustment 1.5 -y
```
Redelegate Stake to Another Validator
```
selfchaind tx staking redelegate $VALOPER_ADDRESS <TO_VALOPER_ADDRESS> 1000000uself --from wallet --chain-id self-dev-1 --gas auto --gas-adjustment 1.5 -y
```
Unbond
```
selfchaind tx staking unbond $(selfchaind keys show wallet --bech val -a) 1000000uself --from wallet --chain-id self-dev-1 --gas auto --gas-adjustment 1.5 -y
```
Transfer Funds
```
selfchaind tx bank send wallet_ADDRESS <TO_WALLET_ADDRESS> 1000000uself --gas auto --gas-adjustment 1.5 -y
```
Create New Validator
```
selfchaind tx staking create-validator \
  --amount "1000000uself" \
  --pubkey $(selfchaind tendermint show-validator) \
  --moniker "MONIKER" \
  --identity "KEYBASE_ID" \
  --details "YOUR DETAILS" \
  --website "YOUR WEBSITE" \
  --chain-id self-dev-1 \
  --commission-rate "0.05" \
  --commission-max-rate "0.20" \
  --commission-max-change-rate "0.01" \
  --min-self-delegation "1" \
  --gas-prices "0uself" \
  --gas "auto" \
  --gas-adjustment "1.5" \
  --from wallet \
  -y
```
Edit Existing Validator
```
selfchaind tx staking edit-validator \
--commission-rate 0.1 \
--new-moniker "$MONIKER" \
--identity "" \
--details "" \
--from wallet \
--chain-id self-dev-1 \
--gas auto --gas-adjustment 1.5 \
-y
```
Validator info
```
selfchaind status 2>&1 | jq .ValidatorInfo
```
Validator Details
```
selfchaind q staking validator $(selfchaind keys show wallet --bech val -a)
```
Jailing info
```
selfchaind q slashing signing-info $(selfchaind tendermint show-validator)
```
Unjail validator
```
selfchaind tx slashing unjail --from wallet --chain-id self-dev-1 --gas auto --gas-adjustment 1.5 -y
```
Active Validators List
```
selfchaind q staking validators -oj --limit=2000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " 	 " + .description.moniker' | sort -gr | nl
```
Check Validator key
```
[[ $(selfchaind q staking validator $VALOPER_ADDRESS -oj | jq -r .consensus_pubkey.key) = $(selfchaind status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "Your key status is ok" || echo -e "Your key status is error"
```
Signing info
```
selfchaind q slashing signing-info $(selfchaind tendermint show-validator)
```
```
selfchaind  tx gov submit-proposal \
--title "" \
--description "" \
--deposit 1000000uself \
--type Text \
--from wallet \
--gas auto --gas-adjustment 1.5 \
-y
```
🗳 Governance
List all proposals
```
selfchaind query gov proposals
```
View proposal by id
```
selfchaind query gov proposal 1
```
Vote 'Yes'
```
selfchaind tx gov vote 78 yes --from wallet --chain-id self-dev-1 --gas auto --gas-adjustment 1.5 -y
```
Vote 'No'
```
selfchaind tx gov vote 1 no --from wallet --chain-id self-dev-1 --gas auto --gas-adjustment 1.5 -y
```
Vote 'Abstain'
```
selfchaind tx gov vote 1 abstain --from wallet --chain-id self-dev-1 --gas auto --gas-adjustment 1.5 -y
```
Vote 'NoWithVeto'
```
selfchaind tx gov vote 1 nowithveto --from wallet --chain-id self-dev-1 --gas auto --gas-adjustment 1.5 -y
```
Remove node
```
sudo systemctl stop selfchaind
sudo systemctl disable selfchaind
sudo rm /etc/systemd/system/selfchaind.service
sudo systemctl daemon-reload
rm -f $(which selfchaind)
rm -rf $HOME/.selfchain
```
