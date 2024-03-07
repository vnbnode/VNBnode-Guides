# SIDE
Chain ID: `side-testnet-2`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        8 GB              |
|   **SSD**   |        500 GB            |
| **NETWORK** |        1 Gbps            |

### Update and install packages for compiling
```
sudo apt update
sudo apt-get install git curl build-essential make jq gcc snapd chrony lz4 tmux unzip bc -y
```

### Install Go
```
ver="1.20.1"
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile
source $HOME/.bash_profile
go version
```

### Install Node
```
cd $HOME
rm -rf sidechain
git clone -b dev https://github.com/sideprotocol/sidechain.git
cd sidechain
git checkout v0.6.0
make install
sided version
```

### Initialize Node
Replace Yourmoniker with your own moniker
```
MONIKER="Yourmoniker"
```
```
sided init $MONIKER --chain-id=side-testnet-2
```

### Download Genesis
```
curl -Ls https://ss-t.side.nodestake.org/genesis.json > $HOME/.side/config/genesis.json 
```

### Download addrbook
```
curl -Ls https://ss-t.side.nodestake.org/addrbook.json > $HOME/.side/config/addrbook.json
```

### Create Service
```
sudo tee /etc/systemd/system/sided.service > /dev/null <<EOF
[Unit]
Description=sided Daemon
After=network-online.target
[Service]
User=$USER
ExecStart=$(which sided) start
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable sided
```

### Download Snapshot
```
SNAP_NAME=$(curl -s https://ss-t.side.nodestake.org/ | egrep -o ">20.*\.tar.lz4" | tr -d ">")
curl -o - -L https://ss-t.side.nodestake.top/${SNAP_NAME}  | lz4 -c -d - | tar -x -C $HOME/.side
```

### Launch Node
```
sudo systemctl restart sided
journalctl -u sided -f
```

## Create Validator
```
sided tx staking create-validator \
--amount 1000000uside \
--from $WALLET \
--commission-rate 0.1 \
--commission-max-rate 0.2 \
--commission-max-change-rate 0.01 \
--min-self-delegation 1 \
--pubkey $(sided tendermint show-validator) \
--moniker "Yourmoniker" \
--identity "06F5F34BD54AA6C7" \
--website "https://vnbnode.com" \
--details "" \
--chain-id side-testnet-2 \
--gas auto --fees 1000uside \
-y
```

### Faucet and stake validator: https://testnet.side.one/
Delegate: https://testnet.side.one/validators/sidevaloper1vfm2uc8mrg6yynjegcvuhekrqpykh6mzl2ytnr

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
