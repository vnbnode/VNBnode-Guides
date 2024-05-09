# Command OG

## Managing keys
Generate new key
```
0gchaind keys add wallet --eth
```
Recover key
```
0gchaind keys add wallet --recover --eth
```
List all key
```
0gchaind keys list
```
Query wallet balances
```
0gchaind q bank balances $(0gchaind keys show wallet -a)
```

## Managing validators
Create validator
```
0gchaind tx staking create-validator \
  --amount=<staking_amount>ua0gi \
  --pubkey=$(0gchaind tendermint show-validator) \
  --moniker="<your_validator_name>" \
  --chain-id=zgtendermint_16600-1 \
  --commission-rate="0.10" \
  --commission-max-rate="0.20" \
  --commission-max-change-rate="0.01" \
  --min-self-delegation="1" \
  --security-contact "" \
  --identity "06F5F34BD54AA6C7" \
  --website "https://vnbnode.com" \
  --details "VNBnode is a group of professional validators / researchers in blockchain" \
  --from=<key_name> \
  --gas-adjustment=1.4 \
  --gas-prices 0.00252ua0gi
```
Edit validator
```
0gchaind tx staking edit-validator \
--new-moniker "NewName-VNBnode" \
--identity "06F5F34BD54AA6C7" \
--website "https://vnbnode.com" \
--details "VNBnode is a group of professional validators / researchers in blockchain" \
--security-contact "" \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
-chain-id zgtendermint_16600-1 \
--gas=auto --gas-prices=0.00252ua0gi \
-y
```
Unjail
```
0gchaind tx slashing unjail --from wallet --chain-id zgtendermint_16600-1 --gas-adjustment 1.4 --gas auto --gas-prices=0.00252ua0gi -y
```
View validator details
```
0gchaind keys show wallet --bech val -a
```
Query active validators
```
0gchaind q staking validators -o json --limit=1000 \
| jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
Query inactive validators
```
0gchaind q staking validators -o json --limit=1000 \
| jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```

## Managing Tokens
Delegate tokens to your validator
```
0gchaind tx staking delegate $(0gchaind keys show $WALLET_NAME --bech val -a)  10000000000000000ua0gi --from $WALLET_NAME --gas=500000 --gas-prices=0.00252ua0gi -y
```
Send token
```
0gchaind tx bank send <WALLET> <TO_WALLET> <AMOUNT>ua0gi --gas=500000 --gas-prices=0.00252ua0gi -y
```
Withdraw reward from all validator
```
0gchaind tx distribution withdraw-all-rewards --from wallet --chain-id zgtendermint_16600-1 --gas-adjustment 1.4 --gas auto --gas-prices=0.00252ua0gi -y
```
Withdraw reward and commission
```
0gchaind tx distribution withdraw-rewards $(0gchaind keys show wallet --bech val -a) --commission --from wallet --chain-id zgtendermint_16600-1 --gas-adjustment 1.4 --gas auto --gas-prices=0.00252ua0gi -y
```
Redelegate to another validator
```
0gchaind tx staking redelegate $(0gchaind keys show wallet --bech val -a) <to-valoper-address> 1000000stake --from wallet --chain-id zgtendermint_16600-1 --gas-adjustment 1.4 --gas auto --gas-prices=0.00252ua0gi -y
```

## Governance
Query list proposal
```
0gchaind query gov proposals
```
View proposal by ID
```
0gchaind query gov proposal 1
```
Vote yes
```
0gchaind tx gov vote 1 yes --from wallet --gas-prices=0.00252ua0gi -y
```
Vote No
```
0gchaind tx gov vote 1 no --from wallet --gas-prices=0.00252ua0gi -y
```
Vote option asbtain
```
0gchaind tx gov vote 1 abstain --from wallet --gas-prices=0.00252ua0gi -y
```
Vote option NoWithVeto
```
0gchaind tx gov vote 1 NoWithVeto --from wallet --gas-prices=0.00252ua0gi -y
```

## Maintenance
Check sync
```
0gchaind status 2>&1 | jq .SyncInfo
```
Node status
```
0gchaind status | jq
```
Get validator information
```
0gchaind status 2>&1 | jq .ValidatorInfo
```
Get your p2p peer address
```
echo $(evmosd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.evmosd/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
Get peers live
```
curl -sS http://localhost:${og}57/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
