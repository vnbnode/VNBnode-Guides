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

# Download new entrypoint.sh
echo -e "\e[1m\e[32m1. Download new entrypoint.sh... \e[0m" && sleep 1
wget -q -O entrypoint.sh https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/main/Avail/Technology/entrypoint.sh
chmod +x entrypoint.sh
NAMES=`docker ps | egrep 'availj/avail' | awk '{print $10}'`

# Insert new entrypoint
docker cp $HOME/entrypoint.sh ${NAMES}:/entrypoint.sh
rm $HOME/validator.sh
rm $HOME/entrypoint.sh

# Restart avail container
echo -e "\e[1m\e[32m2. Restart avail container... \e[0m" && sleep 1
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
