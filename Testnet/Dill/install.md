# Setting Validator on Dill Testnet Alps

## Network Details & Hardware Requirements

| Network Name | Dill Testnet Alps |
| --- | --- |
| RPC URL | [https://rpc-alps.dill.xyz](https://rpc-alps.dill.xyz) |
| Chain ID | 102125 |
| Currency Symbol | DILL |
| Explorer URL | [https://alps.dill.xyz/](https://alps.dill.xyz/) |

| Node type	| CPU	| Memory	| Disk	| Bandwidth	| OS type |
| --- | --- |--- |--- |--- |--- |
| Light validator	| 2 cores	| 2G	| 20GB	| 8Mb/s	| Ubuntu LTS 20.04+/MacOS |
| Full validator	| 4 cores	| 8G	| 256GB	| 64Mb/s	| Ubuntu LTS 20.04+/MacOS |

## Setting up your dill node
```bash
curl -sO https://raw.githubusercontent.com/DillLabs/launch-dill-node/main/dill.sh  && chmod +x dill.sh && ./dill.sh

```
### 1. There are two options:
**1. Launch a new dill node:** Start a new Dill node. Choose this option if you want to create and run a new node from scratch.

**2. Add a validator to existing node:** Add a validator to an existing node. Choose this option if you want to add a new validator to an existing node.

- Fill 1 or 2 and press any key to continue...

![image](https://github.com/user-attachments/assets/a2b9b444-617c-4e2e-bea1-6176b2aa79d1)
### 2. Validator Keys are generated from a mnemonic:

**1. From a new mnemonic:** Choose this option if you want to generate a new mnemonic.

**2. Use existing mnemonic:** Choose this option if you want to use a mnemonic that you already have.

_Option 1: The mnemonic will be automatically saved to /root/dill/validator_keys/.... Please back up the validator_keys folder to your local machine after you have successfully run the node._

_Option 2: You will need to back up your existing mnemonic yourself._
- Fill 1 or 2 and press any key to continue...

![image](https://github.com/user-attachments/assets/9cfdde73-988c-43f4-a08b-797dc3484b3a)
### 3. Please choose an option for deposit token amount [1, 3600, 2, 36000]:

_Option 1: 3600 for light node_
_Option 2: 36000 for full node_
- Fill 1 or 2 and press any key to continue...

![image](https://github.com/user-attachments/assets/3776cd41-26e6-43e7-9e2d-a7ffd49027e7)
### 4. Please enter your withdrawal address:
_You can use any wallet as long as you have the mnemonic for it. Suggestion: you can use a staking wallet._

- Fill evm wallet & click enter.

_If you have completed all the steps correctly, you will see an output like this:_

![image](https://github.com/user-attachments/assets/00e3ace0-d2e3-4adf-99c3-8d79c4ec7169)

### 5. Verify Node is Running
_Run the following command to check if the node is up and running:_
```bash
tail -f $HOME/dill/light_node/logs/dill.log
```
```bash
curl -s localhost:3500/eth/v1/beacon/headers | jq
```
```bash
ps -ef | grep dill
```
```bash
./health_check.sh -v
```
### 6. Staking

1. Visit [Dill Staking](https://staking.dill.xyz/)
2. Upload `deposit_data-*.json` file.
Use [Termius](https://termius.com/download/windows), scp... to download the **validator_keys** folder to your local machine." or:
```bash
cat ./validator_keys/deposit_data-xxxx.json
```
_Copy to your local machine for uploading._

### Shutdown & remove node
```bash
pkill dill-node
```
```bash
cd $Home
rm -rf dill
```
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
