# Swisstronik
Chain ID: `swisstronik_1291-1`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        16 Cores          |
|   **RAM**   |        32 GB             |
|   **SSD**   |        2  TB             |
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

### Install SGX Driver
```
wget https://download.01.org/intel-sgx/sgx-linux/2.22/distro/ubuntu22.04-server/sgx_linux_x64_driver_2.11.54c9c4c.bin 
chmod +x sgx_linux_x64_driver_2.11.54c9c4c.bin
sudo ./sgx_linux_x64_driver_2.11.54c9c4c.bin
```

### Install AESM
```
echo "deb https://download.01.org/intel-sgx/sgx_repo/ubuntu $(lsb_release -cs) main" | sudo tee -a /etc/apt/sources.list.d/intel-sgx.list >/dev/null
curl -sSL "https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key" | sudo -E apt-key add -
sudo apt update
sudo apt install sgx-aesm-service libsgx-aesm-launch-plugin libsgx-aesm-epid-plugin
sudo systemctl status aesmd.service
```

### Enable Intel SGX
```
echo "deb https://download.01.org/intel-sgx/sgx_repo/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/intel-sgx.list >/dev/null
curl -sSL "https://download.01.org/intel-sgx/sgx_repo/ubuntu/intel-sgx-deb.key" | sudo -E apt-key add -
sudo apt update
sudo apt install libsgx-launch libsgx-urts libsgx-epid libsgx-quote-ex sgx-aesm-service libsgx-aesm-launch-plugin libsgx-aesm-epid-plugin libsgx-quote-ex libsgx-dcap-ql libsnappy1v5
```

### Install Rust
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source "$HOME/.cargo/env"
cargo install sgxs-tools
sudo $(which sgx-detect)
```
```
Detecting SGX, this may take a minute...
✔  SGX instruction set  
  ✔  CPU support  
  ✔  CPU configuration  
  ✔  Enclave attributes  
  ✔  Enclave Page Cache  
  SGX features
      ✔  SGX2  ✔  EXINFO  ✔  ENCLV  ✔  OVERSUB  ✔  KSS    
      Total EPC size: 92.8MiB
✘  Flexible launch control  
  ✔  CPU support  
  ？ CPU configuration  
  ✘  Able to launch production mode enclave
✔  SGX system software  
  ✔  SGX kernel device (/dev/isgx)  
  ✘  libsgx_enclave_common  
  ✔  AESM service  
  ✔  Able to launch enclaves    
    ✔  Debug mode    
    ✘  Production mode    
    ✔  Production mode (Intel whitelisted)
```

### Build binary
```
cd $HOME
wget https://github.com/SigmaGmbH/swisstronik-chain/releases/download/v1.0.1/swisstronikd.deb.zip
unzip swisstronikd.deb.zip
sudo dpkg -i swisstronik_1.0.1-updated-binaries_amd64.deb
mkdir -p $HOME/.swisstronik/cosmovisor/genesis/bin
mv /usr/local/bin/swisstronikd $HOME/.swisstronik/cosmovisor/genesis/bin/
rm -rf build
sudo ln -s $HOME/.swisstronik/cosmovisor/genesis $HOME/.swisstronik/cosmovisor/current -f
sudo ln -s $HOME/.swisstronik/cosmovisor/current/bin/swisstronikd /usr/local/bin/swisstronikd -f
```

### Create Enclave Folder
```
sudo mkdir -p $HOME/.swisstronik-enclave/
sudo cp /usr/lib/enclave.signed.so $HOME/.swisstronik-enclave/enclave.signed.so
```

### Obtain Master Key
```
swisstronikd enclave request-master-key rpc.testnet.swisstronik.com:46789
```
```
[Enclave] Seed successfully sealed
Remote Attestation passed. Node is ready for work
```
### Cosmovisor Setup
```
go install cosmossdk.io/tools/cosmovisor/cmd/cosmovisor@v1.5.0
```
```
sudo tee /etc/systemd/system/swisstronik.service > /dev/null << EOF
[Unit]
Description=Swisstronik node service
After=network-online.target
 
[Service]
User=$USER
ExecStart=$(which cosmovisor) run start
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
Environment="DAEMON_HOME=$HOME/.swisstronik"
Environment="DAEMON_NAME=swisstronikd"
Environment="UNSAFE_SKIP_BACKUP=true"
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.swisstronik/cosmovisor/current/bin"
 
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable swisstronik
```

### Initialize Node
Replace `Name` with your own moniker
```
MONIKER="Name-VNBnode"
```
```
swisstronikd config chain-id swisstronik_1291-1	
swisstronikd config keyring-backend test
swisstronikd config node tcp://localhost:23757
```
```
swisstronikd init $MONIKER --chain-id swisstronik_1291-1
```

### Download Genesis & Addrbook
```
curl -Ls https://snap.nodex.one/swisstronik-testnet/genesis.json > $HOME/.swisstronik/config/genesis.json
curl -Ls https://snap.nodex.one/swisstronik-testnet/addrbook.json > $HOME/.swisstronik/config/addrbook.json
```

### Configure
```
sed -i -e "s|^seeds *=.*|seeds = \"d1d43cc7c7aef715957289fd96a114ecaa7ba756@testnet-seeds.nodex.one:23710\"|" $HOME/.swisstronik/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"7uswtr\"|" $HOME/.swisstronik/config/app.toml
```

### Pruning Setting
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.swisstronik/config/app.toml
```

### Custom Port
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:23758\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:23757\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:23760\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:23756\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":23766\"%" $HOME/.swisstronik/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:23717\"%; s%^address = \":8080\"%address = \":23780\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:23790\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:23791\"%; s%:8545%:23745%; s%:8546%:23746%; s%:6065%:23765%" $HOME/.swisstronik/config/app.toml
```

### Snapshot
```
curl -L https://snap.nodex.one/swisstronik-testnet/seda-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/.swisstronik
[[ -f $HOME/.swisstronik/data/upgrade-info.json ]] && cp $HOME/.swisstronik/data/upgrade-info.json $HOME/.swisstronik/cosmovisor/genesis/upgrade-info.json
```

### Start Node
```
sudo systemctl start swisstronik
journalctl -u swisstronik -f
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
