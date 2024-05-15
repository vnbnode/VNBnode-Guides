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
initiad q bank balances $(initiad keys show wallet -a)
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
  --from=wallet \
  --gas=auto \
  --gas-adjustment=1.4 \
  --fees=300000uinit \
  -y
```
