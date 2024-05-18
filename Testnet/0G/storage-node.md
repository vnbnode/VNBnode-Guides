## Storage Node

## Hardware requirements
```py
|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        64 GB             |
| **Storage** |        1 TB Nvme         |
| **NETWORK** |        1 Gbps            |
|   **OS**    |        Ubuntu 22.04      |
```

### Update and install packages for compiling
```bash
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/update-binary.sh)
```

### Build binary
```bash
cd $HOME
git clone -b v0.2.0 https://github.com/0glabs/0g-storage-node.git
cd 0g-storage-node
git checkout tags/v0.2.0
git submodule update --init
cargo build --release
sudo mv $HOME/0g-storage-node/target/release/zgs_node /usr/local/bin
```

### Set up variables
```bash
echo 'export ZGS_CONFIG_FILE="$HOME/0g-storage-node/run/config.toml"' >> ~/.bash_profile
echo 'export ZGS_LOG_DIR="$HOME/0g-storage-node/run/log"' >> ~/.bash_profile
echo 'export ZGS_LOG_CONFIG_FILE="$HOME/0g-storage-node/run/log_config"' >> ~/.bash_profile
source ~/.bash_profile
```

### Get wallet private key
`From MetaMask:` If you already have a wallet configured in MetaMask, you can use the private key associated with the MetaMask account.

`Generate a New Wallet Using CLI:` If you prefer to create a new wallet, you can use the `0gchaind` command-line interface. Follow the steps provided in this guide to generate a new wallet: [Create Wallet](https://github.com/trusted-point/0g-tools?tab=readme-ov-file#14-create-a-wallet-for-your-validator).

After creating the wallet, you can use the following command to export the private key:

```bash
0gchaind keys unsafe-export-eth-key wallet
```

Store your private key in variable:
```bash
read -sp "Enter your private key: " PRIVATE_KEY && echo
```

### Update node configuration
```bash
if grep -q '# miner_id' $ZGS_CONFIG_FILE; then
    MINER_ID=$(openssl rand -hex 32)
    sed -i "/# miner_id/c\miner_id = \"$MINER_ID\"" $ZGS_CONFIG_FILE
fi

if grep -q '# miner_key' $ZGS_CONFIG_FILE; then
    sed -i "/# miner_key/c\miner_key = \"$PRIVATE_KEY\"" $ZGS_CONFIG_FILE
fi

sed -i "s|^log_config_file =.*$|log_config_file = \"$ZGS_LOG_CONFIG_FILE\"|" $ZGS_CONFIG_FILE

if ! grep -q "^log_directory =" "$ZGS_CONFIG_FILE"; then
    echo "log_directory = \"$ZGS_LOG_DIR\"" >> "$ZGS_CONFIG_FILE"
fi
```

### Create a service file
```bash
sudo tee /etc/systemd/system/zgs.service > /dev/null <<EOF
[Unit]
Description=0G Storage Node
After=network.target

[Service]
User=xxxx
Type=simple
WorkingDirectory=/$HOME/0g-storage-node/run
ExecStart=/$HOME./target/release/zgs_node --config $ZGS_CONFIG_FILE
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

### Start the node
```bash
sudo systemctl daemon-reload && \
sudo systemctl enable zgs && \
sudo systemctl restart zgs && \
sudo systemctl status zgs
```

### Backup
```bash
grep 'miner_id' $ZGS_CONFIG_FILE
grep 'miner_key' $ZGS_CONFIG_FILE
```

### Delete the node from the server
```bash
sudo systemctl stop zgs
sudo systemctl disable zgs
sudo rm /etc/systemd/system/zgs.service
rm -rf $HOME/0g-storage-node
```

### View the latest log file
```bash
tail -f 0g-storage-node/run/log/*
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
