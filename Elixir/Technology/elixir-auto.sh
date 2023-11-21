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

# Build Dockerfile
echo -e "\e[1m\e[32m4. Build Dockerfile... \e[0m" && sleep 1
cd $HOME
cd ev
docker build . -f Dockerfile -t elixir-validator
sleep 1

# Run Node
echo -e "\e[1m\e[32m5. Run Node... \e[0m" && sleep 1
docker run -d --restart unless-stopped --name ev elixir-validator
sleep 1

cd $HOME
rm $HOME/elixir-auto.sh
# NAMES=`docker ps | egrep 'elixir-validator' | awk '{print $16}'`

# Command check
echo '====================== SETUP FINISHED ======================'
echo -e "\e[1;32mView the logs from the running: \e[0m\e[1;36msudo docker logs -f ev\e[0m"
echo -e "\e[1;32mCheck the list of containers: \e[0m\e[1;36msudo docker ps -a\e[0m"
echo -e "\e[1;32mStart your avail node: \e[0m\e[1;36msudo docker start ev\e[0m"
echo -e "\e[1;32mRestart your avail node: \e[0m\e[1;36msudo docker restart ev\e[0m"
echo -e "\e[1;32mStop your avail node: \e[0m\e[1;36msudo docker stop ev\e[0m"
echo -e "\e[1;32mRemove avail: \e[0m\e[1;36msudo docker rm ev\e[0m"
echo '============================================================='
