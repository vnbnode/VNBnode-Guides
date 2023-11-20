# Testnet v2 Validator Setup Guide

## Recommended Hardware Requirements 

|   SPEC      |        Recommend          |
| :---------: | :-----------------------: |
|   **CPU**   | 4 Cores (ARM64 or x86-64) |
|   **RAM**   |        4 GB (DDR4)        |
|   **SSD**   |        30-100 GB          |
| **NETWORK** |        100 Mbps           |

### 1/ Edit Dockerfile
```
cd $HOME && wget https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/main/Elixir/Technology/set-env.sh && bash set-env.sh
```
- If you want to change the information you just entered
```
nano $HOME/.bash_profile
```
### 2/ Build Dockerfile
```
docker run -it --name ev elixir-validator
```
### 3/ Run Node
```
docker run -d --restart unless-stopped --name ev elixir-validator
```
### 4/ Check log
```
sudo docker logs -f ev
```
### 5/ Stop and Remove Node
```
sudo docker stop ev
```
```
sudo docker rm ev
```

### Dashboard: https://dashboard.elixir.finance/