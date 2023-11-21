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
cd $HOME && mkdir ev && cd ev && wget https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/main/Elixir/Technology/Dockerfile && nano Dockerfile
```
```
FROM elixirprotocol/validator:testnet-2

ENV ADDRESS=
ENV PRIVATE_KEY=
ENV VALIDATOR_NAME=
```
### 2/ Build Dockerfile
```
docker build . -f Dockerfile -t elixir-validator
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
