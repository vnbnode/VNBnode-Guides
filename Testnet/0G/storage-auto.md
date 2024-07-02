# OG Storage Node
## Hardware requirements
|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        16 GB             |
| **Storage** |        1 TB Nvme         |
| **NETWORK** |        1 Gbps            |
|   **OS**    |        Ubuntu 22.04      |
## Faucet: 
https://faucet.0g.ai (faucet before setup)
### RPC list:
- https://evm-rpc-0g.mflow.tech
- https://rpc-testnet.0g.ai
- https://0gevmrpc.nodebrand.xyz
- https://0g-testnet-rpc.tech-coha05.xyz
- https://og-testnet-jsonrpc.blockhub.id
## Check RPC still working before install
```
curl -X POST <YOUR_RPC_END_POINT> -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```
- RPC still working
![image](https://github.com/vnbnode/VNBnode-Guides/assets/40466326/4921dcf3-9ac0-4fd5-977b-6c575efee799)
## Guide auto
```
wget -O 0gstorage_auto.sh https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/0g/0gstorage_auto.sh && chmod +x 0gstorage_auto.sh && ./0gstorage_auto.sh
```
## Check your last log
```
tail -f ~/0g-storage-node/run/log/zgs.log.$(TZ=UTC date +%Y-%m-%d)
```
## Check version
```
$HOME/0g-storage-node/target/release/zgs_node --version
```
## Restart node
```
sudo systemctl restart zgs
```
## Remove node
```
sudo systemctl stop zgs
sudo systemctl disable zgs
sudo rm /etc/systemd/system/zgs.service
sudo systemctl daemon-reload
sudo systemctl reset-failed
rm -rf $HOME/0g-storage-node
```
