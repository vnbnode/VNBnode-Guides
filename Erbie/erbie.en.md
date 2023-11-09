# Erbie (END TESTNET)
- Guide erbie official

https://www.erbie.io/docs/install/run/index.html

Port: 30303,8544

# Automatic:
```
wget -O erbie.sh https://raw.githubusercontent.com/johnt9x/erbie/main/erbie.sh && chmod +x erbie.sh && ./erbie.sh
```
# Monitoring:
```
wget -O monitor.sh https://raw.githubusercontent.com/johnt9x/erbie/main/monitor.sh && chmod +x monitor.sh && ./monitor.sh
```
# Manual: 
# Update system and install build tools
```
sudo apt update && sudo apt list --upgradable && sudo apt upgrade -y
```
# Additional package:
```
sudo apt install curl tar wget clang pkg-config libssl-dev jq build-essential git make ncdu net-tools -y
```
# Install go
```
ver="1.20.2" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> $HOME/.bash_profile && \
source $HOME/.bash_profile && \
go version
```
# Install binary & build binary
```
mkdir -p .erbie/erbie
cd $HOME
git clone https://github.com/erbieio/erbie
cd erbie
git checkout v0.15.0
go build -o erbie cmd/erbie/main.go
mv erbie /usr/local/bin
```
# Create & start service
```
sudo tee /etc/systemd/system/erbied.service > /dev/null <<EOF
[Unit]
Description=erbie
After=online.target
[Service]
Type=simple
User=$USER
WorkingDirectory=$HOME
ExecStart= /usr/local/bin/erbie \
  --datadir $HOME/.erbie \
  --devnet \
  --identity johnt9x \
  --mine \
  --miner.threads 1 \
  --rpc \
  --rpccorsdomain "*" \
  --rpcvhosts "*" \
  --http \
  --rpcaddr 127.0.0.1 \
  --rpcport 8544 \
  --port 30303 \
  --maxpeers 50 \
  --syncmode full
Restart=on-failure
RestartSec=5
LimitNOFILE=4096
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable erbied
sudo systemctl start erbied
```
# Commands
- Check log
```
journalctl -fu erbied -o cat
```
- Check version
```
erbie version
```
- Check private key
```
cat .erbie/erbie/nodekey
```
- Edit private key (without 0x) if you want move node (for new vps)
```
sudo nano .erbie/erbie/nodekey
```
- Remove node
```
systemctl stop erbied
systemctl disable erbied
rm -rf root/usr/local/bin/erbie
rm -rf erbie
rm -rf erbie.sh
rm -rf monitor.sh
rm -rf .erbie

```
