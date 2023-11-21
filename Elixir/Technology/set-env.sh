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

# Set ENV ADDRESS
if [ ! $ENVADDRESS ]; then
    read -p "Enter ADDRESS: " ENVADDRESS
    echo 'export ENVADDRESS='\"${ENVADDRESS}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

# Set ENV PRIVATE_KEY
if [ ! $ENVPRIVATE_KEY ]; then
    read -p "Enter PRIVATE_KEY: " ENVPRIVATE_KEY
    echo 'export ENVPRIVATE_KEY='\"${ENVPRIVATE_KEY}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

# Set ENV VALIDATOR_NAME
if [ ! $ENVVALIDATOR_NAME ]; then
    read -p "Enter VALIDATOR_NAME: " ENVVALIDATOR_NAME
    echo 'export ENVVALIDATOR_NAME='\"${ENVVALIDATOR_NAME}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

# Build Dockerfile
echo -e "\e[1m\e[32mBuild Dockerfile... \e[0m" && sleep 1
mkdir ev && cd ev
sleep 1
wget https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/main/Elixir/Technology/Dockerfile
sleep 1
docker build . -f Dockerfile -t elixir-validator
sleep 1

cd $HOME 
rm $HOME/set-env.sh
echo -e "\e[1;32mDONE\e[0m"

