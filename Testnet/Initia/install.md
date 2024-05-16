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
git clone -b v0.2.14 https://github.com/initia-labs/initia.git
cd initia
git checkout v0.2.14
make install
mkdir -p $HOME/.initia/cosmovisor/genesis/bin
cp $HOME/go/bin/initiad $HOME/.initia/cosmovisor/genesis/bin/
sudo ln -s $HOME/.initia/cosmovisor/genesis $HOME/.initia/cosmovisor/current -f
sudo ln -s $HOME/.initia/cosmovisor/current/bin/initiad /usr/local/bin/initiad -f
cd $HOME
```
### Check Version
```
initiad version
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
sed -i \
  -e 's|^chain-id *=.*|chain-id = "initation-1"|' \
  -e 's|^keyring-backend *=.*|keyring-backend = "test"|' \
  -e 's|^node *=.*|node = "tcp://localhost:10657"|' \
  $HOME/.initia/config/client.toml
```
### Add Peers
```
PEERS="a63a6f6eae66b5dce57f5c568cdb0a79923a4e18@peer-initia-testnet.trusted-point.com:26628,848abf8efb7e91adeb526f15ac9561d87d6a2325@84.46.255.1:17956,00bcac6e600b1af9c00b358e7da2426b60bb3c53@155.133.22.76:53456,ae241bcfd5fffef3173c5bd4c72b0b384db5db88@49.13.213.52:26656,e3ac92ce5b790c76ce07c5fa3b257d83a517f2f6@178.18.251.146:30656,98f0f8e9209aa0a8abad39b94b0d2663a3be24ec@95.216.70.202:26656,2f7f232a67544d604773dab3f92fb51361b9d0d0@65.109.236.170:17656,1813a8de79d48674f184553800122f7bf794cd57@213.199.52.16:26656,0ca1eb793296bda62e71c515b42027ae2a27c5de@43.134.3.197:27656,b366c8e689d41e05c651e9a2f5474a82196f04a1@5.252.53.3:26656,2bc4ca9a821b56e5786378a4167c57ef6e0d174f@167.235.200.43:17956,5f934bd7a9d60919ee67968d72405573b7b14ed0@65.21.202.124:29656,70771b798b705a5fe8ae85c0b53d38208c8fa5f4@185.84.224.125:25756,132018cac831b576d2f3662fd528fe9120e3d0a2@65.108.254.0:26656,a4d7ba8e1b9acd0cd5c3bdf23a101e2d45437292@38.242.198.33:17956,6c8798b73339b11c1f214c9ee1ee6aa999439ad0@161.97.141.179:53456,cf434216cedcd589c59197ab11a92c251e0e542a@139.59.247.242:26656,670d532665a0f93ccbba6d132109c207301d6353@194.163.170.113:17956,1f6633bc18eb06b6c0cab97d72c585a6d7a207bc@65.109.59.22:25756,e6a35b95ec73e511ef352085cb300e257536e075@37.252.186.213:26656,591cf89ddadedc89df0973a3d2a7bf5a9b5fa775@95.217.228.108:17956,e3679e68616b2cd66908c460d0371ac3ed7795aa@176.34.17.102:26656,32f59b799e6e840fb47b363ba59e45c3519b3a5f@136.243.104.103:24556,e403dbcc37577f5e97a31e24fbc830749e3cb472@5.161.231.91:17956,150948b84e8b89d086dbb90dbfbf6bcb4664ce1f@109.199.111.61:26656,b78f2ebe57457d387740986a4bf450db4b9625d0@51.79.82.227:16656,684ccc935fce94b3b60d0eda94a61a8e01ca12b0@167.172.69.26:17956,0c730824973ca31701a27fa630225eeca90a8ba6@149.102.135.91:53456,27f9bf7d045a08727615af907b7ad750be455a64@194.5.152.216:17956,028999a1696b45863ff84df12ebf2aebc5d40c2d@37.27.48.77:26656,d5b1df79a57c73d4191de973846671b57da68cdf@194.163.130.254:26656" && \
sed -i \
    -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" \
    "$HOME/.initia/config/config.toml"
```
### Custom Port
```
echo 'export initia="106"' >> ~/.bash_profile
source $HOME/.bash_profile
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://0.0.0.0:${initia}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${initia}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${initia}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${initia}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${initia}60\"%" $HOME/.initia/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${initia}17\"%; s%^address = \":8080\"%address = \":${initia}80\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:${initia}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${initia}91\"%; s%:8545%:${initia}45%; s%:8546%:${initia}46%; s%:6065%:${initia}65%" $HOME/.initia/config/app.toml
```

### Start Node
```
sudo systemctl restart initia
journalctl -u initia -f
```

### Fast synch
```
sudo systemctl stop initia

initiad tendermint unsafe-reset-all --home $HOME/.initia --keep-addr-book

curl -L https://t-ss.nodeist.net/initia/snapshot_latest.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.initia --strip-components 2
```
```
sudo systemctl restart initia
journalctl -u initia -f
```

### Backup Validator
```
mkdir -p $HOME/backup/.initia
cp $HOME/.initia/config/priv_validator_key.json $HOME/backup/.initia
```

### Remove Node
```
cd $HOME
sudo systemctl stop initia
sudo systemctl disable initia
sudo rm /etc/systemd/system/initia.service
sudo systemctl daemon-reload
sudo rm -f $(which initiad)
sudo rm -rf $HOME/.initia
```

## 2/ Run Oracle

### Build binary
```
git clone https://github.com/skip-mev/slinky.git
cd slinky
git checkout v0.4.3
make build
```

### Enable Oracle
```
sed -i -e "s%^enabled = \"false\"%enabled = \"true\"%" $HOME/.initia/config/app.toml
```

### Start Orcale 
```
./build/slinky --oracle-config-path ./config/core/oracle.json --market-map-endpoint 0.0.0.0:10690
```




## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
