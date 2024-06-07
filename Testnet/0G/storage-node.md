## Storage Node

## Hardware requirements
|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        16 GB             |
| **Storage** |        1 TB Nvme         |
| **NETWORK** |        1 Gbps            |
|   **OS**    |        Ubuntu 22.04      |

### Update and install packages for compiling
```bash
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/update-binary.sh) && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/rust-install.sh)
```

### Build binary
```bash
cd $HOME
git clone -b v0.2.0 https://github.com/0glabs/0g-storage-node.git
cd 0g-storage-node
git submodule update --init
cargo build --release
sudo cp $HOME/0g-storage-node/target/release/zgs_node /usr/local/bin
```

### Set up variables
```bash
echo 'export ZGS_CONFIG_FILE="$HOME/0g-storage-node/run/config.toml"' >> ~/.bash_profile
echo 'export ZGS_LOG_DIR="$HOME/0g-storage-node/run/log"' >> ~/.bash_profile
echo 'export ZGS_LOG_CONFIG_FILE="$HOME/0g-storage-node/run/log_config"' >> ~/.bash_profile
source ~/.bash_profile
```

### Get wallet private key
```bash
0gchaind keys unsafe-export-eth-key wallet
```

### Update node configuration
```bash
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
User=$USER
Type=simple
WorkingDirectory=/$HOME/0g-storage-node/run
ExecStart=/$HOME/0g-storage-node/target/release/zgs_node --config $ZGS_CONFIG_FILE
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
grep 'miner_key' $ZGS_CONFIG_FILE
```

### View the latest log file
```bash
tail -f 0g-storage-node/run/log/*
```

### Delete the node from the server
```bash
sudo systemctl stop zgs
sudo systemctl disable zgs
sudo rm /etc/systemd/system/zgs.service
rm -rf $HOME/0g-storage-node
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
