# Run Full Node and Validator Avail Docker v1.10.0.0
<p align="center">
  <img height="100" height="auto" src="https://github.com/vnbnode/binaries/blob/main/Projects/Avail/avail.png?raw=true">
</p>

## Recommended Hardware Requirements 
![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/7449170a-c03a-4502-8ffb-26455e413e33)

## Option 1 (Automatic)
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Avail/avail-auto.sh)
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

### 1/ Pull image new 
```
docker pull availj/avail:v1.10.0.0
```
### 2/ Run node 
`Edit VNBnode --> Your Name`
```
Nodename = VNBnode
```
```
sudo docker run --name avail -v $(pwd)/avail/:/da/avail:rw --network host -d --restart unless-stopped availj/avail:v1.10.0.0 --chain goldberg --name "${Nodename}" --validator -d /da/avail
```
### 3/ Open Port 30333
```
sudo ufw allow 30333/tcp
sudo ufw allow 30333/udp
```
### 4/ Check log node
```
docker logs -f avail
```

## Create Validator
Navigate to the Goldberg network explorer at http://goldberg.avail.tools.
* Note: `Need 1000 AVL to create Validator`
### *Follow the instruction from project:* [Guide](https://docs.availproject.org/operate/validator/staking/)

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>

