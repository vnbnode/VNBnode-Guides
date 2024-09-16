# Testnet v3 Validator Setup Guide

## Recommended Hardware Requirements 

|   SPEC      |        Recommend          |
| :---------: | :-----------------------: |
|   **CPU**   | 4 Cores (ARM64 or x86-64) |
|   **RAM**   |        4 GB (DDR4)        |
|   **SSD**   |        100 GB          |
| **NETWORK** |        100 Mbps           |


## Automatic Install
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Elixir/elixirV3.sh)
```
### Check log
```
sudo docker logs -f elixir
```
### Upgrade
```
docker kill elixir
docker rm elixir
docker pull elixirprotocol/validator:v3
docker run -d --env-file $HOME/ev/Dockerfile --name elixir --restart unless-stopped elixirprotocol/validator:v3
```

### Stop and Remove Node
```
sudo docker stop elixir
sudo docker rm elixir
rm -r $HOME/elixir
```



### Dashboard: https://testnet-3.elixir.xyz/

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
