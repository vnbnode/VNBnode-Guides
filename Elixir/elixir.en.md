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
### 2/ Build Dockerfile and Run Node (Automatic)
```
wget https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/main/Elixir/Technology/elixir-auto.sh && bash elixir-auto.sh
```
### 3/ Check log
```
sudo docker logs -f ev
```
### 4/ Stop and Remove Node
```
sudo docker stop ev
```
```
sudo docker rm ev
```

### Dashboard: https://dashboard.elixir.finance/

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/VNBnode-Guides/blob/main/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>