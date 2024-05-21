# Command Airchain

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
--new-moniker "Your_Moniker" \
--identity "Keybase_ID" \
--details "Your_Description" \
--website "Your_Website" \
--security-contact "Your_Email" \
--chain-id junction \
--commission-rate 0.05 \
--from Wallet_Name \
--gas 350000 -y
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
junctiond tx gov vote 1 yes --from Wallet_Name --gas 350000  --chain-id=junction -y
```

### Vote no
```
junctiond tx gov vote 1 no --from Wallet_Name --gas 350000  --chain-id=junction -y
```

### Vote abstain
```
junctiond tx gov vote 1 abstain --from Wallet_Name --gas 350000  --chain-id=junction -y
```

### Vote no_with_veto
```
junctiond tx gov vote 1 no_with_veto --fr
```






