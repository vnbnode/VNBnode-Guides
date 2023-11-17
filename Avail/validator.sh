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
sleep 1 && curl -s https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/main/logo.sh | bash && sleep 1


sleep 3

# Download new entrypoint.sh
echo -e "\e[1m\e[32m1. Download new entrypoint.sh... \e[0m" && sleep 1
CONTAINER_ID=`docker ps | egrep 'availj/avail' | awk '{print $1}'`
curl -s  https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/main/Avail/entrypoint.sh bash && sleep 1

# Insert new entrypoint
docker cp entrypoint.sh ${CONTAINER_ID}:/entrypoint.sh

# Restart avail container
echo -e "\e[2m\e[32m1. Restart avail container... \e[0m" && sleep 1
docker restart ${CONTAINER_ID}
sleep 1

# Command check
echo '=============== SETUP FINISHED ==================='
echo -e "View the logs from the running: sudo docker logs -f ${CONTAINER_ID}"
echo -e "Check the list container: sudo docker ps -a"
echo -e "Stop your avail node: sudo docker stop ${CONTAINER_ID}"
echo -e "Start your avail node: sudo docker start ${CONTAINER_ID}"
echo -e "Restart your avail node: sudo docker restart ${CONTAINER_ID}"
echo -e "Remove avail: sudo docker rm ${CONTAINER_ID}"
