# GUIDE TO CREATE GORVERNOR OF ROLLAPPS
## Version: DYM-Playground-DRS4
## Create Validator
👉 wallet is the name of validator key
```
rollappd keys add wallet --keyring-backend test
```
👉❗SAVE YOUR SEED PHRASE SAFELY
![image](https://github.com/user-attachments/assets/9ec03833-ca72-43b3-a960-9e36574f4dfe)

### Initiate Validator
```
rollappd init VNBnode --chain-id=<Rollapp Network ID>
```
### Fund the wallet
👉❗https://playground.dymension.xyz/rollapps/fingamex_886342-1/dashboard

### Check Fund balance in the wallet
```
rollappd q bank balances $(rollappd keys show wallet -a)
```
### Create Validator
```
rollappd tx staking create-validator \
    --amount=1000000000000000000aftbx \
    --moniker=VNBnode \
    --chain-id=fingamex_886342-1 \
    --from=wallet \
    --keyring-backend test \
    --commission-rate=0.05 \
    --commission-max-rate=0.20 \
    --commission-max-change-rate=0.01 \
    --min-self-delegation=1 \
    --pubkey=$(rollappd dymint show-sequencer) \
    --node=http://localhost:26657 \
    --fees 4000000000000aftbx --gas auto --gas-adjustment 1.3 -y
```
<img width="590" alt="image" src="https://github.com/user-attachments/assets/45e8f97c-b2fe-4465-8954-e28088369b50" />

### Check existing version
```
rollappd q rollappparams params
```
<img width="341" alt="image" src="https://github.com/user-attachments/assets/f715f04b-aaa1-4bb2-9078-34f2f19d283c" />

### Check current block height
```
rollappd q block | jq -r '.block.header.height'
```
### Create proposal
👉❗change token symbol in "deposit"
```
sudo tee proposal.json > /dev/null << EOF
{
  "title": "Update rollapp to DRS-4",
  "description": "Upgrade Dymension rollapp to version DRS-4 scheduled upgrade time",
  "summary": "This proposal aims to upgrade the Dymension rollapp to version DRS-4, implementing new features and improvements, with a scheduled upgrade time.",
  "messages": [
    {
      "@type": "/rollapp.timeupgrade.types.MsgSoftwareUpgrade",
      "original_upgrade": {
        "authority": "<authority-address>",
        "plan": {
          "name": "drs-4",
          "time": "0001-01-01T00:00:00Z",
          "height": "1800",
          "info": "{}",
          "upgraded_client_state": null
        }
      },
      "upgrade_time": "2024-09-06T18:10:00Z"
    }
  ],
  "deposit": "500aftbx",
  "expedited": true
}
EOF
```
### Change authority address
```
rollappd q auth module-account gov -o json | jq -r '.account.base_account.address' | xargs -I {} sed -i 's/<authority-address>/{}/' proposal.json
```
### Submit Proposal
👉❗change token symbol and "Rollapp Network ID"
```
rollappd tx gov submit-proposal proposal.json --from wallet --keyring-backend test --fees 4000000000000aftbx --gas auto --gas-adjustment 1.3 --chain-id <Rollapp Network ID> -b block
```
### GOV Vote
👉❗change token symbol and "Rollapp Network ID"
```
rollappd tx gov vote 1 yes --from wallet --keyring-backend test --fees 4000000000000aftbx --gas auto --gas-adjustment 1.3 --chain-id <Rollapp Network ID> -b block
```
