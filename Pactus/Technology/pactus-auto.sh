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

# Pull image new
echo -e "\e[1m\e[32m4. Pull image... \e[0m" && sleep 1
docker pull pactus/pactus
sleep 1

# Create wallet
echo -e "\e[1m\e[32m5. Create wallet... \e[0m" && sleep 1
docker run -it --rm -v ~/pactus/testnet:/pactus pactus/pactus init -w /pactus --testnet
sleep 1

# Fill in wallet password
if [ ! $passpactus ]; then
    read -p "Fill in wallet password: " passpactus
    echo 'export passpactus='\"${passpactus}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

# Run Node
echo -e "\e[1m\e[32m6. Run node pactus... \e[0m" && sleep 1
docker run --network host -it --name pactus -v /root/pactus/testnet:/pactus -d --name pactus pactus/pactus start -w /pactus -p $passpactus
sleep 1

NAMES=`docker ps | egrep 'pactus/pactus' | awk '{print $13}'`
rm $HOME/pactus-auto.sh

# Command check
echo '====================== SETUP FINISHED ======================'
echo -e "\e[1;32mView the logs from the running: \e[0m\e[1;36msudo docker logs -f ${NAMES}\e[0m"
echo -e "\e[1;32mCheck the list of containers: \e[0m\e[1;36msudo docker ps -a\e[0m"
echo -e "\e[1;32mStart your avail node: \e[0m\e[1;36msudo docker start ${NAMES}\e[0m"
echo -e "\e[1;32mRestart your avail node: \e[0m\e[1;36msudo docker restart ${NAMES}\e[0m"
echo -e "\e[1;32mStop your avail node: \e[0m\e[1;36msudo docker stop ${NAMES}\e[0m"
echo -e "\e[1;32mRemove avail: \e[0m\e[1;36msudo docker rm ${NAMES}\e[0m"
echo '============================================================='