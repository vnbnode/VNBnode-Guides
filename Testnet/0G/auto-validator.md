# 0G

### OLD: Snapshot: https://github.com/vnbnode/VNBnode-Guides/blob/main/Testnet/0G/Snapshot.md

## End Points

https://rpc-0g.vnbnode.com

https://api-0g.vnbnode.com

https://grpc-0g.vnbnode.com

## Explorer

https://explorer.vnbnode.com/0g-Testnet
https://explorer.mflow.tech/OG-Testnet

## Chain ID: `zgtendermint_16600-2`

## Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        16 Cores           |
|   **RAM**   |        64 GB             |
| **Storage** |        1 TB Nvme         |
| **NETWORK** |        1 Gbps            |
|   **OS**    |        Ubuntu 22.04      |
|   **Port**  |        10156             | 

### Check logs
```
journalctl -u 0g -f
```

### Backup Validator
```
mkdir -p $HOME/backup/.0gchain
cp $HOME/.0gchain/config/priv_validator_key.json $HOME/backup/.0gchain
```

### Remove Node
```
cd $HOME
sudo systemctl stop 0g
sudo systemctl disable 0g
sudo rm /etc/systemd/system/0g.service
sudo systemctl daemon-reload
sudo rm $HOME/go/bin/0gchaind
sudo rm -f $(which 0gchaind)
sudo rm -rf $HOME/0g-chain
sudo rm -rf $HOME/.0gchain
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
