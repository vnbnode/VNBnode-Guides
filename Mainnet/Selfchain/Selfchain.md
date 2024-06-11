# Selfchain
|  Chain ID  |  Port  |  Version  |
|------------|--------|-----------|
|    self-1  |  113   |   v1.0.1   |

<img src="https://github.com/vnbnode/VNBnode-Guides/assets/76662222/7724db8a-a28e-452b-8431-ed5a748ba9bd" width="30"/> <a href="https://discord.com/invite/selfchainxyz" target="_blank">Discord</a>
## RPC, API, gRPC and Snapshot
✅ RPC https://rpc-selfchain.vnbnode.com

✅ API: https://api-selfchain.vnbnode.com

✅ gRPC: https://grpc-selfchain.vnbnode.com

✅ Auto Snapshot daily: 
```
https://github.com/vnbnode/VNBnode-Guides/blob/main/Mainnet/Selfchain/Snapshot.md
```
## Server Requirements
| Component   |  Requirements  |
|-------------|----------------|
| CPU         | 4-8 cores CPU  |
| Storage     | 100 GB         |
| Ram         | 16 GB          |
| OS          | Ubuntu 22.04+  |
## Install
```
MONIKER="Yourmoniker"
```
- Update and install packages for compiling
```
sudo apt -q update
sudo apt -qy install curl git jq lz4 build-essential
sudo apt -qy upgrade
```
- Install Go 1.20.1
```
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.20.8.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)
```
- Download and install binary
```
cd $HOME
curl -O https://snap.vnbnode.com/selfchain/selfchaind
chmod +x selfchaind
mv selfchaind /usr/local/bin/
selfchaind version
```
- Set Service file
```
sudo tee /etc/systemd/system/selfchain.service > /dev/null <<EOF
[Unit]
Description=Selfchain Mainnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which selfchaind) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable selfchain
```
Initialize the node
- Set node configuration
```
selfchaind config chain-id self-1
selfchaind config keyring-backend file
selfchaind config node tcp://localhost:11357
```
- Initialize the node
```
selfchaind init $MONIKER --chain-id self-1
```
- Add Genesis File
```
wget -O $HOME/.selfchain/config/genesis.json https://gist.githubusercontent.com/pratikbin/656a18f371e7a970afd63e2da2890c81/raw/3876268b2d07ce65aece8455c67f98cf557c6e40/selfchain-mainnet-self-1.json
```
- Configure Seeds and Peers
```
SEEDS="b307b56b94bd3a02fcad5b6904464a391e13cf48@128.199.33.181:26656,71b8d630e7c3e31f2743fda68e6d3ac64f41cece@209.97.174.97:26656,6ae10267d8581414b37553655be22297b2f92087@174.138.25.159:26656"
PEERS="b307b56b94bd3a02fcad5b6904464a391e13cf48@128.199.33.181:26656,71b8d630e7c3e31f2743fda68e6d3ac64f41cece@209.97.174.97:26656,6ae10267d8581414b37553655be22297b2f92087@174.138.25.159:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.selfchain/config/config.toml
```
- Set Pruning, Enable Prometheus, Gas Price, and Indexer
```
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/.selfchain/config/app.toml
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.005uslf\"/" $HOME/.selfchain/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.selfchain/config/config.toml
```
- Set custom ports
```
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:11358\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:11357\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:11360\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:11356\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":11366\"%" $HOME/.selfchain/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:11317\"%; s%^address = \":8080\"%address = \":11380\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:11390\"%; s%^address = \"localhost:9091\"%address = \"0.0.0.0:11391\"%; s%:8545%:11345%; s%:8546%:11346%; s%:6065%:11365%" $HOME/.selfchain/config/app.toml
```
- Start service and check the logs
```
sudo systemctl start selfchain && sudo journalctl -u selfchain -f --no-hostname -o cat
```
- Snapshot

_Off State Sync_
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" ~/.selfchain/config/config.toml
```
_Stop Node and Reset Data_
```
sudo systemctl stop selfchain
cp $HOME/.selfchain/data/priv_validator_state.json $HOME/.selfchain/priv_validator_state.json.backup
rm -rf $HOME/.selfchain/data
selfchaind tendermint unsafe-reset-all --home ~/.selfchain/ --keep-addr-book
```
_Download Snapshot_
```
curl -L https://snap.vnbnode.com/selfchain/self-1_snapshot_latest.tar.lz4 | tar -I lz4 -xf - -C $HOME/.selfchain/data
```
```
mv $HOME/.selfchain/priv_validator_state.json.backup $HOME/.selfchain/data/priv_validator_state.json
```
_Restart Node_
```
sudo systemctl restart selfchain && sudo journalctl -u selfchain -f --no-hostname -o cat
```
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
