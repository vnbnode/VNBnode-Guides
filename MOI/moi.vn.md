# MOI (Guardian Node)

## Recommended Hardware Requirements

|   SPEC      |       Recommend           |
| :---------: | :-----------------------: |
|   **CPU**   | 4 Cores (ARM64 or x86-64) |
|   **RAM**   |        16 GB (DDR4)       |
|   **SSD**   |           512 GB          |
| **NETWORK** |          500 Mbps         |

## Create Account

### Step 1: Create MOI ID account from IOMe
*   Visit [**IOMe Login Page**](https://iome.ai/login/), to create an account.

    ![Login with IOMe](https://docs.moi.technology/assets/images/iome-login-b3874e62852d1a3f48a47fbb5feb9ff6.png)
*   Fill `username` and `password`. You will then be redirected to the section `Secret recovery phrase`.

    ![Secret Recovery Generation](https://docs.moi.technology/assets/images/secret-recovery-89743716e6600f1f7d3fdc34a7b1ea65.png)
* Select `Create secret recovery phrase for me`, to create a secret phrase.\
  ![Secret Recovery Backup](https://docs.moi.technology/assets/images/recovery-backup-abbb0c28b9b1c5e9ae05e9259e17f756.png)
* Once you've created your secret phrase, save it and select it `I've copied` to complete.

### Step 2: KYC account MOI ID
*   Sign in to your account `IOMe Account` and proceed `KYC` according to the photo below.

    ![KYC Prompt](https://docs.moi.technology/assets/images/kyc-prompt-8d1e96b8804f791bb15818d44301dc1c.png)
* After completing the process `KYC`, Verification may take some time. After verification, you can use this newly activated account to log in and use [MOI Voyage](https://voyage.moi.technology/).

### Step 3: Create Krama ID on MOI Voyage
* Visit [MOI Voyage](https://voyage.moi.technology/)
*   Log in with your account `IOMe`.

    ![Login to MOI Voyage](https://docs.moi.technology/assets/images/voyage-login-377cf38b6787fe0f073643916f95121a.gif)
*   Select `Guardians`.

    ![Guardians Page](https://docs.moi.technology/assets/images/voyage-guardians-nav-60c468c00e96344d0ed95ebac7e5a17c.png)
*   Select `Become a Guardian`.

    ![Become a Guardian](https://docs.moi.technology/assets/images/become-guardian-967292760efe12da6192719e6d026f00.gif)![Waitlist Guardians](https://docs.moi.technology/assets/images/waitlist-guardian-1d0e291d54f2d86b5f251d01fa2496aa.png)![Approved Guardian](https://docs.moi.technology/assets/images/approved-guardian-f8552b6581b5ff581cce49c9db50e097.png)
* Visit [Discord](https://discord.gg/x4SnJwHk7A) to ask for MOD Approved Krama ID.
*   Download `Keystore`.
  
    ![Download Keystore](https://docs.moi.technology/assets/images/download-keystore-9e17e6ca9121b7a76d6bf3d363eb75ad.gif)

## Option 1: Automatic
``` 
cd $HOME && mkdir moi && cd moi
```
- Download keystore.json --> $HOME/moi/keystore.json
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/MOI/moi-auto.sh)
```
## Option 2: Manual
### Install Docker

```
sudo apt update && sudo apt upgrade -y
sudo apt-get update
sudo apt-get install \
ca-certificates \
curl \
gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Open Port

<table><thead><tr><th width="130">Transport</th><th width="76" align="center">Port</th><th width="179">Reachability</th><th>Purpose</th></tr></thead><tbody><tr><td>TCP/UDP</td><td align="center">6000</td><td>Inbound/Outbound</td><td>Protocol P2P Interface</td></tr><tr><td>TCP</td><td align="center">1600</td><td>Inbound</td><td>JSON RPC Interface</td></tr></tbody></table>

### Register the Guardian Node <a href="#register-the-guardian-node" id="register-the-guardian-node"></a>
#### 1\. CPU from 2015 or later
```
sudo docker run --network host --rm -it -w /data -v $(pwd):/data sarvalabs/moipod:latest register --data-dir {DIRPATH} --mnemonic-keystore-path {KEYSTORE_PATH} --mnemonic-keystore-password {MNEMONIC_KEYSTORE_PASSWORD} --watchdog-url https://babylon-watchdog.moi.technology/add --node-password {NODE_PWD} --network-rpc-url https://voyage-rpc.moi.technology/babylon --wallet-address {ADDRESS} --node-index {NODE_IDX} --local-rpc-url http://{IP_or_Domain}:1600
```
#### 2\. CPU from 2015 or earlier
```
sudo docker run --network host --rm -it -w /data -v $(pwd):/data sarvalabs/moipod:v0.5.0-port register --data-dir {DIRPATH} --mnemonic-keystore-path {KEYSTORE_PATH} --mnemonic-keystore-password {MNEMONIC_KEYSTORE_PASSWORD} --watchdog-url https://babylon-watchdog.moi.technology/add --node-password {NODE_PWD} --network-rpc-url https://voyage-rpc.moi.technology/babylon --wallet-address {ADDRESS} --node-index {NODE_IDX} --local-rpc-url http://{IP_or_Domain}:1600
```
`{DIRPATH}`: the directory path you create to store the node, for example `moi`

`{KEYSTORE_PATH}`: The keystore file path that you downloaded when creating Krama ID, for example if you put the keystore in the new folder, the path will be `moi/keystore.json`

`{MNEMONIC_KEYSTORE_PASSWORD}`: password when you fill in to download the keystore.json file

`{NODE_PWD}`: password when you fill in to download the keystore.json file

`{ADDRESS}`: Get your wallet address here [MOI Voyage](https://voyage.moi.technology/)

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/455c4157-0eba-48a9-963b-509a91756acd)

`{NODE_IDX}`: If you want to launch Krama ID, enter that number

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/c25e9a5a-2087-4487-a710-9cab7890359a)

`{IP_or_Domain}`: This is the WAN IP address to connect to the outside, can be replaced with the ddns address. Encourage use of the service [NoIP](https://www.noip.com/).

### Start the Guardian Node <a href="#start-the-guardian-node" id="start-the-guardian-node"></a>
#### 1\. CPU from 2015 or later
```
sudo docker run --network host -it -d -w /data -v $(pwd):/data sarvalabs/moipod:latest server --babylon --data-dir {DIRPATH} --log-level DEBUG --node-password {NODE_PWD}
```
#### 2\. CPU from 2015 or earlier
```
sudo docker run --network host -it -d -w /data -v $(pwd):/data sarvalabs/moipod:v0.5.0-port server --babylon --data-dir {DIRPATH} --log-level DEBUG --node-password {NODE_PWD}
```
`{DIRPATH}`: the directory path you create to store the node, for example `moi`

`{NODE_PWD}`: password when you fill in to download the keystore.json file

## Check Status Node

* If Status displays the status: `Up xx minutes` is the node that has run successfully.
* If Status displays the status: `Exited` ERROR.

<table><thead><tr><th width="112">Container ID</th><th width="80">Image</th><th width="121">Command</th><th width="93">Created</th><th width="83">Status</th><th width="81">Ports</th><th>Names</th></tr></thead><tbody><tr><td>f00f11223344</td><td>my-image</td><td>"/bin/bash"</td><td>10 minutes ago</td><td>Up 10 minutes</td><td></td><td>my-container</td></tr></tbody></table>

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
