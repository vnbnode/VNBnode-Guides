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

# Set name validator
if [ ! $VALIDATOR ]; then
    read -p "Enter Name Validator: " VALIDATOR
    echo 'export VALIDATOR='\"${VALIDATOR}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

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

# Pull image new
echo -e "\e[1m\e[32m4. Pull image... \e[0m" && sleep 1
docker pull availj/avail:v1.8.0.2
sleep 1

# Run Node
echo -e "\e[1m\e[32m5. Run node avail... \e[0m" && sleep 1
sudo docker run -v $(pwd)$HOME/avail/state:/da/state:rw -v $(pwd)$HOME/avail/keystore:/da/keystore:rw -e DA_CHAIN=goldberg --name avail -e DA_NAME=${VALIDATOR} --network host -d --restart unless-stopped availj/avail:v1.8.0.2
sleep 1

# Allow port 30333
echo -e "\e[1m\e[32m6. Allow Port 30333... \e[0m" && sleep 1
sudo ufw allow 30333/tcp
sudo ufw allow 30333/udp
sleep 1

# Download new entrypoint.sh
echo -e "\e[1m\e[32m7. Download new entrypoint.sh... \e[0m" && sleep 1
cd $HOME
wget -q -O entrypoint.sh https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/main/Avail/Technology/entrypoint.sh
chmod +x entrypoint.sh
NAMES=`docker ps | egrep 'availj/avail' | awk '{print $10}'`

# Insert new entrypoint
docker cp $HOME/entrypoint.sh ${NAMES}:/entrypoint.sh
sleep 1
rm $HOME/entrypoint.sh
rm $HOME/avail-auto.sh
sleep 1

# Restart avail container
echo -e "\e[1m\e[32m8. Restart avail container... \e[0m" && sleep 1
docker restart ${NAMES}
sleep 1

# Command check
echo '====================== SETUP FINISHED ======================'
echo -e "\e[1;32mView the logs from the running: \e[0m\e[1;36msudo docker logs -f ${NAMES}\e[0m"
echo -e "\e[1;32mCheck the list of containers: \e[0m\e[1;36msudo docker ps -a\e[0m"
echo -e "\e[1;32mStart your avail node: \e[0m\e[1;36msudo docker start ${NAMES}\e[0m"
echo -e "\e[1;32mRestart your avail node: \e[0m\e[1;36msudo docker restart ${NAMES}\e[0m"
echo -e "\e[1;32mStop your avail node: \e[0m\e[1;36msudo docker stop ${NAMES}\e[0m"
echo -e "\e[1;32mRemove avail: \e[0m\e[1;36msudo docker rm ${NAMES}\e[0m"
echo '============================================================='
