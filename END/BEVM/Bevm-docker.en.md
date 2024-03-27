# Run Node BEVM Docker
<img src="https://github.com/vnbnode/VNBnode-Guides/assets/76662222/7724db8a-a28e-452b-8431-ed5a748ba9bd" width="30"/> <a href="https://discord.gg/uBnrqrHBhD" target="_blank">Discord</a>
## Recommended Hardware Requirements 

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/e8086d6a-42a1-4b86-80cb-ae8894f10b64)

## Option 1 (Automatic)
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/BEVM/bevm-auto.sh)
```
## Option 2 (Manual)

### Install Docker
```
sudo apt-get update
sudo apt-get install \
ca-certificates \
curl \
gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 1/ Create folder bevm
```
mkdir $HOME/bevm && cd $HOME/bevm
```
### 2/ Pull image new 
```
sudo docker pull btclayer2/bevm:testnet-v0.1.2
```
### 3/ Create config.json
```
nano $HOME/bevm/config.json
```
- Edit "Your-Node-Name" --> "Address Wallet"
```
{
  "chain": "testnet",
  "log-dir": "/log",
  "enable-console-log": true,
  "no-mdns": true,
  "validator": true,
  "unsafe-rpc-external": true,
  "offchain-worker": "never",
  "rpc-methods": "unsafe",
  "log": "info,runtime=info",
  "port": 30333,
  "rpc-port": 8087,
  "pruning": "archive",
  "db-cache": 2048,
  "name": "Wallet_Address",
  "base-path": "/data",
  "telemetry-url": "wss://telemetry-testnet.bevm.io/submit 1",
  "bootnodes": []
}
```
### 3/ Run node
```
sudo docker run -d --restart always --name bevm \
  -p 8087:8087 -p 30333:30333 \
  -v $PWD/config.json:/config.json -v $PWD/data:/data \
  -v $PWD/log:/log -v $PWD/keystore:/keystore \
  btclayer2/bevm:testnet-v0.1.2 /usr/local/bin/bevm \
  --config /config.json
```
### 4/ Check log node
```
tail -f log/bevm.log
```
### [Check Telemetry](https://telemetry-testnet.bevm.io/#/0x309a090992035428553a9b85209cc3c1c0aa8e03030aac6ed4a7d75f37f1b362)
### *Follow the instruction from project:* [Guide](https://documents.bevm.io/)

## Remove Node
```
cd $HOME
docker stop bevm
docker rm bevm
rm -r $HOME/bevm
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>

