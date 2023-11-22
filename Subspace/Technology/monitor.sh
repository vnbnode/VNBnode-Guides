#!/bin/bash
exists()
{
  command -v "$1" >/dev/null 2>&1
}
if exists curl; then
echo ''
else
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi

# Logo
sleep 1 && curl -s https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/main/logo.sh | bash && sleep 1

# Update
echo -e "\e[1m\e[32m1. Update... \e[0m" && sleep 1
sudo apt update && sudo apt upgrade -y
sleep 1

# Package
echo -e "\e[1m\e[32m2. Installing package... \e[0m" && sleep 1
sudo apt install curl tar wget clang pkg-config protobuf-compiler libssl-dev jq build-essential protobuf-compiler bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
sleep 1

# Install Docker
echo -e "\e[1m\e[32m3. Installing docker... \e[0m" && sleep 1
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
sleep 1

# Download monitor
echo -e "\e[1m\e[32m4. Download monitor... \e[0m" && sleep 1
wget https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/main/Subspace/Monitor/docker-compose.yml
sleep 1

# Build monitor
echo -e "\e[1m\e[32m5. Build monitor... \e[0m" && sleep 1
docker compose up -d

cd $HOME
rm $HOME/monitor.sh
rm $HOME/docker-compose.yml

# Command check
echo '====================== SETUP FINISHED ======================'
echo -e "\e[1;32mView the logs from the running: \e[0m\e[1;36msudo docker logs -f grafana\e[0m"
echo -e "\e[1;32mView the logs from the running: \e[0m\e[1;36msudo docker logs -f prometheus\e[0m"
echo -e "\e[1;32mView the logs from the running: \e[0m\e[1;36msudo docker logs -f node-exporter\e[0m"
echo -e "\e[1;32mCheck the list of containers: \e[0m\e[1;36msudo docker ps -a\e[0m"
echo -e "\e[1;32mStop your node: \e[0m\e[1;36msudo docker stop grafana\e[0m"
echo -e "\e[1;32mRemove: \e[0m\e[1;36msudo docker rm grafana\e[0m"
echo '============================================================='
