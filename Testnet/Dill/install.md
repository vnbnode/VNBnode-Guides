# Setting Validator on Dill Testnet Andes

## Network Details & Hardware Requirements

| Network Name | Dill Testnet Andes |
| --- | --- |
| RPC URL | [https://rpc-andes.dill.xyz/](https://rpc-andes.dill.xyz/) |
| Chain ID | 558329 |
| Currency Symbol | DILL |
| Explorer URL | [https://andes.dill.xyz/](https://andes.dill.xyz/) |

| Component | Minimum Requirement |
| --- | --- |
| CPU | 2 cores |
| Memory | 2GB |
| Disk | 20GB |
| Network | 1MB/s |
| OS | Ubuntu 22.04 or macOS |

## Option 1: Automatic
```
curl -O https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Dill/light_auto.sh && chmod +x light_auto.sh && ./light_auto.sh
```
## Option 2: Manual Steps

### 1. Update and install packages for compiling
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/update-binary.sh)
```
### 2. Download Light Validator Binary
- For Linux-like systems: [Download Link](https://dill-release.s3.ap-southeast-1.amazonaws.com/linux/dill.tar.gz)
```bash
curl -O https://dill-release.s3.ap-southeast-1.amazonaws.com/linux/dill.tar.gz
```
- For macOS: [Download Link](https://dill-release.s3.ap-southeast-1.amazonaws.com/macos/dill.tar.gz)
```bash
curl -O ttps://dill-release.s3.ap-southeast-1.amazonaws.com/macos/dill.tar.gz
```
### 3. Extract the package:
```bash
tar -xzvf dill.tar.gz && cd dill
```
### 4. Generate Validator Keys
_This command will generate validator keys in the `./validator_keys` directory._
```bash
./dill_validators_gen new-mnemonic --num_validators=1 --chain=andes --folder=./
```
_Sample Output_
```bash
ubuntu@ip-xxxx:~/dill$ ./dill_validators_gen new-mnemonic --num_validators=1 --chain=andes --folder=./

***Using the tool on an offline and secure device is highly recommended to keep your mnemonic safe.***

Please choose your language ['1. العربية', '2. ελληνικά', '3. English', '4. Français', '5. Bahasa melayu', '6. Italiano', '7. 日本語', '8. 한국어', '9. Português do Brasil', '10. român', '11. Türkçe', '12. 简体中文']:  [English]: 3
Please choose the language of the mnemonic word list ['1. 简体中文', '2. 繁體中文', '3. čeština', '4. English', '5. Italiano', '6. 한국어', '7. Português', '8. Español']:  [english]: 4
Create a password that secures your validator keystore(s). You will need to re-enter this to decrypt them when you setup your Dill validators.:
Repeat your keystore password for confirmation:
The amount of DILL token to be deposited(2500 by default). [2500]:
This is your mnemonic (seed phrase). Write it down and store it safely. It is the ONLY way to retrieve your deposit.


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
./dill-node accounts import --andes --wallet-dir ./keystore --keys-dir validator_keys/ --accept-terms-of-use
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
