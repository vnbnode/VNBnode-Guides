# Run Node Engram

## I\. Run Node
### 1\. Update
```
sudo apt update && sudo apt upgrade -y
```

### 2\. Package
```
sudo apt install curl tar wget clang pkg-config protobuf-compiler libssl-dev jq build-essential protobuf-compiler bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

### 3\. Install Docker
```
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

### 4\. SETUP
```
git clone --recursive https://github.com/engram-network/tokio-docker.git && cd tokio-docker && chmod +x ./scripts/*.sh && ./scripts/install-docker.sh && ./scripts/install-asdf.sh && mkdir -p execution consensus
```

### 5\. Create a mnemonic phrase to prepare the deposit data
```
$ eth2-val-tools mnemonic 
```
- Keep your mnemonic
### 6\. Obtain the following parameters in validator-deposit-data.sh
```
nano ./scripts/validator-deposit-data.sh
```
```
amount: The amount of tGRAM to deposit (e.g., 32000000000)
smin: source min value (e.g., 0)
smax: source max value (e.g., 1)
withdrawals-mnemonic: your mnemonic phrase from generate eth2-val-tools.
validators-mnemonic: your mnemonic phrase from generate eth2-val-tools.
from: address that was already funded from the faucet.
privatekey: your privatekey address that has funds from the faucet.
```
- Run the following command to generate final the deposit data.
```
bash ./scripts/validator-deposit-data.sh

```
### 7\. Generate Public Keys
```
./scripts/validator-build.sh
```
```
$ ***Using the tool on an offline and secure device is highly recommended to keep your mnemonic safe.***

Please choose your language ['1. العربية', '2. ελληνικά', '3. English', '4. Français', '5. Bahasa melayu', '6. Italiano', '7. 日本語', '8. 한국어', '9. Português do Brasil', '10. român', '11. Türkçe', '12. 简体中文']:  [English]:

Choose English or Press Enter.

$ Please repeat the index to confirm: 

Type "0" since it is the minimum height the data deposit will be created at.

$ Please enter your mnemonic separated by spaces (" "). Note: you only need to enter the first 4 letters of each word if you'd prefer.:

Add your already created mnemonic phrase to be extracted into a public key.

$ Please choose the (mainnet or testnet) network/chain name ['mainnet-soon', 'devnet-1', 'devnet-3', 'devnet-4', 'devnet-5', 'testnet']:  [mainnet-soon]:

Choose testnet and Enter

$ Create a password that secures your validator keystore(s). You will need to re-enter this to decrypt them when you setup your Ethereum validators.:

Create your password with a minimum word of 8 letters/numbers and create a file with the name "password.txt" and save it in the "custom_config_data" folder
after completing creating a password you will be referred like this: 

███████╗███╗░░██╗░██████╗░██████╗░░█████╗░███╗░░░███╗  ████████╗░█████╗░██╗░░██╗██╗░█████╗░
██╔════╝████╗░██║██╔════╝░██╔══██╗██╔══██╗████╗░████║  ╚══██╔══╝██╔══██╗██║░██╔╝██║██╔══██╗
█████╗░░██╔██╗██║██║░░██╗░██████╔╝███████║██╔████╔██║  ░░░██║░░░██║░░██║█████═╝░██║██║░░██║
██╔══╝░░██║╚████║██║░░╚██╗██╔══██╗██╔══██║██║╚██╔╝██║  ░░░██║░░░██║░░██║██╔═██╗░██║██║░░██║
███████╗██║░╚███║╚██████╔╝██║░░██║██║░░██║██║░╚═╝░██║  ░░░██║░░░╚█████╔╝██║░╚██╗██║╚█████╔╝
╚══════╝╚═╝░░╚══╝░╚═════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░░░░╚═╝  ░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝╚═╝░╚════╝░      
                                                                  
Creating your keys.
Creating your keys:               [####################################]  32/32          
Creating your keystores:          [####################################]  32/32          
Creating your depositdata:        [####################################]  32/32          
Verifying your keystores:         [####################################]  32/32          
```
### 5\. Configure Docker Compose `docker-compose.yml`
```
nano docker-compose.yml
```
```
identity=avenbreaks << Replace with your discord username (e.g: avenbreaks. don't add your hastag discord user)
enr-address=0.0.0.0 << Replace with your public IPAddress
graffiti=engram-labs << Replace with your unique name
```

### 6\. Run
```
docker compose up -d
```
You will see the following:
```
$ docker compose up -d
[+] Running 4/4
 ⠿ Network tokio_default_default                           Created
 ⠿ Container striatum_init                                 Exited
 ⠿ Container striatum_el                                   Started
 ⠿ Container lighthouse_init                               Exited
 ⠿ Container lighthouse_cl                                 Started
 ⠿ Container lighthouse_vc                                 Started
```
### 7\. Check logs
```
docker logs striatum_el -f
```
- see on striatum_el:
```
INFO [09-26|19:28:45.046] Forkchoice requested sync to new head    number=30729 hash=a38be3..648659 finalized=30652
INFO [09-26|19:28:57.045] Forkchoice requested sync to new head    number=30730 hash=eb3642..45f557 finalized=30652
INFO [09-26|19:29:09.046] Forkchoice requested sync to new head    number=30731 hash=b9fd32..3748bd finalized=30652
INFO [09-26|19:29:21.046] Forkchoice requested sync to new head    number=30732 hash=51ff7b..803756 finalized=30652
INFO [09-26|19:29:33.046] Forkchoice requested sync to new head    number=30733 hash=f80ac7..19e5f7 finalized=30652
```
```
docker logs lighthouse_cl -f
```
- see on lighthouse_cl:
```
INFO Subscribed to topics
INFO Sync state updated                      new_state: Evaluating known peers, old_state: Syncing Finalized Chain, service: sync
INFO Sync state updated                      new_state: Syncing Head Chain, old_state: Evaluating known peers, service: sync
INFO Sync state updated                      new_state: Synced, old_state: Syncing Head Chain, service: sync
INFO Subscribed to topics                    topics: ["/eth2/9c4e948f/bls_to_execution_change/ssz_snappy"]
INFO Successfully finalized deposit tree     finalized deposit count: 1, service: deposit_contract_rpc
```
- see on lighthouse_vc:
```
INFO Connected to beacon node(s)             synced: 1, available: 1, total: 1, service: notifier
INFO All validators active                   slot: 32836, epoch: 1026, total_validators: 32, active_validators: 32
INFO Connected to beacon node(s)             synced: 1, available: 1, total: 1,
INFO Validator exists in beacon chain        fee_recipient: 0x617b…063d,
INFO Awaiting activation                     slot: 17409, epoch: 544, validators: 32, service: notifier
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/VNBnode-Guides/blob/main/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
