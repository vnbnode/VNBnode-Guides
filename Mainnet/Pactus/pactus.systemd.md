# PACTUS SystemD
Pactus is a decentralized blockchain platform, emphasizing fairness and transparency without the need for delegation or miners, enabling anyone to join and maintaining true decentralization.
[Pactus](https://pactus.org/)

## Recommended Hardware Requirements 

|   SPEC      |        Recommend          |
| :---------: | :-----------------------: |
|   **CPU**   |        2 Cores            |
|   **RAM**   |        4GB  Ram           |
|   **SSD**   |        64GB SSD           | 

# Auto:
```
curl -sO https://raw.githubusercontent.com/vnbnode/binaries/refs/heads/main/Projects/Pactus/pactus.sh  && chmod +x pactus.sh && ./pactus.sh
```
# Manual:
## 1. Update system and install build tools
```
sudo apt update && sudo apt list --upgradable && sudo apt upgrade -y
```
## 2. Additional package:
```
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu net-tools -y
```
## 3. Install go
```
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.22.2.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```
## 4. Install binary & build binary
```
cd $HOME
git clone https://github.com/pactus-project/pactus.git .pactus
cd .pactus
make build
sudo cp $HOME/.pactus/build/pactus-daemon /usr/local/bin/
sudo cp $HOME/.pactus/build/pactus-wallet /usr/local/bin/
sudo cp $HOME/.pactus/build/pactus-shell /usr/local/bin/
```
For new wallet
```
pactus-daemon init
```
For recover wallet
```
pactus-daemon init --restore "Your seed phrase"
```
## 5. Create & start service
_Replace "**Your password**"_
```
sudo tee /etc/systemd/system/pactus.service > /dev/null << EOF
[Unit]
Description=Pactus Node
After=network-online.target
StartLimitIntervalSec=0

[Service]
User=root
ExecStart=/usr/local/bin/pactus-daemon start -w /root/pactus --password "Your password"
Restart=always
RestartSec=120

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable pactus
```
```
sudo systemctl restart pactus && journalctl -f -u pactus
```
## 6. Change Config.toml
```
nano $HOME/pactus/config.toml
```
### Before
> [http]
> 
> enable = false
> 
> listen = "127.0.0.1:80"
> 
### After
> [http]
> 
> enable = true
> 
> listen = "0.0.0.0:80"
> 
```
sudo systemctl stop pactus
sudo systemctl restart pactus
```
### Check node ID.
http://***your_ip_node***:80/node

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>


