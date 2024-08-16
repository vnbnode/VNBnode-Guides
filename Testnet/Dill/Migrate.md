## Backup file
1. Save old mnemonic 
2. Backup the folder validator_keys to your local or any other desired location.

You can use [Termius](https://termius.com/download/windows) to easily backup the folder validator_keys, or use another method if you prefer.
![image](https://github.com/user-attachments/assets/2c4262cf-fdd2-4779-b0ac-f3c08e693c5a)

## Run node on new vps
_Reminder: If you want to use the **same VPS** to run the old node again, you need to stop the node and back up the dill folder using the following command:_
```
pkill dill-node
mv dill dillbackup
```
```
curl -O https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Dill/light_auto.sh && chmod +x light_auto.sh && ./light_auto.sh
```
- When "choose an option for mnemonic source", enter 2 to choose "Use existing mnemonic", and input your mnemonic
### 1. Replace the old **validator_keys** folder.
- Delete the **validator_keys** folder inside the dill folder.
```
cd dill
rm -rf validator_keys
```
- Copy the two old folder **validator_keys** to folder dill, you can use [Termius](https://termius.com/download/windows).
### 2. Start Light Validator Node
```bash
pkill dill-node
./restart_light.sh
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
