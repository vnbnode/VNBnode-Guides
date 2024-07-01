# Commands for Airchains

## Managing keys
### Generate new key
```
junctiond keys add wallet
```
### Recover key
```
junctiond keys add $WALLET --recover
```
### List all key
```
junctiond keys list
```
### delete key
```
junctiond keys delete Wallet_Name
```
### Query wallet balances
```
junctiond q bank balances $(junctiond keys show wallet -a)
```

### Save wallet and validator address
```
WALLET_ADDRESS=$(junctiond keys show $WALLET -a)
VALOPER_ADDRESS=$(junctiond keys show $WALLET --bech val -a)
echo "export WALLET_ADDRESS="$WALLET_ADDRESS >> $HOME/.bash_profile
echo "export VALOPER_ADDRESS="$VALOPER_ADDRESS >> $HOME/.bash_profile
source $HOME/.bash_profile
```
### Check sync status, once your node is fully synced, the output from above will print "false"
```
junctiond status 2>&1 | jq 
```

### Before creating a validator, you need to fund your wallet and check balance
```
junctiond query bank balances $WALLET_ADDRESS 
```
## Managing validators
### Create validator.json file
```
cd $HOME
# Create validator.json file
echo "{\"pubkey\":{\"@type\":\"/cosmos.crypto.ed25519.PubKey\",\"key\":\"$(junctiond comet show-validator | grep -Po '\"key\":\s*\"\K[^"]*')\"},
    \"amount\": \"1000000amf\",
    \"moniker\": \"Yourname|VNBnode\",
    \"identity\": \"06F5F34BD54AA6C7\",
    \"website\": \"https://vnbnode.com\",
    \"security\": \"\",
    \"details\": \"VNBnode is a group of professional validators / researchers in blockchain\",
    \"commission-rate\": \"0.1\",
    \"commission-max-rate\": \"0.2\",
    \"commission-max-change-rate\": \"0.01\",
    \"min-self-delegation\": \"1\"
}" > validator.json
```
### Create a validator using the JSON configuration
```
junctiond tx staking create-validator validator.json \
    --from wallet \
    --chain-id junction \
    --fees 200amf \
    -y
```
### Edit Validator

```
junctiond tx staking edit-validator \
--new-moniker "Yourname|VNBnode" \
--identity "06F5F34BD54AA6C7" \
--website "https://vnbnode.com" \
--security-contact "Your_Email" \
--chain-id junction \
--commission-rate 0.05 \
--from wallet \
--gas 350000 -y
```

### Valoper-Address
```
junctiond keys show wallet --bech val
```
### Validator-Info
```
junctiond query staking validator airvaloper1qmdeucu95ex0awrj7yd48j2x7qptk6tpszh6fx
```

### Jail Info
```
junctiond query slashing signing-info $(junctiond tendermint show-validator)
```
### Unjail
```
junctiond tx slashing unjail --from wallet --chain-id junction --gas 350000 -y
```
### Withdraw all rewards from all validators
```
junctiond  tx distribution withdraw-all-rewards --from wallet --chain-id junction --gas 350000 -y
```

### Withdraw rewards and commission from your Validator
```
junctiond tx distribution withdraw-rewards airvaloper1qmdeucu95ex0awrj7yd48j2x7qptk6tpszh6fx --from wallet --gas 350000 --chain-id=junction --commission -y
```
### Delegate tokens to your validator
```
junctiond tx staking delegate $(junctiond keys show wallet --bech val -a) 9990000amf --from wallet --chain-id junction --fees 200amf -y
```

## Governance

### View all proposals
```
junctiond query gov proposals
```

### View specific proposal
```
junctiond query gov proposal 1
```

### Vote yes
```
junctiond tx gov vote 1 yes --from wallet --gas 350000  --chain-id=junction -y
```

### Vote no
```
junctiond tx gov vote 1 no --from wallet --gas 350000  --chain-id=junction -y
```

### Vote abstain
```
junctiond tx gov vote 1 abstain --from wallet --gas 350000  --chain-id=junction -y
```

### Vote no_with_veto
```
junctiond tx gov vote 1 no_with_veto --fr
```






