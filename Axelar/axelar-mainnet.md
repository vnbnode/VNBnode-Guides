# AXELAR MAINNET

## Hardware requirements

|   Hardware  |        Recommendation        |
| :---------: | :-----------------------: |
|   **CPU**   |          10 Cores (Intel / AMD)        |
|   **RAM**   |          24 GB            |
|   **SSD**   |          800GB - 1TB (VNBnode's experience)          | 


## Auto Installation
```
curl -o auto-run.sh https://raw.githubusercontent.com/Adamtruong6868/binaries/main/Projects/axelar/auto-run.sh && bash auto-run.sh
```
## Check logs
```
sudo journalctl -u axelard -f --no-hostname -o cat
```
## Create Wallet
```
axelard keys add wallet
```
## Recover Wallet
```
axelard keys add wallet --recover
```

## Query wallet balance
```
axelard q bank balances $(axelard keys show wallet -a)
```
### Create new validator
```
axelard tx staking create-validator \
--amount 1000000uaxl \
--pubkey $(axelard tendermint show-validator) \
--moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id axelar-dojo-1 \
--commission-rate 0.05 \
--commission-max-rate 0.20 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.007uaxl \
-y
```

### Edit validator
```
axelard tx staking edit-validator \
--new-moniker "YOUR_MONIKER_NAME" \
--identity "YOUR_KEYBASE_ID" \
--details "YOUR_DETAILS" \
--website "YOUR_WEBSITE_URL" \
--chain-id axelar-dojo-1 \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.007uaxl \
-y
```
