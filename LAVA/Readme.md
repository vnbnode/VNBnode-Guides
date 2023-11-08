# LAVA Validator setup
## 1.Hardware required
![image](https://github.com/Adamtruong6868/LAVA/assets/91002010/26a6b8b2-10be-4991-b84d-a2edb4e4619c)

## 2.Set Validator nam
```php
MONIKER="Your-name_VNBnode"
```
## 3.Update system
```php
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade
```
## 4. Install Go version 1.20.5
```php
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.20.5.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version
```
## 5. Install GCC
```php
sudo apt install build-essential
```
## 6. Install all Binaries 🛠️
```php
git clone https://github.com/lavanet/lava.git
cd lava
make install-all
```
### Check version
```php
lavad version && lavap version
```
## 7.Build all Binaries
```php
make build-all
```
## 8. Set up a local node
### Download app configurations
* Download setup configuration Download the configuration files needed for the installation
```php
# Download the installation setup configuration
git clone https://github.com/lavanet/lava-config.git
cd lava-config/testnet-2
```
```php
# Read the configuration from the file
# Note: you can take a look at the config file and verify configurations
source setup_config/setup_config.sh
```
* Set app configurations Copy lavad default config files to config Lava config folder
```php
echo "Lava config file path: $lava_config_folder"
mkdir -p $lavad_home_folder
mkdir -p $lava_config_folder
cp default_lavad_config_files/* $lava_config_folder
```
### Set the genesis file
* Set the genesis file in the configuration folder
```php
# Copy the genesis.json file to the Lava config folder
cp genesis_json/genesis.json $lava_config_folder/genesis.json
```
### Set up Cosmovisor
* Set up cosmovisor to ensure any future upgrades happen flawlessly. To install Cosmovisor:
```php
go install github.com/cosmos/cosmos-sdk/cosmovisor/cmd/cosmovisor@v1.0.0
```
```php
# Create the Cosmovisor folder and copy config files to it
mkdir -p $lavad_home_folder/cosmovisor/genesis/bin/
```
```php
# Download the genesis binary
wget -O  $lavad_home_folder/cosmovisor/genesis/bin/lavad "https://github.com/lavanet/lava/releases/download/v0.21.1.2/lavad-v0.21.1.2-linux-amd64"
chmod +x $lavad_home_folder/cosmovisor/genesis/bin/lavad
```
```php
# Set the environment variables
echo "# Setup Cosmovisor" >> ~/.profile
echo "export DAEMON_NAME=lavad" >> ~/.profile
echo "export CHAIN_ID=lava-testnet-2" >> ~/.profile
echo "export DAEMON_HOME=$HOME/.lava" >> ~/.profile
echo "export DAEMON_ALLOW_DOWNLOAD_BINARIES=true" >> ~/.profile
echo "export DAEMON_LOG_BUFFER_SIZE=512" >> ~/.profile
echo "export DAEMON_RESTART_AFTER_UPGRADE=true" >> ~/.profile
echo "export UNSAFE_SKIP_BACKUP=true" >> ~/.profile
source ~/.profile
```
### Initialize the chain
```php
$lavad_home_folder/cosmovisor/genesis/bin/lavad init \
my-node \
--chain-id lava-testnet-2 \
--home $lavad_home_folder \
--overwrite
cp genesis_json/genesis.json $lava_config_folder/genesis.json
```
### Check version
```php
cosmovisor version
```
### Create Cosmovisor unit file
```php
echo "[Unit]
Description=Cosmovisor daemon
After=network-online.target
[Service]
Environment="DAEMON_NAME=lavad"
Environment="DAEMON_HOME=${HOME}/.lava"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
Environment="DAEMON_ALLOW_DOWNLOAD_BINARIES=true"
Environment="DAEMON_LOG_BUFFER_SIZE=512"
Environment="UNSAFE_SKIP_BACKUP=true"
User=$USER
ExecStart=${HOME}/go/bin/cosmovisor start --home=$lavad_home_folder --p2p.seeds $seed_node
Restart=always
RestartSec=3
LimitNOFILE=infinity
LimitNPROC=infinity
[Install]
WantedBy=multi-user.target
" >cosmovisor.service
sudo mv cosmovisor.service /lib/systemd/system/cosmovisor.service
```
### Enable and start the Cosmovisor service
```php
# Enable the cosmovisor service so that it will start automatically when the system boots
sudo systemctl daemon-reload
sudo systemctl enable cosmovisor.service
sudo systemctl restart systemd-journald
sudo systemctl start cosmovisor
```
### Verify cosmovisor setup
* Check the status of the service
```php
sudo systemctl status cosmovisor
```
* To view the service logs - to escape, hit CTRL+C
```php
sudo journalctl -u cosmovisor -f
```
### Verify node status
```php
# Check if the node is currently in the process of catching up
$HOME/.lava/cosmovisor/current/bin/lavad status | jq .SyncInfo.catching_up
```
***Ensure your node synched & Wait until you see the output: "false"***
### 9. Create wallet
```php
current_lavad_binary="$HOME/.lava/cosmovisor/current/bin/lavad"
ACCOUNT_NAME=$MONIKER
$current_lavad_binary keys add $ACCOUNT_NAME
```
***Ensure you write down the mnemonic as you can not recover the wallet without it***
### List the key & Wallet
```php
$current_lavad_binary keys list
```
### obtain your validator pubkey
```php
$current_lavad_binary tendermint show-validator
```
### Check balance of your account
```php
YOUR_ADDRESS=$($current_lavad_binary keys show -a $ACCOUNT_NAME)
$current_lavad_binary query \
    bank balances \
    $YOUR_ADDRESS \
    --denom ulava
```
### 10. Stake as validator
```php
$current_lavad_binary tx staking create-validator \
    --amount="10000ulava" \
    --pubkey=$($current_lavad_binary tendermint show-validator --home "$HOME/.lava/") \
    --moniker="Your-name_VNBnode" \
    --chain-id=lava-testnet-2 \
    --commission-rate="0.10" \
    --commission-max-rate="0.20" \
    --commission-max-change-rate="0.01" \
    --min-self-delegation="10000" \
    --gas="auto" \
    --gas-adjustment "1.5" \
    --gas-prices="0.05ulava" \
    --home="$HOME/.lava/" \
    --from=$ACCOUNT_NAME
```
## THANK TO SUPPORT VNBnode 
