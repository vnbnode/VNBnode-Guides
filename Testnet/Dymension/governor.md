# GUIDE TO CREATE GORVERNOR PROPOSAL OF ROLLAPP
## Version: DYM-Playground-DRS4

## I. Create Validator
### Define network & token symbol
👉❗Change to your Rollapp Network ID
```
network="fingamex_886342-1"
```
👉❗Change to your Token Symbol
```
token="ftbx"
```
👉 wallet is the name of validator key
```
rollappd keys add wallet --keyring-backend test
```
👉❗SAVE YOUR SEED PHRASE SAFELY
![image](https://github.com/user-attachments/assets/9ec03833-ca72-43b3-a960-9e36574f4dfe)

### Initiate Validator
```
rollappd init VNBnode --chain-id=$network
```
### Fund the wallet
👉❗https://playground.dymension.xyz/rollapps/fingamex_886342-1/dashboard

### Check Fund balance in the wallet
```
rollappd q bank balances $(rollappd keys show wallet -a)
```
IF THIS COMMAND NOT WORK, ADD WALLET AGAIN WITH SEED PHRASE
```
rollappd keys add wallet --recover
```
### Create Validator
👉❗change token symbol and "Rollapp Network ID"
```
rollappd tx staking create-validator \
    --amount=1000000000000000000a$token \
    --moniker=VNBnode \
    --chain-id=$network \
    --from=wallet \
    --keyring-backend test \
    --commission-rate=0.05 \
    --commission-max-rate=0.20 \
    --commission-max-change-rate=0.01 \
    --min-self-delegation=1 \
    --pubkey=$(rollappd dymint show-sequencer) \
    --node=http://localhost:26657 \
    --fees 2000000000000a$token \
    --gas auto \
    --gas-adjustment 1.3 -y
```
<img width="590" alt="image" src="https://github.com/user-attachments/assets/45e8f97c-b2fe-4465-8954-e28088369b50" />

## II. Create GOV proposal
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
          "height": "1000",
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
### Import authority address
```
rollappd q auth module-account gov -o json | jq -r '.account.base_account.address' | xargs -I {} sed -i 's/<authority-address>/{}/' proposal.json
```
### Submit Proposal
👉❗change token symbol and "Rollapp Network ID"
```
rollappd tx gov submit-proposal proposal.json --from wallet --keyring-backend test --fees 2000000000000aftbx --chain-id <Rollapp Network ID>
```
### GOV Vote
👉❗change token symbol and "Rollapp Network ID"
```
rollappd tx gov vote 1 yes --from wallet --keyring-backend test --fees 2000000000000aftbx --chain-id <Rollapp Network ID>
```
### Check Proposal Status
```
rollappd query gov proposals
```
## III. Upgrade Implementation
👉❗NOTE: Once the vote passes, you'll see a log warning like:
panic: UPGRADE "drs-4" NEEDED at height: 100: {}
At this point, the rollapp will stop, and you can proceed with the update.
### 1. Stop rollapp service
```
roller rollapp services stop
```
### 2. Clone the repository and build:
👉❗NOTE: Replce "aftbx" with your rollapp coin symbol.
```
git clone -b v3.0.0-rc07-drs-4 https://github.com/dymensionxyz/rollapp-evm.git
cd rollapp-evm
export BECH32_PREFIX=aftbx && make build BECH32_PREFIX=$BECH32_PREFIX
sudo cp ./build/rollapp-evm $(which rollappd)
```
### 3. Migrate the rollapp:
```
roller rollapp migrate
```
### 4. Restart the rollapp service::
```
roller rollapp services start
```
### 5. Verify the upgrade:
```
rollappd q rollappparams params
```
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnode_Insigns</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/twitter_icon.png" width="30" height="30"/> <a href="https://x.com/vnbnode" target="_blank">VNBnode Twitter</a>
