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

# Pull image new
echo -e "\e[1m\e[32m4. Pull image... \e[0m" && sleep 1
SelectVersion="Please choose: \n 1. CPU from 2015 or later\n 2. CPU from 2015 or earlier"
echo -e "${SelectVersion}"
read -p "Enter index: " version;
if [ "$version" != "2" ];then
	docker pull sarvalabs/moipod:latest
else
	docker pull sarvalabs/moipod:v0.3.0-port
fi
sleep 1

# Allow port 30333
echo -e "\e[1m\e[32m5. Allow Port 1600 and 6000... \e[0m" && sleep 1
sudo ufw allow 1600/tcp
sudo ufw allow 6000/tcp
sudo ufw allow 6000/udp
sleep 1

# Fill data
echo -e "\e[1m\e[32m6. Fill data... \e[0m" && sleep 1

## DIR_PATH
if [ ! $moi_dirpath ]; then
    read -p "DIR_PATH: " moi_dirpath
    echo 'export moi_dirpath='\"${moi_dirpath}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

## KEYSTORE_PATH
if [ ! $moi_keystore ]; then
    read -p "KEYSTORE_PATH: " moi_keystore
    echo 'export moi_keystore='\"${moi_keystore}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

## PASSWD
if [ ! $moi_passwd ]; then
    read -p "PASSWORD KEYSTORE DOWNLOADED: " moi_passwd
    echo 'export moi_passwd='\"${moi_passwd}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

## ADDRESS
if [ ! $moi_address ]; then
    read -p "ADDRESS: " moi_address
    echo 'export moi_address='\"${moi_address}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

## INDEX
if [ ! $moi_index ]; then
    read -p "KRAMA ID INDEX: " moi_index
    echo 'export moi_index='\"${moi_index}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

## IP
if [ ! $moi_ip ]; then
    read -p "IP PUBLIC: " moi_ip
    echo 'export moi_ip='\"${moi_ip}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

# Register the Guardian Node
echo -e "\e[1m\e[32m7. Register the Guardian Node... \e[0m" && sleep 1
SelectVersion="Please choose: \n 1. CPU from 2015 or later\n 2. CPU from 2015 or earlier"
echo -e "${SelectVersion}"
read -p "Enter index: " version;
if [ "$version" != "2" ];then
	sudo docker run -p 1600:1600/tcp -p 6000:6000/tcp -p 6000:6000/udp --rm -it -w /data -v $(pwd):/data sarvalabs/moipod:latest register --data-dir $moi_dirpath --mnemonic-keystore-path $moi_keystore/keystore.json --watchdog-url https://babylon-watchdog.moi.technology/add --node-password $moi_passwd --network-rpc-url https://voyage-rpc.moi.technology/babylon --wallet-address $moi_address --node-index $moi_index --local-rpc-url http://$moi_ip:1600
else
	sudo docker run -p 1600:1600/tcp -p 6000:6000/tcp -p 6000:6000/udp --rm -it -w /data -v $(pwd):/data sarvalabs/moipod:v0.3.0-port register --data-dir $moi_dirpath --mnemonic-keystore-path $moi_keystore/keystore.json --watchdog-url https://babylon-watchdog.moi.technology/add --node-password $moi_passwd --network-rpc-url https://voyage-rpc.moi.technology/babylon --wallet-address $moi_address --node-index $moi_index --local-rpc-url http://$moi_ip:1600
fi
sleep 1

# Start the Guardian Node
echo -e "\e[1m\e[32m8. Start the Guardian Node... \e[0m" && sleep 1
SelectVersion="Please choose: \n 1. CPU from 2015 or later\n 2. CPU from 2015 or earlier"
echo -e "${SelectVersion}"
read -p "Enter index: " version;
if [ "$version" != "2" ];then
	sudo docker run --name moi -p 1600:1600/tcp -p 6000:6000/tcp -p 6000:6000/udp -it -d -w /data -v $(pwd):/data sarvalabs/moipod:latest server --babylon --data-dir $moi_dirpath --log-level DEBUG --node-password $moi_passwd 
else
	sudo docker run --name moi -p 1600:1600/tcp -p 6000:6000/tcp -p 6000:6000/udp -it -d -w /data -v $(pwd):/data sarvalabs/moipod:v0.3.0-port server --babylon --data-dir $moi_dirpath --log-level DEBUG --node-password $moi_passwd
fi
sleep 1

# NAMES=`docker ps | egrep 'sarvalabs/moipod' | awk '{print $18}'`
rm $HOME/moi-auto.sh

# Command check
echo '====================== SETUP FINISHED ======================'
echo -e "\e[1;32mView the logs from the running: \e[0m\e[1;36mtail -f moi/log/3*\e[0m"
echo -e "\e[1;32mView the logs from the running: \e[0m\e[1;36msudo docker logs -f moi\e[0m"
echo -e "\e[1;32mCheck the list of containers: \e[0m\e[1;36msudo docker ps -a\e[0m"
echo -e "\e[1;32mStart your node: \e[0m\e[1;36msudo docker start moi\e[0m"
echo -e "\e[1;32mRestart your node: \e[0m\e[1;36msudo docker restart moi\e[0m"
echo -e "\e[1;32mStop your node: \e[0m\e[1;36msudo docker stop moi\e[0m"
echo -e "\e[1;32mRemove: \e[0m\e[1;36msudo docker rm moi\e[0m"
echo '============================================================='
