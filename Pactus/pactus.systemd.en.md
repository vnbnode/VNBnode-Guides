# PACTUS MAINNET
Pactus is a decentralized blockchain platform, emphasizing fairness and transparency without the need for delegation or miners, enabling anyone to join and maintaining true decentralization.
[Pactus](https://pactus.org/)
# 1. Update system and install build tools
```
sudo apt update && sudo apt list --upgradable && sudo apt upgrade -y
```
# 2. Additional package:
```
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu net-tools -y
```
# 3. Install go
```
ver="1.21" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
```
# 4. Install binary & build binary
```
cd $Home
git clone https://github.com/pactus-project/pactus.git .pactus
cd .pactus
make build
cd build
```
For new wallet
```
./pactus-daemon init
```
For recover wallet
```
./pactus-daemon init --restore "Your seed phrase"
```
# 5. Create & start service
```
tee /etc/systemd/system/pactusd.service > /dev/null << EOF
[Unit]
Description=pactus Node
After=network-online.target
StartLimitIntervalSec=0
[Service]
User=root
ExecStart= /root/.pactus/build/pactus-daemon start --password "Your pass"
Restart=always
RestartSec=120
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable pactusd
```
```
sudo systemctl restart pactusd && journalctl -f -u pactusd
```
# 6. Change Config.toml
```
nano $HOME/pactus/config.toml
```

**Before**
[http]
  enable = ***false***
  listen = "***127.0.0.1:80***"
  
**After**
[http]
  enable = ***true***
  listen = "***0.0.0.0:80***"
```
sudo systemctl stop pactusd
sudo systemctl restart pactusd
```
Check node ID
http://***your_ip_node***:80/node
# 7. Update bootstrap. Create a new Fork and pull request to Pactus Github
[Link github](https://github.com/pactus-project/pactus)

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>


