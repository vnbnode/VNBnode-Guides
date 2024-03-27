### Wallet Commands
- Create a Wallet
```
./pactus-wallet --path <PATH-To-NEW-WALLET> create
```
- Recover Wallet
```
./pactus-wallet --path <PATH-To-NEW-WALLET> recover
```
- Wallet Password
```
./pactus-wallet password
```
- Wallet Seed
```
./pactus-wallet seed
```
### Address Commands
- Creating New Address
```
./pactus-wallet address new
```
- List of Addresses
```
./pactus-wallet address all
```
- Get Public Key
```
./pactus-wallet address pub <ADDRESS>
```
- Get Private Key
```
./pactus-wallet address priv <ADDRESS>
```
- Get Address Balance
```
./pactus-wallet address balance <ADDRESS>
```
### Transaction Commands
- Sending Transfer Transaction
```
./pactus-wallet tx transfer <FROM> <TO> <AMOUNT>
```
- Sending Bond Transaction
```
./pactus-wallet tx bond <FROM> <TO> <AMOUNT>
```
- Sending Bond Transaction
```
./pactus-wallet tx bond --pub <PUBLIC_KEY> <FROM> <TO> <AMOUNT>
```
- Sending Unbond Transaction
```
./pactus-wallet tx unbond <ADDRESS>
```
- Sending Withdraw Transaction
```
./pactus-wallet tx unbond <FROM> <TO> <AMOUNT>
```
