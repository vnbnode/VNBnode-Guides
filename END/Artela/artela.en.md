# Artela
<img src="https://github.com/vnbnode/VNBnode-Guides/assets/76662222/7724db8a-a28e-452b-8431-ed5a748ba9bd" width="30"/> <a href="https://discord.gg/artela" target="_blank">Discord</a>

<img src="https://github.com/vnbnode/VNBnode-Guides/assets/76662222/4b23c7fc-4ffb-4126-a0a8-92caa02acb51" width="30"/> <a href="https://atkty6pceir.typeform.com/to/o4359Rsd" target="_blank">Fill Form</a>
## Hardware requirements

|   Thông số  |        Khuyến nghị        |
| :---------: | :-----------------------: |
|   **CPU**   |          8 Cores (Intel / AMD)        |
|   **RAM**   |          16 GB            |
|   **SSD**   |          1 TB  (Project's recommend)           | 
| **NETWORK** |          200 Mbps         |

## Auto Installation
```
curl -o auto-run.sh https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Artela/auto-run.sh && bash auto-run.sh
```

## Check logs
```
sudo journalctl -fu artelad -o cat
```
## Create Wallet
```
artelad keys add wallet
```
### Please enter 24 characters into C98 wallet to get the wallet address from the ETH chain
### Use that ETH wallet address to go to the project's Discord to faucet
## Create Validator
```
artelad tx staking create-validator \
--amount="1000000art" \
--pubkey=$(artelad tendermint show-validator) \
--moniker="Name-VNBnode" \
--commission-rate="0.10" \
--commission-max-rate="0.20" \
--commission-max-change-rate="0.01" \
--min-self-delegation="1" \
--gas="200000" \
--chain-id=artela_11822-1 \
--from=wallet
```
## Edit Validator
```
artelad tx staking edit-validator \
--new-moniker "NewName-VNBnode" \
--identity "06F5F34BD54AA6C7" \
--website "https://vnbnode.com" \
--commission-rate="0.01" \
--chain-id=artela_11822-1 \
--from=wallet
```
## [Visit Explorer](https://test.explorer.ist/artela/staking)
## Upgrade
```
sudo systemctl stop artela
```
```
cd $HOME
rm -rf artela
git clone https://github.com/artela-network/artela
cd artela
git checkout v0.4.7-rc6
make install
```
```
sed -E 's/^pool-size[[:space:]]*=[[:space:]]*[0-9]+$/apply-pool-size = 10\nquery-pool-size = 30/' ~/.artelad/config/app.toml > ~/.artelad/config/temp.app.toml && mv ~/.artelad/config/temp.app.toml ~/.artelad/config/app.toml
sudo systemctl restart artelad && sudo journalctl -u artelad -f
```
## Remove Node
```
cd $HOME
sudo systemctl stop artela
sudo systemctl disable artela
sudo rm /etc/systemd/system/artela.service
sudo systemctl daemon-reload
sudo rm -f $(which artela)
sudo rm -rf $HOME/.artelad
sudo rm -rf $HOME/artela
sudo rm -rf $HOME/go
```
## Command
Sync info
```
artelad status 2>&1 | jq .SyncInfo
```
Validator info
```
artelad status 2>&1 | jq .ValidatorInfo
```
Node info
```
artelad status 2>&1 | jq .NodeInfo
```
Show node id
```
artelad tendermint show-node-id
```
List of wallets
```
artelad keys list
```
Recover wallet
```
artelad keys add wallet --recover
```
Delete wallet
```
artelad keys delete wallet
```
Get wallet balance
```
artelad query bank balances $ARTELA_WALLET_ADDRESS
```
Transfer funds
```
artelad tx bank send $ARTELA_WALLET_ADDRESS <TO_ARTELA_WALLET_ADDRESS> 10000000uart
```
Voting
```
artelad tx gov vote 1 yes --from wallet --chain-id=$ARTELA_CHAIN_ID
```
Staking, Delegation and Rewards
Delegate stake
```
artelad tx staking delegate $ARTELA_VALOPER_ADDRESS 10000000uart --from=wallet --chain-id=$ARTELA_CHAIN_ID --gas=auto
```
Redelegate stake from validator to another validator
```
artelad tx staking redelegate <srcValidatorAddress> <destValidatorAddress> 10000000uart --from=wallet --chain-id=$ARTELA_CHAIN_ID --gas=auto
```
Withdraw all rewards
```
artelad tx distribution withdraw-all-rewards --from=wallet --chain-id=$ARTELA_CHAIN_ID --gas=auto
```
Withdraw rewards with commision
```
artelad tx distribution withdraw-rewards $ARTELA_VALOPER_ADDRESS --from=wallet --commission --chain-id=$ARTELA_CHAIN_ID
```
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
