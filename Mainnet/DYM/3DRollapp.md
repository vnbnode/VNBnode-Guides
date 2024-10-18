# 3D Rollapp - Sequencer

# Minimum hardware
|   Spec  |        Requirements      |
| :---------: | :-----------------------: |
|   **CPU**   |          4 Cores (Intel / AMD)        |
|   **RAM**   |          16 GB            |
|   **SSD/NVME**   |          300 GB            | 

```
sudo apt update && sudo apt upgrade -y
```
<img width="879" alt="image" src="https://github.com/user-attachments/assets/90d863c5-b63f-4199-8a95-3e009da61e55">

```
sudo apt install -y build-essential clang curl aria2 wget tar jq libssl-dev pkg-config make
```
<img width="532" alt="image" src="https://github.com/user-attachments/assets/908b8f83-e7f9-4558-a3ea-ae9ee6158984">


```
export DOCKER_API_VERSION=1.41
```
```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```
<img width="852" alt="image" src="https://github.com/user-attachments/assets/42b63b1f-92d0-4224-9785-8c488fbf5765">


<img width="956" alt="image" src="https://github.com/user-attachments/assets/e71808db-0817-4663-bcc2-df4d88c3f9d4">

## Install docker packages:
```
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
```
sudo usermod -aG docker ${USER}
```
```
newgrp docker
```
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
## Install Roller:
```
curl https://raw.githubusercontent.com/dymensionxyz/roller/main/install.sh | bash
```
```
roller version
```
## Setup Roller Squencer:
```
roller rollapp init
```
#faucet wallets, DYM and TIA
### --> setup endpoints: rpc - 26657; api - 1317; json-rpc (evm) - 8545
```
roller rollapp setup
```
#Run Roller
```
roller da-light-client start
```
```
roller rollapp start
```
#Check status
```
roller rollapp status
```

# commands
```
roller rollapp services stop
```
```
roller rollapp services start
```
```
roller relayer services stop
```
```
roller relayer services start
```
```
tail -n 500 ~/.roller/relayer/relayer.log
```
