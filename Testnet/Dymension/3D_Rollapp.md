# 3D Rollapp - Playground
## Cấu hình tối thiểu

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        4 Cores           |
|   **RAM**   |        16 GB              |
| **Storage** |       200GB            |
| **NETWORK** |        1 Gbps            |
|   **OS**    |        Ubuntu 22.04      |
|   **Port**  |       26657, 1317, 8545           | 

### Nâng cấp hệ thống
```
sudo apt update && sudo apt upgrade -y
```
### Cài đặt các cấu hình cần thiết
```
sudo apt install -y build-essential clang curl aria2 wget tar jq libssl-dev pkg-config make
```
### Cài đặt Docker
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
### Cài đặt GO
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
### Tải Roller
```
curl https://raw.githubusercontent.com/dymensionxyz/roller/main/install.sh | bash
```
#Kiểm tra version xem mới nhất chưa
```
roller version
```
### Khởi tạo Sequencer
```
roller rollapp init
```
#Chọn playground và cung cấp thông tin Rollapp ID
#Sau khi hoàn thành bạn sẽ nhận được địa chỉ ví dym của sequencer và ví Celestia Mocha 4, hãy faucet các ví này trước khi làm bước tiếp theo.
#Nhập địa chỉ Sequencer vào phần cài đặt Rollapp: https://playground.dymension.xyz/

### Cài đặt Endpoints dùng telebit hoặc bạn tự tạo bằng nginx
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
### Cài đặt RollApp Sequencer
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

