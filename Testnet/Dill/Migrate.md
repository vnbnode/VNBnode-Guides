## Backup file
1. Save old mnemonic 
2. Backup the folder validator_keys to your local or any other desired location.

You can use [Termius](https://termius.com/download/windows) to easily backup the folder validator_keys, or use another method if you prefer.
![image](https://github.com/user-attachments/assets/2c4262cf-fdd2-4779-b0ac-f3c08e693c5a)

## Run node on new vps
_Reminder: If you want to use the **same VPS** to run the old node again, you need to stop the node and back up the dill folder using the following command:_
```
ps -ef | grep dill-node | grep -v grep | awk '{print $2}' | xargs kill
mv dill dillbackup
```
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
### 3. Extract the package
```bash
tar -xzvf dill.tar.gz && cd dill
```
### 4. Generate Validator Keys with existing mnemonic (fill your old mnemonic)
_This command will generate validator keys with existing mnemonic in the `./validator_keys` directory._
```bash
./dill_validators_gen existing-mnemonic --num_validators=1 --chain=andes --folder=./
```
### 5. Update deposit data & old keystore
- Delete the two files, deposit data and keystore, in the folder validator_key.
- Copy the two old files, deposit data and keystore, saved during the backup step back into the folder validator_key, you can use [Termius](https://termius.com/download/windows).
### 6. Import Validator Keys
_During this process, set and save your keystore password._
```bash
./dill-node accounts import --andes --wallet-dir ./keystore --keys-dir validator_keys/ --accept-terms-of-use
```
### 7. Save Password to a File
_Replace `<your-password>` with your actual password._
```bash
echo <your-password> > walletPw.txt
```
### 8. Start Light Validator Node
```bash
./start_light.sh -p walletPw.txt
```
### 9. Verify Node is Running
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
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
