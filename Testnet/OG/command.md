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
echo $(evmosd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.evmosd/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
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
![image](https://github-production-user-asset-6210df.s3.amazonaws.com/76662222/320301419-007a32ee-fc07-454e-b8ee-f9202e722e07.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAVCODYLSA53PQK4ZA%2F20240410%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20240410T124457Z&X-Amz-Expires=300&X-Amz-Signature=4640b8af38ee4264de6a2482322142c8226edc41e090cd260320b2b4211be59b&X-Amz-SignedHeaders=host&actor_id=76662222&key_id=0&repo_id=714523124)

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
