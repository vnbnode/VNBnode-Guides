Key management
Add New Wallet
```
mantrachaind keys add wallet
```
Restore executing wallet
```
mantrachaind keys add wallet --recover
```
List All Wallets
```
mantrachaind keys list
```
Delete wallet
```
mantrachaind keys delete wallet
```
Check Balance
```
mantrachaind q bank balances $(mantrachaind keys show wallet -a)
```
Export Key (save to wallet.backup)
```
mantrachaind keys export wallet
```
Import Key (restore from wallet.backup)
```
mantrachaind keys import wallet wallet.backup
```
Withdraw all rewards
```
mantrachaind tx distribution withdraw-all-rewards --from wallet --chain-id mantrachain-testnet-1 --gas auto --gas-adjustment 1.5
```
Withdraw rewards and commission from your validator
```
mantrachaind tx distribution withdraw-rewards $(mantrachaind keys show wallet --bech val -a) --commission --from wallet --chain-id mantrachain-testnet-1 --gas-prices=0uaum --gas-adjustment 1.5 --gas "auto" -y 
```
Delegate to Yourself
```
mantrachaind tx staking delegate $(mantrachaind keys show wallet --bech val -a) 1000000uaum --from wallet --chain-id mantrachain-testnet-1 --gas auto --gas-adjustment 1.5 -y
```
Delegate
```
mantrachaind tx staking delegate <TO_VALOPER_ADDRESS> 1000000uaum --from wallet --chain-id mantrachain-testnet-1 --gas auto --gas-adjustment 1.5 -y
```
Redelegate Stake to Another Validator
```
mantrachaind tx staking redelegate $VALOPER_ADDRESS <TO_VALOPER_ADDRESS> 1000000uaum --from wallet --chain-id mantrachain-testnet-1 --gas auto --gas-adjustment 1.5 -y
```
Unbond
```
mantrachaind tx staking unbond $(mantrachaind keys show wallet --bech val -a) 1000000uaum --from wallet --chain-id mantrachain-testnet-1 --gas auto --gas-adjustment 1.5 -y
```
Transfer Funds
```
mantrachaind tx bank send wallet_ADDRESS <TO_WALLET_ADDRESS> 1000000uaum --gas auto --gas-adjustment 1.5 -y
```
Create New Validator
```
mantrachaind tx staking create-validator \
  --amount "1000000uaum" \
  --pubkey $(mantrachaind tendermint show-validator) \
  --moniker "MONIKER" \
  --identity "KEYBASE_ID" \
  --details "YOUR DETAILS" \
  --website "YOUR WEBSITE" \
  --chain-id mantrachain-testnet-1 \
  --commission-rate "0.05" \
  --commission-max-rate "0.20" \
  --commission-max-change-rate "0.01" \
  --min-self-delegation "1" \
  --gas-prices "0uaum" \
  --gas "auto" \
  --gas-adjustment "1.5" \
  --from wallet \
  -y
```
Edit Existing Validator
```
mantrachaind tx staking edit-validator \
--commission-rate 0.1 \
--new-moniker "$MONIKER" \
--identity "" \
--details "" \
--from wallet \
--chain-id mantrachain-testnet-1 \
--gas auto --gas-adjustment 1.5 \
-y
```
Validator info
```
mantrachaind status 2>&1 | jq .ValidatorInfo
```
Validator Details
```
mantrachaind q staking validator $(mantrachaind keys show wallet --bech val -a)
```
Jailing info
```
mantrachaind q slashing signing-info $(mantrachaind tendermint show-validator)
```
Unjail validator
```
mantrachaind tx slashing unjail --from wallet --chain-id mantrachain-testnet-1 --gas auto --gas-adjustment 1.5 -y
```
Active Validators List
```
mantrachaind q staking validators -oj --limit=2000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " 	 " + .description.moniker' | sort -gr | nl
```
Check Validator key
```
[[ $(mantrachaind q staking validator $VALOPER_ADDRESS -oj | jq -r .consensus_pubkey.key) = $(mantrachaind status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "Your key status is ok" || echo -e "Your key status is error"
```
Signing info
```
mantrachaind q slashing signing-info $(mantrachaind tendermint show-validator)
```
```
mantrachaind  tx gov submit-proposal \
--title "" \
--description "" \
--deposit 1000000uaum \
--type Text \
--from wallet \
--gas auto --gas-adjustment 1.5 \
-y
```
🗳 Governance
List all proposals
```
mantrachaind query gov proposals
```
View proposal by id
```
mantrachaind query gov proposal 1
```
Vote 'Yes'
```
mantrachaind tx gov vote 78 yes --from wallet --chain-id mantrachain-testnet-1 --gas auto --gas-adjustment 1.5 -y
```
Vote 'No'
```
mantrachaind tx gov vote 1 no --from wallet --chain-id mantrachain-testnet-1 --gas auto --gas-adjustment 1.5 -y
```
Vote 'Abstain'
```
mantrachaind tx gov vote 1 abstain --from wallet --chain-id mantrachain-testnet-1 --gas auto --gas-adjustment 1.5 -y
```
Vote 'NoWithVeto'
```
mantrachaind tx gov vote 1 nowithveto --from wallet --chain-id mantrachain-testnet-1 --gas auto --gas-adjustment 1.5 -y
```
Remove node
```
sudo systemctl stop mantrachaind
sudo systemctl disable mantrachaind
sudo rm /etc/systemd/system/mantrachaind.service
sudo systemctl daemon-reload
rm -f $(which mantrachaind)
rm -rf $HOME/mantrachaind
rm -rf $HOME/.mantrachain
rm -rf $HOME/mantra.sh
```
