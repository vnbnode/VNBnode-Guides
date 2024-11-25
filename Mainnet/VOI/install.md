# <p align="center"> VOI Network </p>
<p align="center">
  <img height="100" height="auto" src="https://github.com/vnbnode/binaries/blob/main/Projects/VOI/voi.jpg?raw=true">
</p>

### Recommended Hardware Requirements

|   SPEC      |        Recommend          |
| :---------: | :-----------------------: |
|   **CPU**   | 4 Cores 8 threads (ARM64 or x86-64)                                   |
|   **RAM**   |        16 GB (DDR4)       |
|   **SSD**   |    100 GB SSD or NVME     |
| **NETWORK** |        100 Mbps           |

### STEP 1: Install
```
export VOINETWORK_IMPORT_ACCOUNT=1
/bin/bash -c "$(curl -fsSL https://get.voi.network/swarm)"
```
<img width="640" alt="image" src="https://github.com/user-attachments/assets/7c9ca681-e8c3-4f3c-9390-9c36afc9e8ee">

### STEP 2: Import your VOI wallet seed phrase.

<img width="708" alt="image" src="https://github.com/user-attachments/assets/89526d3d-0137-4852-91b5-7bb56091e5d2">

# Useful commands
### Creating a Node Wallet
```
~/voi/bin/create-wallet <wallet_name>
```
### Creating a account
```
~/voi/bin/create-account
```
### Retrieve the mnemonic of an existing account
```
~/voi/bin/get-account-mnemonic 
```
### Import an Account
```
~/voi/bin/import-account
```
### Check list of account
```
~/voi/bin/goal account list
```
### Checking Participation Status
```
~/voi/bin/get-participation-status <account_address>
```
### Going Online
```
~/voi/bin/go-online <account_address>
```
### Going Offline
```
~/voi/bin/go-offline <account_address>
```
### Getting Node Health
```
~/voi/bin/get-node-status
```
### Set Telemetry Name and GUID
```
~/voi/bin/set-telemetry-name
```
```
~/voi/bin/set-telemetry-name <telemetry_name> <telemetry_guid>
```
### Get Telemetry Status
```
~/voi/bin/get-telemetry-status
```
## Remove your node
### Leave the Swarm
```
docker swarm leave --force
```
### Remove the ~/voi directory
```
rm -rf ~/voi/
```
### Remove the /var/lib/voi directory
```
rm -rf /var/lib/voi
```
## Renew keys
```
getaddress() {
  if [ "$addr" == "" ]; then echo -ne "\nNote: Completing this will remember your address until you log out. "; else echo -ne "\nNote: Using previously entered address. "; fi; echo -e "To forget the address, press Ctrl+C and enter the command:\n\tunset addr\n";
  count=0; while ! (echo "$addr" | grep -E "^[A-Z2-7]{58}$" > /dev/null); do
    if [ $count -gt 0 ]; then echo "Invalid address, please try again."; fi
    echo -ne "\nEnter your voi address: "; read addr;
    addr=$(echo "$addr" | sed 's/ *$//g'); count=$((count+1));
  done; echo "Using address: $addr"
}
getaddress &&\
echo -ne "\nEnter duration in rounds [press ENTER to accept default)]: " && read duration &&\
start=$(goal node status | grep "Last committed block:" | cut -d\  -f4) &&\
duration=${duration:-2000000} &&\
end=$((start + duration)) &&\
dilution=$(echo "sqrt($end - $start)" | bc) &&\
goal account renewpartkey -a $addr --roundLastValid $end --keyDilution $dilution
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnode Inside</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
