# Testnest Arcium - MPC

| System Required | Minimum Hardwares |
| --- | --- |
| CPUS |  4 CPUs |
| Memory | 8 GB Memory |
| Data Disk | 100+ GB Data Disk |

## Update & Upgrade
```
sudo apt update && sudo apt upgrade -y
```
## Install neccessaries
```
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y
sudo apt-get install -y libssl-dev
```
```
apt install curl iptables build-essential git wget jq make gcc nano tmux htop nvme-cli pkg-config libssl-dev libleveldb-dev tar clang bsdmainutils ncdu unzip libleveldb-dev screen -y
```
## Install GO
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
## Install Rust
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
. "$HOME/.cargo/env"
rustc --version
```
## Install the Solana 
```
sh -c "$(curl -sSfL https://release.anza.xyz/stable/install)"
```
```
export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
```
RESTART YOUR TERMINAL
```
solana --version
```
## Install Anchor
```
cargo install --git https://github.com/coral-xyz/anchor avm --force
```
```
avm --version
```
```
avm install latest
avm use latest
```
```
anchor --version
```
## Install YARN
```
sudo apt install nodejs && sudo apt install npm
```
```
npm install --global yarn
yarn --version
```
## Install Docker + Docker Compose
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
docker --version
```
## Create Solana Wallet
```
solana-keygen new
```
SAVE THE PUBKEY AND SEED PHRASE
## Installing using the Arcium version manager (arcup)
```
TARGET="x86_64_linux" && curl -u testnet_user_20842437:ZTi9igBU6icam0y2 "https://bin.arcium.com/download/arcup_${TARGET}_0.1.30" -o ~/.cargo/bin/arcup && chmod +x ~/.cargo/bin/arcup
```
Install the latest version of the CLI using arcup:
```
arcup install
```
Verify the installation.
```
arcium --version
```
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnode_Inside</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/twitter_icon.png" width="30" height="30"/> <a href="https://x.com/vnbnode" target="_blank">VNBnode Twitter</a>
