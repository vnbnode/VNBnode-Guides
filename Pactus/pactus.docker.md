# Run Node Pactus Docker

## Install Docker
```
sudo apt update && sudo apt upgrade -y
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
## 1/ Pull image Pactus
```
docker pull pactus/pactus
```
## 2/ Create new wallet
```
docker run -it --rm -v ~/pactus:/root/pactus pactus/pactus pactus-daemon init
```
- Select: Y
- Save wallet seed

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/c3651ee4-d555-42c3-9a06-5bffc3323aed)
- Number of Validators: 1

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/43eae9e2-d9ae-4130-ae4f-93a3e927edbc)
- Save Validator Address and Reward Address

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/bc1283c6-cb91-4236-8789-16dcc5694290)

## 3/ Fill password
- Change pass_wallet
```
passpactus=passwd_wallet
```
## 4/ Run node
```
docker run -it -d -v ~/pactus:/root/pactus --network host --name pactus pactus/pactus pactus-daemon start --password $passpactus
```
## 5/ Check version
```
docker exec -it pactus pactus-daemon version
```
## 6/ Check log node
```
docker logs pactus -f
```
## 7. Change Config.toml
```
nano $HOME/pactus/config.toml
```
### Before
> [http]
> 
> enable = false
> 
> listen = "127.0.0.1:80"
> 
### After
> [http]
> 
> enable = true
> 
> listen = "0.0.0.0:80"
> 
## 8/ Restart node
```
docker restart pactus
```
## 9/ Check node ID.
```
http://your_ip_vps:80/node
```
## 10/ Update bootstrap. Create a new Fork and pull request to Pactus Github
[Link github](https://github.com/pactus-project/pactus)

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
