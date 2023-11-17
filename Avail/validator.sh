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
bash_profile=$HOME/.bash_profile
if [ -f "$bash_profile" ]; then
    . $HOME/.bash_profile
fi

if [ ! $VALIDATOR ]; then
    read -p "Enter validator name: " VALIDATOR
    echo 'export VALIDATOR='\"${VALIDATOR}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1
cd $HOME

sleep 1 && curl -s https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/main/logo.sh | bash && sleep 1
sudo docker run -v $(pwd)/state:/da/state:rw -v $(pwd)/keystore:/da/keystore:rw -e DA_CHAIN=goldberg --name avail -e DA_NAME="$VALIDATOR" -p 0.0.0.0:30333:30333 -p 9615:9615 -p 9933:9933 -d --restart unless-stopped availj/avail:v1.8.0.0
# Download new entrypoint.sh
echo -e "\e[1m\e[32m1. Download new entrypoint.sh... \e[0m" && sleep 1
wget -q -O entrypoint.sh https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/main/Avail/entrypoint.sh
chmod +x entrypoint.sh
CONTAINER_ID=`docker ps | egrep 'availj/avail' | awk '{print $1}'`
# Insert new entrypoint
docker cp /root/avail/entrypoint.sh ${CONTAINER_ID}:/entrypoint.sh

# Restart avail container
echo -e "\e[1m\e[32m2. Restart avail container... \e[0m" && sleep 1
docker restart ${CONTAINER_ID}
sleep 1

# Command check
echo '====================== SETUP FINISHED ======================'
echo -e "\e[1;32mView the logs from the running: \e[0m\e[1;36msudo docker logs -f ${CONTAINER_ID}\e[0m"
echo -e "\e[1;32mCheck the list of containers: \e[0m\e[1;36msudo docker ps -a\e[0m"
echo -e "\e[1;32mStop your avail node: \e[0m\e[1;36msudo docker stop ${CONTAINER_ID}\e[0m"
echo -e "\e[1;32mStart your avail node: \e[0m\e[1;36msudo docker start ${CONTAINER_ID}\e[0m"
echo -e "\e[1;32mRestart your avail node: \e[0m\e[1;36msudo docker restart ${CONTAINER_ID}\e[0m"
echo -e "\e[1;32mRemove avail: \e[0m\e[1;36msudo docker rm ${CONTAINER_ID}\e[0m"
echo '============================================================='
