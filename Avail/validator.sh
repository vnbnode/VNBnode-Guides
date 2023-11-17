#!/bin/bash

echo " __      __ _   _   _____    _   _  ____  _____  ______  _____  ";
echo " \ \    / /| \ | | |  __ \  | \ | |/ __ \|  __ \|  ____|/ ____| ";
echo "  \ \  / / |  \| | |     /  |  \| | |  | | |  | | |__  | (___   ";
echo "   \ \/ /  |     | |___ /   |     | |  | | |  | |  __|  \___ \  ";
echo "    \  /   | |\  | |    \   | |\  | |__| | |__| | |____ ____) | ";
echo "     \/    |_| \_| |_____/  |_| \_|\____/|_____/|______|_____/    ";

sleep 3

# Download new entrypoint.sh
CONTAINER_ID=`docker ps | egrep 'availj/avail' | awk '{print $1}'`
wget -O entrypoint.sh https://github.com/vnbnode/VNBnode-Guides/blob/main/Avail/entrypoint.sh

# Grant permissions to new entrypoint.sh
chmod +x entrypoint.sh

# Insert new entrypoint
docker  cp entrypoint.sh ${CONTAINER_ID}:/entrypoint.sh

# Restart avail container
docker restart ${CONTAINER_ID}

# Command check
echo '=============== SETUP FINISHED ==================='
echo -e 'View the logs from the running: sudo docker logs -f ${CONTAINER_ID}'
echo -e "Check the list container: sudo docker ps -a"
echo -e "Stop your avail node: sudo docker stop ${CONTAINER_ID}"
echo -e "Start your avail node: sudo docker start ${CONTAINER_ID}"
echo -e "Restart your avail node: sudo docker restart ${CONTAINER_ID}"
echo -e "Remove avail: sudo docker rm ${CONTAINER_ID}"