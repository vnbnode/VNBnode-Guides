# Command OG

## Managing keys
Generate new key
```
evmosd keys add wallet
```
Recover key
```
evmosd keys add wallet --recover
```
List all key
```
evmosd keys list
```
Query wallet balances
```
evmosd q bank balances $(evmosd keys show wallet -a)
```

## Managing validators
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
Unjail
```
evmosd tx slashing unjail --from wallet --chain-id zgtendermint_9000-1 --gas-adjustment 1.4 --gas auto --gas-prices=99999aevmos -y
```
View validator details
```
evmosd keys show wallet --bech val -a
```
Query active validators
```
evmosd q staking validators -o json --limit=1000 \
| jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
Query inactive validators
```
evmosd q staking validators -o json --limit=1000 \
| jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```

## Managing Tokens
Delegate tokens to your validator
```
evmosd tx staking delegate $(evmosd keys show $WALLET_NAME --bech val -a)  10000000000000000aevmos --from $WALLET_NAME --gas=500000 --gas-prices=99999aevmos -y
```
Send token
```
evmosd tx bank send <WALLET> <TO_WALLET> <AMOUNT>aevmos --gas=500000 --gas-prices=99999aevmos -y
```
Withdraw reward from all validator
```
evmosd tx distribution withdraw-all-rewards --from wallet --chain-id zgtendermint_9000-1 --gas-adjustment 1.4 --gas auto --gas-prices=99999aevmos -y
```
Withdraw reward and commission
```
evmosd tx distribution withdraw-rewards $(evmosd keys show wallet --bech val -a) --commission --from wallet --chain-id zgtendermint_9000-1 --gas-adjustment 1.4 --gas auto --gas-prices=99999aevmos -y
```
Redelegate to another validator
```
evmosd tx staking redelegate $(evmosd keys show wallet --bech val -a) <to-valoper-address> 1000000stake --from wallet --chain-id zgtendermint_9000-1 --gas-adjustment 1.4 --gas auto --gas-prices=99999aevmos -y
```

## Governance
Query list proposal
```
evmosd query gov proposals
```
View proposal by ID
```
evmosd query gov proposal 1
```
Vote yes
```
evmosd tx gov vote 1 yes --from wallet --gas-prices=99999aevmos -y
```
Vote No
```
evmosd tx gov vote 1 no --from wallet --gas-prices=99999aevmos -y
```
Vote option asbtain
```
evmosd tx gov vote 1 abstain --from wallet --gas-prices=99999aevmos -y
```
Vote option NoWithVeto
```
evmosd tx gov vote 1 NoWithVeto --from wallet --gas-prices=99999aevmos -y
```

## Maintenance
Check sync
```
evmosd status 2>&1 | jq .SyncInfo
```
Node status
```
evmosd status | jq
```
Get validator information
```
evmosd status 2>&1 | jq .ValidatorInfo
```
Get your p2p peer address
```
echo $(evmosd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.evmosd/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
Get peers live
```
curl -sS http://localhost:${og}57/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```



