#!/bin/bash

echo -e "\033[0;35m"
echo "/========================================================\";
echo "||                                                      ||";
echo "|| __     ___   _ ____  _   _  ___  ____  _____ ____    ||";
echo "|| \ \   / / \ | | __ )| \ | |/ _ \|  _ \| ____/ ___|   ||";
echo "||  \ \ / /|  \| |  _ \|  \| | | | | | | |  _| \___ \   ||";
echo "||   \ V / | |\  | |_) | |\  | |_| | |_| | |___ ___) |  ||";
echo "||    \_/  |_| \_|____/|_| \_|\___/|____/|_____|____/   ||";
echo "||                                                      ||";
echo "\========================================================/";
echo -e "\e[0m"

sleep 3

echo -e "\e[1m\e[32m1. Download new entrypoint.sh... \e[0m" && sleep 1

# Download new entrypoint.sh
CONTAINER_ID=`docker ps | egrep 'availj/avail' | awk '{print $1}'`
wget -O entrypoint.sh https://github.com/vnbnode/VNBnode-Guides/blob/main/Avail/entrypoint.sh

# Grant permissions to new entrypoint.sh
chmod +x entrypoint.sh

# Insert new entrypoint
docker  cp entrypoint.sh ${CONTAINER_ID}:/entrypoint.sh

# Restart avail container
echo -e "\e[1m\e[32m1. Restart avail container... \e[0m" && sleep 1
docker restart ${CONTAINER_ID}
sleep 1

# Command check
echo '=============== SETUP FINISHED ==================='
echo -e 'View the logs from the running: sudo docker logs -f ${CONTAINER_ID}'
echo -e "Check the list container: sudo docker ps -a"
echo -e "Stop your avail node: sudo docker stop ${CONTAINER_ID}"
echo -e "Start your avail node: sudo docker start ${CONTAINER_ID}"
echo -e "Restart your avail node: sudo docker restart ${CONTAINER_ID}"
echo -e "Remove avail: sudo docker rm ${CONTAINER_ID}"
