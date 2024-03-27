# Hypersign
Chain ID: `jagrat`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        8 Cores           |
|   **RAM**   |        32 GB             |
|   **SSD**   |        600 GB            |
| **NETWORK** |        1 Gbps            |

### Update and install packages for compiling
```
sudo apt update
sudo apt-get install git curl build-essential make jq gcc snapd chrony lz4 tmux unzip bc -y
```

### Install Go
```
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.21.7.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```

### Build binary
```
cd $HOME
rm -rf hid-node
git clone https://github.com/hypersign-protocol/hid-node.git
cd hid-node
git checkout v0.2.0
make install
hid-noded version
```

### Initialize Node
Replace `Name` with your own moniker
```
hid-noded init Name-VNBnode --chain-id=jagrat
```

### Download Genesis & Addrbook
```
curl -Ls https://ss-t.hypersign.nodestake.top/genesis.json > $HOME/.hid-node/config/genesis.json 
curl -Ls https://ss-t.hypersign.nodestake.top/addrbook.json > $HOME/.hid-node/config/addrbook.json 
```

### Create service
```
sudo tee /etc/systemd/system/hid-noded.service > /dev/null <<EOF
[Unit]
Description=hid-noded Daemon
After=network-online.target
[Service]
User=$USER
ExecStart=$(which hid-noded) start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable hid-noded
```

### Snapshot
```
SNAP_NAME=$(curl -s https://ss-t.hypersign.nodestake.top/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
curl -o - -L https://ss-t.hypersign.nodestake.top/${SNAP_NAME}  | lz4 -c -d - | tar -x -C $HOME/.hid-node
```

### Start Node
```
sudo systemctl restart hid-noded
journalctl -u hid-noded -f
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
