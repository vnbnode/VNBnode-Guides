# Commands

## Managing keys
Generate new key
```
initiad keys add wallet
```
Recover key
```
initiad keys add wallet --recover
```
List all key
```
initiad keys list
```
Query wallet balances
```
initiad q bank balances $(initiad keys show wallet -a) --node https://rpc-initia-testnet.trusted-point.com:443
```
Check Balance

```
initiad q bank balances $WALLET_ADDRESS
```
Export Key (save to wallet.backup)

```
initiad keys export $WALLET
```

View EVM Prived Key

```
initiad keys unsafe-export-eth-key $WALLET
```
Import Key (restore from wallet.backup)

```
initiad keys import $WALLET wallet.backup
```
## Synch check
```
initiad status 2>&1 | jq .sync_info
```
## Node info

```
initiad status 2>&1 | jq
```
## Your node peer

```
echo $(initiad tendermint show-node-id)'
```
## Manage Validator

Create validator
```
initiad tx mstaking create-validator \
  --amount=1000000uinit \
  --pubkey=$(initiad tendermint show-validator) \
  --moniker=$MONIKER \
  --chain-id=initiation-1 \
  --identity="06F5F34BD54AA6C7" \
  --website="https://vnbnode.com" \
  --details="VNBnode is a group of professional validators / researchers in blockchain" \
  --security-contact="email-address" \
  --commission-rate="0.05" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.05" \
  --gas=auto \
  --gas-adjustment=1.4 \
  --fees=300000uinit \
  --node https://rpc-initia-testnet.trusted-point.com:443 \
  --from=wallet \
  -y
```

Edit validator
```
initiad tx mstaking edit-validator --website="https://vnbnode.com" --details="VNBnode is a group of professional validators / researchers in blockchain" --chain-id=initiation-1 --moniker="Name_VNBnode" --from=wallet --gas=2000000 --fees=300000uinit -y
```
Check validator info
```
initiad q mstaking validator $(initiad keys show wallet --bech val -a) --node https://rpc-initia-testnet.trusted-point.com:443
```
Jailing info

```
initiad q slashing signing-info $(initiad tendermint show-validator)
```
Slashing parameters

```
initiad q slashing params
```
Unjail validator

```
initiad tx slashing unjail --from $WALLET --chain-id initiation-1 --gas auto --fees 80000uinit -y
```
Active Validators List

```
initiad q staking validators -oj --limit=2000 | jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' | jq -r '(.tokens|tonumber/pow(10; 6)|floor|tostring) + " 	 " + .description.moniker' | sort -gr | nl
```
Check Validator key

```
[[ $(initiad q staking validator $VALOPER_ADDRESS -oj | jq -r .consensus_pubkey.key) = $(initiad status | jq -r .ValidatorInfo.PubKey.value) ]] && echo -e "Your key status is ok" || echo -e "Your key status is error"
```
Signing info

```
initiad q slashing signing-info $(initiad tendermint show-validator) 
```

## Managing Tokens
Delegate tokens to your validator
```
initiad tx mstaking delegate $(initiad keys show wallet --bech val -a)  1000000uinit --from wallet --chain-id initiation-1 --gas=auto -y
```
Send token
```
initiad tx bank send <WALLET> <TO_WALLET> <AMOUNT>uinit --gas=500000 -y
```
Withdraw reward from all validator
```
initiad tx distribution withdraw-all-rewards --from wallet --chain-id initiation-1 --gas-adjustment 1.4 --gas auto -y
```
Withdraw reward and commission
```
initiad tx distribution withdraw-rewards $(initiad keys show wallet --bech val -a) --commission --from wallet --chain-id initiation-1 --gas-adjustment 1.4 --gas auto -y
```
## Governance
Create New Text Proposal

```
initiad  tx gov submit-proposal \
--title "" \
--description "" \
--deposit 1000000uinit \
--type Text \
--from $WALLET \
--gas auto --fees 80000uinit \
-y
```
Proposals List
```
initiad query gov proposals
```
View proposal

```
initiad query gov proposal 1
```
Vote

```
initiad tx gov vote 1 yes --from $WALLET --chain-id initiation-1  --gas auto --fees 80000uinit -y 
```
