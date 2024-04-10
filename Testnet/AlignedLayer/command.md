# Command AlignedLayer

## Managing keys
Generate new key
```
alignedlayerd keys add wallet
```
Recover key
```
alignedlayerd keys add wallet --recover
```
List all key
```
alignedlayerd keys list
```
Query wallet balances
```
alignedlayerd q bank balances $(alignedlayerd keys show wallet -a)
```

## Managing validators
Create validator
```
cd $HOME
alignedlayerd tendermint show-validator
```

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/b64a2a03-e384-4b8b-b962-22bad6cfe422)

Please create `validator.json` replace {...} inside like below
```
nano $HOME/.alignedlayer/config/validator.json
```
```
{
    "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"IkGeamll8JFsV5jqoT37JfI37Ey/viBTZJLvLv8hlF0="},
    "amount": "1000000stake",
    "moniker": "Name-VNBnode",
    "identity": "06F5F34BD54AA6C7",
    "website": "https://vnbnode.com",
    "details": "VNBnode is a group of professional validators",
    "commission-rate": "0.1",
    "commission-max-rate": "0.2",
    "commission-max-change-rate": "0.01",
    "min-self-delegation": "1"
}
```
Proceed to create validation
```
alignedlayerd tx staking create-validator $HOME/.alignedlayer/config/validator.json \
--from wallet --chain-id alignedlayer \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.0001stake
--node tcp://rpc-node.alignedlayer.com:26657
```
Edit validator
```
alignedlayerd tx staking edit-validator \
--new-moniker "Name-VNBnode" \
--identity "06F5F34BD54AA6C7" \
--website "https://vnbnode.com" \
--details "VNBnode is a group of professional validators" \
--security-contact "email" \
--chain-id alignedlayer \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.0001stake \
-y
```
Unjail
```
alignedlayerd tx slashing unjail --from wallet --chain-id alignedlayer --gas-adjustment 1.4 --gas auto --gas-prices 0.0001stake -y
```
View validator details
```
alignedlayerd keys show wallet --bech val -a
```
Query active validators
```
alignedlayerd q staking validators -o json --limit=1000 \
| jq '.validators[] | select(.status=="BOND_STATUS_BONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```
Query inactive validators
```
alignedlayerd q staking validators -o json --limit=1000 \
| jq '.validators[] | select(.status=="BOND_STATUS_UNBONDED")' \
| jq -r '.tokens + " - " + .description.moniker' \
| sort -gr | nl
```

## Managing Tokens
Delegate tokens to your validator
```
alignedlayerd tx staking delegate $(alignedlayerd keys show wallet --bech val -a) 1000000stake --from wallet --chain-id alignedlayer --gas-adjustment 1.4 --gas auto --gas-prices 0.0001stake -y
```
Send token
```
alignedlayerd tx bank send <WALLET> <TO_WALLET> <AMOUNT>aevmos --gas=500000 --gas-prices=99999aevmos -y
```
Withdraw reward from all validator
```
alignedlayerd tx distribution withdraw-all-rewards --from wallet --chain-id alignedlayer --gas-adjustment 1.4 --gas auto --gas-prices=99999aevmos -y
```
Withdraw reward and commission
```
alignedlayerd tx distribution withdraw-rewards $(alignedlayerd keys show wallet --bech val -a) --commission --from wallet --chain-id alignedlayer --gas-adjustment 1.4 --gas auto --gas-prices=99999aevmos -y
```
Redelegate to another validator
```
alignedlayerd tx staking redelegate $(alignedlayerd keys show wallet --bech val -a) <to-valoper-address> 1000000stake --from wallet --chain-id alignedlayer --gas-adjustment 1.4 --gas auto --gas-prices=99999aevmos -y
```

## Governance
Query list proposal
```
alignedlayerd query gov proposals
```
View proposal by ID
```
alignedlayerd query gov proposal 1
```
Vote yes
```
alignedlayerd tx gov vote 1 yes --from wallet --chain-id alignedlayer --gas-adjustment 1.4 --gas auto --gas-prices=99999aevmos -y
```
Vote No
```
alignedlayerd tx gov vote 1 no --from wallet --chain-id alignedlayer --gas-adjustment 1.4 --gas auto --gas-prices=99999aevmos -y
```
Vote option asbtain
```
alignedlayerd tx gov vote 1 abstain --from wallet --chain-id alignedlayer --gas-adjustment 1.4 --gas auto --gas-prices=99999aevmos -y
```
Vote option NoWithVeto
```
alignedlayerd tx gov vote 1 NoWithVeto --from wallet --chain-id alignedlayer --gas-adjustment 1.4 --gas auto --gas-prices=99999aevmos -y
```

## Maintenance
Check sync
```
alignedlayerd status 2>&1 | jq .SyncInfo
```
Node status
```
alignedlayerd status | jq
```
Get validator information
```
alignedlayerd status 2>&1 | jq .ValidatorInfo
```
Get your p2p peer address
```
echo $(alignedlayerd tendermint show-node-id)'@'$(curl -s ifconfig.me)':'$(cat $HOME/.alignedlayerd/config/config.toml | sed -n '/Address to listen for incoming connection/{n;p;}' | sed 's/.*://; s/".*//')
```
Get peers live
```
curl -sS http://localhost:${aligned}57/net_info | jq -r '.result.peers[] | "\(.node_info.id)@\(.remote_ip):\(.node_info.listen_addr)"' | awk -F ':' '{print $1":"$(NF)}'
```
