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
## Synch check
```
initiad status 2>&1 | jq .sync_info
```
## Create validator
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
initiad q mstaking validator $(initiad keys show wallet --bech val -a)
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

