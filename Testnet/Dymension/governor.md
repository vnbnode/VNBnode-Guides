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
