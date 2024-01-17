# Run Node BEVM Docker
<img src="https://github.com/vnbnode/VNBnode-Guides/assets/76662222/7724db8a-a28e-452b-8431-ed5a748ba9bd" width="30"/> <a href="https://discord.gg/uBnrqrHBhD" target="_blank">Discord</a>
## Recommended Hardware Requirements 

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/e8086d6a-42a1-4b86-80cb-ae8894f10b64)

## Option 1 (Automatic)
```
cd $HOME && curl -o bevm-auto.sh https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/BEVM/run-auto.sh && bash bevm-auto.sh
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

### 1/ Establish a host mapping path
```
cd /var/lib
mkdir node_bevm_test_storage
```
### 2/ Pull image new 
```
sudo docker pull btclayer2/bevm:v0.1.1
```
### 3/ Run node
```
sudo docker run -d -v /var/lib/node_bevm_test_storage:/root/.local/share/bevm btclayer2/bevm:v0.1.1 bevm "--chain=testnet" "--name=Nodename-VNBnode" "--pruning=archive" --telemetry-url "wss://telemetry.bevm.io/submit 0"
```
### 4/ Rename container
```
docker rename name_old bevm
```
### 5/ Check log node
```
docker logs -f bevm 
```
### [Check Telemetry](https://telemetry.bevm.io/#/0x41cfeafc7177775a0e838b3725a0178b89ebf5dde1b5f766becbf975a24e297b)
### *Follow the instruction from project:* [Guide](https://documents.bevm.io/)

## Remove Node
```
cd $HOME
docker stop bevm
docker rm bevm
rm -r /var/lib/node_bevm_test_storage
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>

