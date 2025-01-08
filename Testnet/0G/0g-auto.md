# OG Node
## Hardware requirements
|   SPEC      |       0G Validator       |       0G Storage         |
| :---------: | :-----------------------:|  :-----------------------:
|   **CPU**   |        16 Cores          |       4 Cores            |
|   **RAM**   |        64 GB             |       16 GB              |
| **Storage** |        2 TB Nvme         |       1 TB Nvme          |
| **NETWORK** |        1 Gbps            |       1 Gbps             |
|   **OS**    |        Ubuntu 22.04      |       Ubuntu 22.04       |

### End Points
https://rpc-0g.vnbnode.com

https://api-0g.vnbnode.com

https://grpc-0g.vnbnode.com

### Explorer
https://explorer.vnbnode.com/0g-Testnet 

### Faucet: 
https://faucet.0g.ai (faucet before setup)
### EVM RPC list:
- https://rpc-testnet.0g.ai
- https://0gevmrpc.nodebrand.xyz
- https://0g-testnet-rpc.tech-coha05.xyz
- https://og-testnet-jsonrpc.blockhub.id
### Check RPC still working before install
```
curl -X POST <YOUR_RPC_END_POINT> -H "Content-Type: application/json" -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'
```
- RPC still working
![image](https://github.com/vnbnode/VNBnode-Guides/assets/40466326/4921dcf3-9ac0-4fd5-977b-6c575efee799)
## Guide auto
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/0g/0g-auto.sh)
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
