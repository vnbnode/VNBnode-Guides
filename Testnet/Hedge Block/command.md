# Command AlignedLayer

### Managing keys
Generate new key
```
hedged keys add wallet
```
Recover key
```
hedged keys add wallet --recover
```
List all key
```
hedged keys list
```
Query wallet balances
```
hedged q bank balances $(hedged keys show wallet -a)
```

### Managing validators
Create validator
```
hedged tx staking create-validator \
  --amount=1000000uhedge \
  --commission-max-change-rate 0.01 \
  --commission-max-rate 0.1 \
  --commission-rate 0.1 \
  --from wallet \
  --min-self-delegation 1 \
  --moniker $MONIKER \
  --security-contact "" \
  --identity "06F5F34BD54AA6C7" \
  --website "https://vnbnode.com" \
  --details "VNBnode is a group of professional validators / researchers in blockchain" \
  --pubkey $(hedged tendermint show-validator) \
  --chain-id=berberis-1 \
  --gas-prices="0.025uhedge" \
  -y
```
Edit validator
```
hedged tx staking edit-validator \
--new-moniker "NewName-VNBnode" \
--identity "06F5F34BD54AA6C7" \
--website "https://vnbnode.com" \
--details "VNBnode is a group of professional validators / researchers in blockchain" \
--security-contact "" \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--chain-id=berberis-1 \
--gas-prices 0.025uhedge \
-y
```
Unjail
```
hedged tx slashing unjail --from wallet --gas-prices 0.025uhedge --chain-id=berberis-1 -y
```
View validator details
```
hedged keys show wallet --bech val -a
```
Query active validators
```
hedged q staking validators -o json --limit=1000 \
| jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
Query inactive validators
```
hedged q staking validators -o json --limit=1000 \
| jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```

### Managing Tokens
Delegate tokens to your validator
```
hedged tx staking delegate $(hedged keys show wallet --bech val -a) 1000000stake --from wallet --gas-prices 0.025uhedge --chain-id=berberis-1 -y
```
Send token
```
hedged tx bank send <WALLET> <TO_WALLET> <AMOUNT>uhedge --gas-prices 0.025uhedge --chain-id=berberis-1 -y
```
Withdraw reward from all validator
```
hedged tx distribution withdraw-all-rewards --from wallet --gas-prices 0.025uhedge --chain-id=berberis-1 -y
```
Withdraw reward and commission
```
hedged tx distribution withdraw-rewards $(hedged keys show wallet --bech val -a) --commission --from wallet --gas-prices 0.025uhedge --chain-id=berberis-1 -y
```
Redelegate to another validator
```
hedged tx staking redelegate $(hedged keys show wallet --bech val -a) <to-valoper-address> 1000000stake --from wallet --gas-prices 0.025uhedge --chain-id=berberis-1 -y
```

### Governance
Query list proposal
```
hedged query gov proposals
```
View proposal by ID
```
hedged query gov proposal 1
```
Vote yes
```
hedged tx gov vote 1 yes --from wallet --gas-prices 0.025uhedge -y
```
Vote No
```
hedged tx gov vote 1 no --from wallet --gas-prices 0.025uhedge -y
```
Vote option asbtain
```
hedged tx gov vote 1 abstain --from wallet --gas-prices 0.025uhedge -y
```
Vote option NoWithVeto
```
hedged tx gov vote 1 NoWithVeto --from wallet --gas-prices 0.025uhedge -y
```

### Maintenance
Check sync
```
hedged status 2>&1 | jq .SyncInfo
```
Node status
```
hedged status | jq
```
Get validator information
```
hedged status 2>&1 | jq .ValidatorInfo
```
Get your p2p peer address
```
echo $(hedged tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.hedge/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
Get peers live
```
curl -sS http://localhost:${hedge}57/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
