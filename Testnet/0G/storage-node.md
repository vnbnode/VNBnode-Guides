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

### Build binary 0g-storage
```bash
cd $HOME
git clone -b v0.3.0 https://github.com/0glabs/0g-storage-node.git
cd 0g-storage-node
git submodule update --init
cargo build --release
sudo cp $HOME/0g-storage-node/target/release/zgs_node /usr/local/bin
```

### Set up variables
```bash
echo 'export BLOCKCHAIN_RPC_ENDPOINT="https://evm-rpc-0g.mflow.tech"' >> ~/.bash_profile
source ~/.bash_profile
```

### Build binary 0g-testnet
```bash
git clone -b v0.1.0 https://github.com/0glabs/0g-chain.git
git checkout v1.0.0-testnet
cd 0g-chain
make install
mkdir -p $HOME/.0gchain/cosmovisor/genesis/bin
cp $HOME/go/bin/0gchaind $HOME/.0gchain/cosmovisor/genesis/bin/
sudo ln -s $HOME/.0gchain/cosmovisor/genesis $HOME/.0gchain/cosmovisor/current -f
sudo ln -s $HOME/.0gchain/cosmovisor/current/bin/0gchaind /usr/local/bin/0gchaind -f
cd $HOME
```
### Create wallet
```
0gchaind keys add wallet --eth
```
### Get wallet private key
```bash
0gchaind keys unsafe-export-eth-key wallet
```

### Update node configuration
```bash
sed -i '
s|# network_dir = "network"|network_dir = "network"|
s|# network_enr_tcp_port = 1234|network_enr_tcp_port = 1234|
s|# network_enr_udp_port = 1234|network_enr_udp_port = 1234|
s|# network_libp2p_port = 1234|network_libp2p_port = 1234|
s|# network_discovery_port = 1234|network_discovery_port = 1234|
s|# rpc_enabled = true|rpc_enabled = true|
s|# db_dir = "db"|db_dir = "db"|
s|# log_config_file = "log_config"|log_config_file = "log_config"|
s|# log_directory = "log"|log_directory = "log"|
s|^blockchain_rpc_endpoint = \".*|blockchain_rpc_endpoint = "'"$BLOCKCHAIN_RPC_ENDPOINT"'"|
' $HOME/0g-storage-node/run/config.toml
read -sp "Enter your private key: " PRIVATE_KEY && echo
sed -i 's|^miner_key = ""|miner_key = "'"$PRIVATE_KEY"'"|' $HOME/0g-storage-node/run/config.toml
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
WorkingDirectory=$HOME/0g-storage-node/run
ExecStart=$HOME/0g-storage-node/target/release/zgs_node --config $HOME/0g-storage-node/run/config.toml
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

### Check miner_key
```bash
grep 'miner_key' $PRIVATE_KEY
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
