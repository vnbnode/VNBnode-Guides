# Run Node Pactus Docker
<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://pactus.org" target="_blank">Web</a>

<img src="https://github.com/vnbnode/VNBnode-Guides/assets/76662222/23c3d2d7-f8e2-493b-bbc3-7c348fde2d6e" width="30"/> <a href="https://discord.gg/pactus-795592769300987944" target="_blank">Discord</a>

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
```
[sync]
  moniker = ""
  session_timeout = "10s"
  node_network = true
```
```
[logger.levels]
    _consensus = "warn"
    _grpc = "info"
    _http = "info"
    _network = "error"
    _nonomsg = "info"
    _pool = "error"
    _state = "info"
    _sync = "error"
    default = "info"
```
### After
- Edit moniker = "" --> "Node name of you"
```
[sync]
  moniker = ""
  session_timeout = "10s"
  node_network = true
```
- Edit network = "error" --> "info"
```
[logger.levels]
    _consensus = "warn"
    _grpc = "info"
    _http = "info"
    _network = "info"
    _nonomsg = "info"
    _pool = "error"
    _state = "info"
    _sync = "error"
    default = "info"
```
## 8/ Restart node
```
docker restart pactus
```
## 9/ Check Peers ID.
```
docker logs -f pactus
```

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/e893bca7-69e0-4629-bcba-ef463fc24c92)

## 10/ Update bootstrap. Create a new Fork and pull request to Pactus Github
[Link github](https://github.com/pactus-project/pactus)

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
