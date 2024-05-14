# Command Airchain

## Managing keys
Generate new key
```
junctiond keys add wallet --eth
```
Recover key
```
junctiond keys add wallet --recover --eth
```
List all key
```
junctiond keys list
```
Query wallet balances
```
junctiond q bank balances $(junctiond keys show wallet -a)
```

## Managing validators
Create validator.json file
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

```
# Create a validator using the JSON configuration

junctiond tx staking create-validator validator.json \
    --from wallet \
    --chain-id junction \
    --fees 200amf \
    -y
```
