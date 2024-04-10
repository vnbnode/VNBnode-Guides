# Command OG

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
evmosd status | jq -r '"\(.NodeInfo.id)@\(.NodeInfo.listen_addr)"'
```

Create wallet
```
evmosd keys add $WALLET_NAME
evmosd keys list
```

Faucet
```
echo "0x$(evmosd debug addr $(evmosd keys show wallet -a) | grep hex | awk '{print $3}')"
```
![image](https://github.com/vnbnode/docs/assets/76662222/007a32ee-fc07-454e-b8ee-f9202e722e07)

[Link Faucet](https://faucet.0g.ai)

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

Delegate
```
evmosd tx staking delegate fairyvaloper1l89kp2ut04s8svltg9j9ue3z88hejypnnjk8c4 10000000000000000aevmos --from wallet --gas auto --gas-adjustment 1.5 --gas-prices=99999aevmos --chain-id zgtendermint_9000-1
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
