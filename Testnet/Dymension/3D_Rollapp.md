# 3D Rollapp - Playground
## Minimum Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        16 GB              |
| **Storage** |       200GB            |
|   **OS**    |        Ubuntu 22.04      |
|   **Port**  |       26657, 1317, 8545           | 

### Update & Upgrade system
```
sudo apt update && sudo apt upgrade -y
```
### Install essential packages
```
sudo apt install -y build-essential clang curl aria2 wget tar jq libssl-dev pkg-config make
```
### Install Docker
```
export DOCKER_API_VERSION=1.41
```
```
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```
```
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
```
sudo usermod -aG docker ${USER}
```
```
newgrp docker
```
### Install GO
```
ver="1.23.0"
```
```
cd $HOME
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
rm "go$ver.linux-amd64.tar.gz"
```
```
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc
```
```
go version
```
### Load Roller
```
curl https://raw.githubusercontent.com/dymensionxyz/roller/main/install.sh | bash
```
#check latest version or not
```
roller version
```
### Initiate Sequencer
```
roller rollapp init
```
#Chose playground and information to Rollapp ID
#Once complete there will be address for dym (sequencer) and Celestia Mocha 4, faucet these wallets.
#input Sequencer address into Rollapp setting: https://playground.dymension.xyz/

### Install Endpoints using telebit or using nginx
```
curl https://get.telebit.io/ | bash
```
enter your email and check the code send to your email.
```
~/telebit http 1317 rest
~/telebit http 8545 evm
~/telebit http 26657 rpc
```
```
~/telebit save
```
### Install RollApp Sequencer
```
roller rollapp setup
```
### Khởi chạy RollApp Sequencer
```
roller rollapp services load
```
```
roller da-light-client start
```
```
roller rollapp start
```
#check status
```
roller rollapp status
```
<img width="496" alt="image" src="https://github.com/user-attachments/assets/81b0a46c-d1ca-4aa6-8761-0094a4145fec">

