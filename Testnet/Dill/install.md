# Setting Validator on Dill Testnet Alps

## Network Details & Hardware Requirements

| Network Name | Dill Testnet Alps |
| --- | --- |
| RPC URL | [https://rpc-alps.dill.xyz](https://rpc-alps.dill.xyz) |
| Chain ID | 102125 |
| Currency Symbol | DILL |
| Explorer URL | [https://alps.dill.xyz/](https://alps.dill.xyz/) |

| Component | Minimum Requirement |
| --- | --- |
| CPU | 2 cores |
| Memory | 2GB |
| Disk | 20GB |
| Network | 1MB/s |
| OS | Ubuntu 22.04 or macOS |

| Node type	| CPU	| Memory	| Disk	| Bandwidth	| OS type |
| --- | --- |--- |--- |--- |--- |
| Light validator	| 2 cores	| 2G	| 20GB	| 8Mb/s	| Ubuntu LTS 20.04+/MacOS |
| Full validator	| 4 cores	| 8G	| 256GB	| 64Mb/s	| Ubuntu LTS 20.04+/MacOS |

## Option 1: Automatic
```bash
curl -O https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Dill/light_auto.sh && chmod +x light_auto.sh && ./light_auto.sh
```
## Option 2: Manual Steps

### 1. Update and install packages for compiling
```bash
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/update-binary.sh)
```
### 2. Download Light Validator Binary & Extract the package:
- For LINUX AMD systems: [Download Link](https://dill-release.s3.ap-southeast-1.amazonaws.com/v1.0.1/dill-v1.0.1-linux-amd64.tar.gz)
```bash
curl -O https://dill-release.s3.ap-southeast-1.amazonaws.com/v1.0.1/dill-v1.0.1-linux-amd64.tar.gz
tar -zxvf dill-v1.0.1-linux-amd64.tar.gz && cd dill
```
- For DARWIN ARM systems: [Download Link](https://dill-release.s3.ap-southeast-1.amazonaws.com/v1.0.1/dill-v1.0.1-darwin-arm64.tar.gz)
```bash
curl -O https://dill-release.s3.ap-southeast-1.amazonaws.com/v1.0.1/dill-v1.0.1-darwin-arm64.tar.gz
tar -zxvf dill-v1.0.1-darwin-arm64.tar.gz && cd dill
```
### 3. Generate Validator Keys
_This command will generate validator keys in the `./validator_keys` directory._
```bash
./dill_validators_gen new-mnemonic --num_validators=1 --chain=Alps --folder=./
```
_Sample Output_
```bash
ubuntu@ip-xxxx:~/dill$ ./dill_validators_gen new-mnemonic --num_validators=1 --chain=Alps --folder=./

Create a password that secures your validator keystore(s). You will need to re-enter this to decrypt them when you setup your Dill validators.:
The amount of DILL token to be deposited(2500 by default). [2500]:
This is your mnemonic (seed phrase). Write it down and store it safely. It is the ONLY way to retrieve your deposit.
Press any key when you have written down your mnemonic.
Please type your mnemonic (separated by spaces) to confirm you have written it down. Note: you only need to enter the first 4 letters of each word if you'd prefer.
: _"fill your mnemoic"_

Creating your keys.
Creating your keystores:	  [####################################]  1/1
Verifying your keystores:	  [####################################]  1/1
Verifying your deposits:	  [####################################]  1/1

Success!
Your keys can be found at: ./validator_keys


Press any key.
```
### 5. Import Validator Keys
_During this process, set and save your keystore password._
```bash
./dill-node accounts import --Alps --wallet-dir ./keystore --keys-dir validator_keys/ --accept-terms-of-use
```
### 6. Save Password to a File
_Replace `<your-password>` with your actual password._
```bash
echo <your-password> > walletPw.txt
```
### 7. Start Light Validator Node
```bash
./start_light.sh -p walletPw.txt
```
### 8. Verify Node is Running
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
### 9. Staking

1. Visit [Dill Staking](https://staking.dill.xyz/)
2. Upload `deposit_data-*.json` file.
Use Termius,scp... to dowload the file locally or:
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
