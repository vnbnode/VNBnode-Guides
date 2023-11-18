# Run Avail Docker v1.8.0.2 (Goldberg)
<p align="center">
  <img height="100" height="auto" src="/Avail/Technology/avail.png?raw=true">
</p>

## Recommended Hardware Requirements 
![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/7449170a-c03a-4502-8ffb-26455e413e33)


## Option 1 (Automatic)
```
cd $HOME && wget https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/main/Avail/Technology/avail-auto.sh && bash avail-auto.sh
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
docker pull availj/avail:v1.8.0.2
```
### 2/ Run node
```
sudo docker run -v $(pwd)$HOME/avail/state:/da/state:rw -v $(pwd)$HOME/avail/keystore:/da/keystore:rw -e DA_CHAIN=goldberg --name avail -e DA_NAME=<Fill Node name of you> --network host -d --restart unless-stopped availj/avail:v1.8.0.2
```
### 3/ Run validator on Docker
```
cd $HOME/avail && wget https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/main/Avail/Technology/validator.sh && bash validator.sh
```
### 4/ Check log node
```
docker logs avail -f
```
## Update new version

### 1/ Stop node
```
docker stop avail
```
### 2/ Remove node
```
docker rm avail
```
### 3/ Update new version
```
docker pull availj/avail:v1.8.0.2
```
### 4/ Run node
```
sudo docker run -v $(pwd)$HOME/avail/state:/da/state:rw -v $(pwd)$HOME/avail/keystore:/da/keystore:rw -e DA_CHAIN=goldberg --name avail -e DA_NAME=<Fill Node name of you> --network host -d --restart unless-stopped availj/avail:v1.8.0.2
```
### 5/ Check log node
```
docker logs avail -f
```
