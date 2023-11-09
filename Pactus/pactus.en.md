# Run Node Pactus

## GUI Windows, Ubuntu Desktop, MacOS
    
[LINK HERE](https://pactus.org/download/)

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/a141b8b1-cffb-491a-b9c5-0a979c2a9571)

## Ubuntu (Docker)

### 1/ Pull image Pactus
```
docker pull pactus/pactus
```
### 2/ Create new wallet
```
docker run -it --rm -v ~/pactus/testnet:/pactus pactus/pactus init -w /pactus --testnet
```
- Select: Y
- Save wallet seed

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/c3651ee4-d555-42c3-9a06-5bffc3323aed)
- Number of Validators: 1

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/43eae9e2-d9ae-4130-ae4f-93a3e927edbc)
- Save Validator Address and Reward Address

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/bc1283c6-cb91-4236-8789-16dcc5694290)

### 3/ If you already have a seed wallet, Recovery wallet
```
docker run -it --rm -v /root/pactus/testnet:/pactus pactus/pactus init -w /pactus --testnet --restore "Fill 12 seed word of you"
```
### 4/ Run node
```
docker run --network host -it --name pactus -v /root/pactus/testnet:/pactus -d --name pactus pactus/pactus start -w /pactus -p <Fill in the wallet password>
```
## 5/ [Faucet Here](https://discord.gg/pactus-795592769300987944)
- Wait synced
- Command: faucet (address)

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/aac4d155-2416-4483-b784-34bda758f605)

### 6/ Check version
```
docker exec -it pactus pactus-daemon version
```
### 7/ Check log node
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
docker exec -it pactus pactus-daemon version
```
### 6/ Check log node
```
docker logs pactus -f
```
