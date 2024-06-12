# Initia

## 1/ Run Node

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        16 GB             |
| **Storage** |        1 TB SSD          |
| **NETWORK** |        100 Mbps          |
|   **OS**    |        Ubuntu 22.04      |
|   **Port**  |        10656             | 

## End Points

https://rpc-initia.vnbnode.com

https://api-initia.vnbnode.com

https://grpc-initia.vnbnode.com

### Update and install packages for compiling
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/update-binary.sh)
```

### Build binary
```
git clone -b v0.2.15 https://github.com/initia-labs/initia.git
cd initia
git checkout v0.2.15
make install
mkdir -p $HOME/.initia/cosmovisor/genesis/bin
cp $HOME/go/bin/initiad $HOME/.initia/cosmovisor/genesis/bin/
sudo ln -s $HOME/.initia/cosmovisor/genesis $HOME/.initia/cosmovisor/current -f
sudo ln -s $HOME/.initia/cosmovisor/current/bin/initiad /usr/local/bin/initiad -f
cd $HOME
```

### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
sudo tee /etc/systemd/system/initia.service > /dev/null << EOF
[Unit]
Description=initia node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.initia"
Environment="DAEMON_NAME=initiad"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="DAEMON_RESTART_AFTER_UPGRADE=true"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable initia
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
initiad init $MONIKER --chain-id initation-1
```

### Download Genesis & Addrbook
```
wget https://initia.s3.ap-southeast-1.amazonaws.com/initiation-1/genesis.json -O $HOME/.initia/config/genesis.json
wget https://rpc-initia-testnet.trusted-point.com/addrbook.json -O $HOME/.initia/config/addrbook.json
```

### Configure
```
seeds=$(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Initia/seeds.txt)
sed -i.bak -e "s/^seeds *=.*/seeds = \"$seeds\"/" $HOME/.initia/config/config.toml
peers=$(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Initia/peers.txt)
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.initia/config/config.toml
sed -i.bak -e "s/^pruning *=.*/pruning = \"custom\"/" $HOME/.initia/config/app.toml
sed -i.bak -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" $HOME/.initia/config/app.toml
sed -i.bak -e "s/^pruning-interval *=.*/pruning-interval = \"10\"/" $HOME/.initia/config/app.toml
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uinit\"/" $HOME/.initia/config/app.toml
sed -i "s/^indexer *=.*/indexer = \"kv\"/" $HOME/.initia/config/config.toml
```

### Custom Port
```
echo 'export initia="106"' >> ~/.bash_profile
source $HOME/.bash_profile
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://0.0.0.0:${initia}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${initia}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${initia}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${initia}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${initia}60\"%" $HOME/.initia/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${initia}17\"%; s%^address = \":8080\"%address = \":${initia}80\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:${initia}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${initia}91\"%; s%:8545%:${initia}45%; s%:8546%:${initia}46%; s%:6065%:${initia}65%" $HOME/.initia/config/app.toml
sed -i.bak -e "s%:1317%:${initia}17%g;
s%:8080%:${initia}80%g;
s%:9090%:${initia}90%g;
s%:9091%:${initia}91%g;
s%:8545%:${initia}45%g;
s%:8546%:${initia}46%g;
s%:6065%:${initia}65%g" $HOME/.0gchain/config/app.toml
sed -i.bak -e "s%:26658%:${initia}58%g;
s%:26657%:${initia}57%g;
s%:6060%:${initia}60%g;
s%:26656%:${initia}56%g;
s%^external_address = \"\"%external_address = \"$(wget -qO- eth0.me):${initia}56\"%;
s%:26660%:${initia}60%g" $HOME/.0gchain/config/config.toml
sed -i \
  -e 's|^chain-id *=.*|chain-id = "initation-1"|' \
  -e 's|^keyring-backend *=.*|keyring-backend = "test"|' \
  -e 's|^node *=.*|node = "tcp://localhost:10657"|' \
  $HOME/.initia/config/client.toml
```

### Start Node
```
sudo systemctl restart initia
journalctl -u initia -f
```

### Snapshot
```
cd $HOME
sudo systemctl stop initia
cp $HOME/.initia/data/priv_validator_state.json $HOME/.initia/priv_validator_state.json.backup
rm -rf $HOME/.initia/data && mkdir -p $HOME/.initia/data
curl -o - -L http://snapshots.staking4all.org/testnet-snapshots/initia/latest/initia.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/.initia
rm $HOME/initia.tar.lz4
mv $HOME/.initia/priv_validator_state.json.backup $HOME/.initia/data/priv_validator_state.json
sudo systemctl restart initia
journalctl -u initia -f
```

### Backup Validator
```
mkdir -p $HOME/backup/.initia
cp $HOME/.initia/config/priv_validator_key.json $HOME/backup/.initia
```

### Update
```
# Check current version
initiad version
```

```
sudo systemctl stop initia
rm -r initia
git clone -b v0.2.15 https://github.com/initia-labs/initia.git
cd initia
git checkout v0.2.15
make install
mkdir -p $HOME/.initia/cosmovisor/genesis/bin
cp $HOME/go/bin/initiad $HOME/.initia/cosmovisor/genesis/bin/
sudo ln -s $HOME/.initia/cosmovisor/genesis $HOME/.initia/cosmovisor/current -f
sudo ln -s $HOME/.initia/cosmovisor/current/bin/initiad /usr/local/bin/initiad -f
cd $HOME
```
```
# Check new version
initiad version
```
```
sudo systemctl restart initia
journalctl -u initia -f
```

### Remove Node
```
cd $HOME
sudo systemctl stop initia
sudo systemctl disable initia
sudo rm /etc/systemd/system/initia.service
sudo systemctl daemon-reload
sudo rm -f $(which initiad)
sudo rm -r initia
sudo rm -rf $HOME/.initia
```
## 2/ Run Oracle
### Clone the Repository and build binaries
```
# Clone repository
cd $HOME
rm -rf slinky
git clone https://github.com/skip-mev/slinky.git
cd slinky
git checkout v0.4.3

# Build binaries
make build

# Move binary to local bin
mv build/slinky /usr/local/bin/
rm -rf build
```
### Creat systemd service _(Check your port)_
```
sudo tee /etc/systemd/system/slinky.service > /dev/null <<EOF
[Unit]
Description=Initia Slinky Oracle
After=network-online.target

[Service]
User=$USER
ExecStart=$(which slinky) --oracle-config-path $HOME/slinky/config/core/oracle.json --market-map-endpoint 0.0.0.0:10690
Restart=on-failure
RestartSec=30
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable slinky.service
```
### Enable Oracle Vote Extension
```
# Update Oracle app.toml
nano ~/.initia/config/app.toml
```
```
###############################################################################
###                                  Oracle                                 ###
###############################################################################
[oracle]
# Enabled indicates whether the oracle is enabled.
enabled = "true"

# Oracle Address is the URL of the out of process oracle sidecar. This is used to
# connect to the oracle sidecar when the application boots up. Note that the address
# can be modified at any point, but will only take effect after the application is
# restarted. This can be the address of an oracle container running on the same
# machine or a remote machine.
oracle_address = "127.0.0.1:10680"

# Client Timeout is the time that the client is willing to wait for responses from 
# the oracle before timing out.
client_timeout = "500ms"

# MetricsEnabled determines whether oracle metrics are enabled. Specifically
# this enables instrumentation of the oracle client and the interaction between
# the oracle and the app.
metrics_enabled = "false"
```

### Update Oracle config.toml _(restart your initia node after change config)_
```
sed -i.bak \
    -e 's/^timeout_propose *=.*/timeout_propose = "3s"/' \
    -e 's/^timeout_propose_delta *=.*/timeout_propose_delta = "500ms"/' \
    -e 's/^timeout_prevote *=.*/timeout_prevote = "1s"/' \
    -e 's/^timeout_prevote_delta *=.*/timeout_prevote_delta = "500ms"/' \
    -e 's/^timeout_precommit *=.*/timeout_precommit = "1s"/' \
    -e 's/^timeout_precommit_delta *=.*/timeout_precommit_delta = "500ms"/' \
    -e 's/^timeout_commit *=.*/timeout_commit = "1s"/' \
    $HOME/.initia/config/config.toml
```
### Run oracle
```
sudo systemctl start slinky.service
journalctl -fu slinky --no-hostname
```
### Remove Oracle
```
cd $HOME
sudo systemctl stop slinky
sudo systemctl disable slinky
rm /etc/systemd/system/slinky.service
sudo systemctl daemon-reload
cd $HOME
rm -rf $(which slinkyd)
rm -rf slinky
```
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
