# LAVA Validator setup
## 1.Hardware required
![image](https://github.com/Adamtruong6868/LAVA/assets/91002010/26a6b8b2-10be-4991-b84d-a2edb4e4619c)
# Setup Auto
```php
curl -o auto-run.sh https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/LAVA/auto-run.sh && bash auto-run.sh
```
### Verify cosmovisor setup
* Check the status of the service
```php
sudo systemctl status cosmovisor
```
* To view the service logs - to escape, hit CTRL+C
```php
sudo journalctl -u cosmovisor -f
```
### Verify node status
```php
# Check if the node is currently in the process of catching up
$HOME/.lava/cosmovisor/current/bin/lavad status | jq .SyncInfo.catching_up
```
***Ensure your node synched & Wait until you see the output: "false"***
### 9. Create wallet
```php
current_lavad_binary="$HOME/.lava/cosmovisor/current/bin/lavad"
ACCOUNT_NAME=$MONIKER
$current_lavad_binary keys add $ACCOUNT_NAME
```
***Ensure you write down the mnemonic as you can not recover the wallet without it***
### List the key & Wallet
```php
$current_lavad_binary keys list
```
### obtain your validator pubkey
```php
$current_lavad_binary tendermint show-validator
```
### Check balance of your account
```php
YOUR_ADDRESS=$($current_lavad_binary keys show -a $ACCOUNT_NAME)
$current_lavad_binary query \
    bank balances \
    $YOUR_ADDRESS \
    --denom ulava
```
### 10. Stake as validator
```php
$current_lavad_binary tx staking create-validator \
    --amount="10000ulava" \
    --pubkey=$($current_lavad_binary tendermint show-validator --home "$HOME/.lava/") \
    --moniker="Your-name_VNBnode" \
    --chain-id=lava-testnet-2 \
    --commission-rate="0.10" \
    --commission-max-rate="0.20" \
    --commission-max-change-rate="0.01" \
    --min-self-delegation="10000" \
    --gas="auto" \
    --gas-adjustment "1.5" \
    --gas-prices="0.05ulava" \
    --home="$HOME/.lava/" \
    --from=$ACCOUNT_NAME
```
### Useful commands for manage your node
```php
#Account info
lavap query pairing account-info $(lavad keys show wallet -a)
```
```php
# Test provider 
lavap test rpcprovider --from your-wallet-name
```
```php
# Unjail validator
lavad tx slashing unjail --from wallet --chain-id lava-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001ulava -y
```
```php
# Jail reason
lavad query slashing signing-info $(lavad tendermint show-validator)
```
```php
# Delegate to yourself
lavad tx staking delegate $(lavad keys show wallet --bech val -a) 1000000ulava --from wallet --chain-id lava-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001ulava -y
```

```php
# Withdraw commission and rewards from your validator
lavad tx distribution withdraw-rewards $(lavad keys show wallet --bech val -a) --commission --from wallet --chain-id lava-testnet-2 --gas-adjustment 1.4 --gas auto --gas-prices 0.0001ulava -y
```
```php
# Unfreeze
lavap tx pairing unfreeze LAV1,ETH1 --from your-wallet-name --gas-prices 0.1ulava --gas-adjustment 1.5 --gas auto -y
```
### Upgradable Lava binaries
```php
sudo systemctl stop cosmovisor
sudo systemctl stop lavap
```
```php
cd $HOME
rm -rf lava
git clone https://github.com/lavanet/lava.git
cd lava
```
```php
# choose the correct version
git checkout v0.32.x
```
```php
export LAVA_BINARY=lavad
make install
```
```php
# choose the correct version
mkdir -p $HOME/.lava/cosmovisor/upgrades/v0.32.x/bin
mv build/lavad $HOME/.lava/cosmovisor/upgrades/v0.32.x/bin/
rm -rf build
```
```php
# check version
lavad version && lavap version
```
```php
sudo systemctl restart cosmovisor
sudo systemctl status cosmovisor
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
