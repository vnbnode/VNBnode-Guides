# <p align="center"> Run Node Lumoz </p>
<p align="center">
  <img height="100" height="auto" src="https://github.com/vnbnode/binaries/blob/main/Projects/Lumoz/lumoz.jpg?raw=true">
</p>

## Recommended Hardware Requirements 
![Alt text](https://github.com/vnbnode/binaries/blob/main/Project/Lumoz/lumoz5.png)
## Create wallet & Setup Node
### 1/ Install and run the program
```
wget -c https://pre-alpha-download.opside.network/testnet-auto-install-v3.tar.gz && tar -C ./ -xzf testnet-auto-install-v3.tar.gz && chmod +x -R ./testnet-auto-install-v3 && cd ./testnet-auto-install-v3 && ./install-ubuntu-1.0.sh
```
### 2/ Select Sync Mode
```
Please choose the synchronization mode you need: 
 1. Fast mode {synchronization is fast, recommended, if there is a synchronization error, you can try to switch to normal mode}
 2. Normal mode {more nodes, more stable, but slower}
Enter index[1]:
//Enter index to choose a Sync Mode, EFast mode is default
```
- Select: 1
### 3/ Select the mnemonic import type
```
Select the mnemonic import type: 
 1. Create a new mnemonic
 2. Import an existing mnemonic
Enter index[1]:
//Enter index to choose the mnemonic import type, "Create a new mnemonic" is default
```
### Create a new mnemonic
```
Please enter your mnemonic separated by spaces (" "). Note: you only need to enter the first 4 letters of each word if you'd prefer.:
```
After inputting your existing mnemonic, you will see
```
Enter the index (key number) you wish to start generating more keys from. For example, if you've generated 4 keys in the past, you'd enter 4 here. [0]:
```
If you ever generated keys from the mnemonic, assuming 5 validator keys，their indexs are '0','1','2','3','4', you can choose the exsisting validator key(such as index 1) if you want to migrate your validator. Or that you can create a new validator key by inputing the index '5', you will have a new validator key which is generated from the mnemonic
### 4/ Upload deposit data
You don't need deposit again if you use an exsiting validator key you have deposited to. 
- [BECOME A VALIDATOR HERE](https://lumoz.org/validator)

![Alt text](https://github.com/vnbnode/binaries/blob/main/Project/Lumoz/lumoz.png)
![Alt text](https://github.com/vnbnode/binaries/blob/main/Project/Lumoz/lumoz1.png)
![Alt text](https://github.com/vnbnode/binaries/blob/main/Project/Lumoz/lumoz3.png)
![Alt text](https://github.com/vnbnode/binaries/blob/main/Project/Lumoz/lumoz6.png)
- Upload the deposit data file you just generated. The deposit_data-[timestamp].json is located in your `testnet-auto-install-v3/validator_keys directory`

![Alt text](https://github.com/vnbnode/binaries/blob/main/Project/Lumoz/lumoz7.png)

### 5/ Start or Restart Lumoz Node
```
# Start BeaconChain
testnet-auto-install-v3/opside-chain/start-beaconChain.sh

# Start Geth
testnet-auto-install-v3/opside-chain/start-geth.sh

# Start Validator
testnet-auto-install-v3/opside-chain/start-validator.sh
```
### 6/ Check logs node
```
# show the execution client logs
testnet-auto-install-v3/opside-chain/show-geth-log.sh

# show the consensus client logs
testnet-auto-install-v3/opside-chain/show-beaconChain-log.sh

# show the validator logs
testnet-auto-install-v3/opside-chain/show-validator-log.sh
```
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>