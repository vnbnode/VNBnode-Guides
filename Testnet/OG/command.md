# Command OG

## Managing keys
```
evmosd keys add $WALLET_NAME
```
Check sync
```
evmosd status | jq .SyncInfo.catching_up
```

Node status
```
evmosd status | jq
```

Get your p2p peer address
```
echo $(evmosd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.evmosd/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```

Check balance
```
evmosd q bank balances $(evmosd keys show $WALLET_NAME -a) 
```

Send token
```
evmosd tx bank send $WALLET_NAME <TO_WALLET> <AMOUNT>aevmos --gas=500000 --gas-prices=99999aevmos -y
```

Create validator
```
evmosd tx staking create-validator \
  --amount=10000000000000000aevmos \
  --commission-max-change-rate 0.01 \
  --commission-max-rate 0.1 \
  --commission-rate 0.1 \
  --from wallet \
  --min-self-delegation 1 \
  --moniker $MONIKER \
  --security-contact "" \
  --identity "06F5F34BD54AA6C7" \
  --website "https://vnbnode.com" \
  --details "VNBnode is a group of professional validators" \
  --pubkey $(evmosd tendermint show-validator) \
  --chain-id zgtendermint_9000-1 \
  --gas=500000 --gas-prices=99999aevmos \
  -y
```

Show validator
```
evmosd keys show $WALLET_NAME --bech val -a
```

Delegate
```
evmosd tx staking delegate $(evmosd keys show $WALLET_NAME --bech val -a)  10000000000000000aevmos --from $WALLET_NAME --gas auto --gas-adjustment 1.5 --gas-prices=99999aevmos --chain-id zgtendermint_9000-1 -y
```
Unjail
```
evmosd tx slashing unjail --from wallet --chain-id zgtendermint_9000-1 --gas-adjustment 1.4 --gas auto --gas-prices=99999aevmos -y
```
Edit validator
```
evmosd tx staking edit-validator \
--new-moniker "NewName-VNBnode" \
--identity "06F5F34BD54AA6C7" \
--website "https://vnbnode.com" \
--details "VNBnode is a group of professional validators" \
--security-contact "" \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
-chain-id zgtendermint_9000-1 \
--gas=500000 --gas-prices=99999aevmos \
-y
```
