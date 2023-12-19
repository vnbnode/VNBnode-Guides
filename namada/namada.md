# namada testnet version v0.28.1
```
curl -o auto-run.sh https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/namada/auto-run.sh && bash auto-run.sh
```
## Useful commands
### Add new key
```
namada wallet key gen --hd-path default --alias wallet
```
### Recover existing key
```
namada wallet key restore --hd-path default --alias wallet
```
### List All Wallets
```
namada keys list
```
### Query Wallet Balance
```
namada client balance --owner account
```
```
namada client balance --owner shielded-key
```
# or query a single token only
```
namada client balance --token NAM --owner account
```
```
namada client balance --token NAM --owner shielded-key
```
### Create Validator
```
namada client init-validator \
  --alias "YOUR_VALIDATOR_ALIAS" \
  --identity "KEYBASE_ID" \
  --details "YOUR DETAILS" \
  --website "YOUR WEBSITE" \
  --account-keys wallet \
  --signing-keys wallet \
  --commission-rate 0.05 \
  --max-commission-rate-change 0.01
```
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
