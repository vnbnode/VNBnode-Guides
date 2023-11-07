# Run Node Pactus

## GUI Windows, Ubuntu Desktop, MacOS
    
[LINK HERE](https://pactus.org/download/)

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/a141b8b1-cffb-491a-b9c5-0a979c2a9571)

## Ubuntu (Docker)

### 1/ Pull image Pactus
```
docker pull pactus/pactus
```
### 2/ Create wallet new
```
docker run -it --rm -v ~/pactus/testnet:/pactus pactus/pactus init -w /pactus --testnet
```
### 3/ Or Recovery wallet
```
docker run -it --rm -v /root/pactus/testnet:/pactus pactus/pactus init -w /pactus --testnet --restore "Fill 12 seed word of you"
```
### 4/ Run node
```
docker run --network host -it --name pactus -v /root/pactus/testnet:/pactus -d --name pactus pactus/pactus start -w /pactus -p <Fill in the wallet password>
```
### 5/ Check version
```
docker exec -it pactus-testnet pactus-daemon version
```
### 6/ Check log node
```
docker logs pactus -f
```

## Update Pactus

### 1/ Stop node
```
docker stop pactus
```
### 2/ Remove node
```
docker rm pactus
```
### 3/ Update new version
```
docker pull pactus/pactus
```
### 4/ Run node
```
docker run --network host -it --name pactus -v /root/pactus/testnet:/pactus -d --name pactus pactus/pactus start -w /pactus -p <Fill in the wallet password>
```
### 5/ Check version
```
docker exec -it pactus-testnet pactus-daemon version
```
### 6/ Check log node
```
docker logs pactus -f
```
