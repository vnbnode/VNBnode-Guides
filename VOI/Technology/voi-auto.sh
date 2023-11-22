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

cd $HOME

# Fill data
echo -e "\e[1m\e[32m1. Fill data... \e[0m" && sleep 1

## Node name
if [ ! $Nodename ]; then
    read -p "Node Name: " Nodename
    echo 'export Nodename='\"${Nodename}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

## Wallet name
if [ ! $walletname ]; then
    read -p "Wallet name: " walletname
    echo 'export walletname='\"${walletname}\" >> $HOME/.bash_profile
fi
echo 'source $HOME/.bashrc' >> $HOME/.bash_profile
source $HOME/.bash_profile
sleep 1

# Need install software and its updates
echo -e "\e[1m\e[32m2. Install software and its updates... \e[0m" && sleep 1
sudo apt install -y jq bc gnupg2 curl software-properties-common
curl -o - https://releases.algorand.com/key.pub | sudo tee /etc/apt/trusted.gpg.d/algorand.asc
sudo add-apt-repository "deb [arch=amd64] https://releases.algorand.com/deb/ stable main"
sleep 1

# Install Node Algorand
echo -e "\e[1m\e[32m3. Install Node Algorand... \e[0m" && sleep 1
sudo apt update && sudo apt install -y algorand
sudo systemctl stop algorand && sudo systemctl disable algorand
sleep 1

# Setup goal
echo -e "\e[1m\e[32m4. Setup goal... \e[0m" && sleep 1
echo -e "\nexport ALGORAND_DATA=/var/lib/algorand/" >> ~/.bashrc && source ~/.bashrc
sleep 1

# Configure Node VOI
echo -e "\e[1m\e[32m5. Configure Node VOI... \e[0m" && sleep 1
sudo algocfg set -p DNSBootstrapID -v "<network>.voi.network" -d /var/lib/algorand/ &&\
sudo algocfg set -p EnableCatchupFromArchiveServers -v true -d /var/lib/algorand/ &&\
sudo chown algorand:algorand /var/lib/algorand/config.json &&\
sudo chmod g+w /var/lib/algorand/config.json
sleep 1
sudo curl -s -o /var/lib/algorand/genesis.json https://testnet-api.voi.nodly.io/genesis &&\
sudo chown algorand:algorand /var/lib/algorand/genesis.json
sleep 1
sudo cp /lib/systemd/system/algorand.service /etc/systemd/system/voi.service &&\
sudo sed -i 's/Algorand daemon/Voi daemon/g' /etc/systemd/system/voi.service
sleep 1

# Start Node VOI
echo -e "\e[1m\e[32m6. Start Node VOI... \e[0m" && sleep 1
sudo systemctl start voi && sudo systemctl enable voi
goal node catchup $(curl -s https://testnet-api.voi.nodly.io/v2/status|jq -r '.["last-catchpoint"]')
sleep 1
goal node status -w 1000
sleep 3600
sudo ALGORAND_DATA=/var/lib/algorand diagcfg telemetry name -n $Nodename
sleep 1
sudo ALGORAND_DATA=/var/lib/algorand diagcfg telemetry enable &&\
sudo systemctl restart voi
sleep 1

# Create wallet or Recovery wallet
echo -e "\e[1m\e[32m6. Create wallet or Recovery wallet... \e[0m" && sleep 1
SelectVersion="Please choose: \n 1. Create wallet (Gives you 60 seconds to save the seed wallet)\n 2. Recovery wallet"
echo -e "${SelectVersion}"
read -p "Enter index: " version;
if [ "$version" != "2" ];then
	goal wallet new $walletname
    sleep 60
else
	goal wallet new -r $walletname
fi
sleep 1

# To create a new account or Recovery account
echo -e "\e[1m\e[32m7. Create wallet or Recovery wallet... \e[0m" && sleep 1
SelectVersion="Please choose: \n 1. Create account (Gives you 60 seconds to save the address wallet)\n 2. Recovery account"
echo -e "${SelectVersion}"
read -p "Enter index: " version;
if [ "$version" != "2" ];then
	goal account new
    sleep 60
else
	goal wallet import
fi
sleep 1

# Goal account export
echo -e "\e[1m\e[32m7. Goal account export... \e[0m" && sleep 1
echo -ne "\nEnter your voi address (Gives you 60 seconds to save the seed account: " && read addr &&\
goal account export -a $addr
sleep 60

# Generate your participation keys
echo -e "\e[1m\e[32m7. Generate your participation keys... \e[0m" && sleep 1
getaddress() {
  if [ "$addr" == "" ]; then echo -ne "\nNote: Completing this will remember your address until you log out. "; else echo -ne "\nNote: Using previously entered address. "; fi; echo -e "To forget the address, press Ctrl+C and enter the command:\n\tunset addr\n";
  count=0; while ! (echo "$addr" | grep -E "^[A-Z2-7]{58}$" > /dev/null); do
    if [ $count -gt 0 ]; then echo "Invalid address, please try again."; fi
    echo -ne "\nEnter your voi address: "; read addr;
    addr=$(echo "$addr" | sed 's/ *$//g'); count=$((count+1));
  done; echo "Using address: $addr"
}
getaddress &&\
echo -ne "\nEnter duration in rounds [Fill: 8000000 and ENTER)]: " && read duration &&\
start=$(goal node status | grep "Last committed block:" | cut -d\  -f4) &&\
duration=${duration:-2000000} &&\
end=$((start + duration)) &&\
dilution=$(echo "sqrt($end - $start)" | bc) &&\
goal account addpartkey -a $addr --roundFirstValid $start --roundLastValid $end --keyDilution $dilution
sleep 1

# Check your participation status
echo -e "\e[1m\e[32m8. Check your participation status... \e[0m" && sleep 1
getaddress() {
  if [ "$addr" == "" ]; then echo -ne "\nNote: Completing this will remember your address until you log out. "; else echo -ne "\nNote: Using previously entered address. "; fi; echo -e "To forget the address, press Ctrl+C and enter the command:\n\tunset addr\n";
  count=0; while ! (echo "$addr" | grep -E "^[A-Z2-7]{58}$" > /dev/null); do
    if [ $count -gt 0 ]; then echo "Invalid address, please try again."; fi
    echo -ne "\nEnter your voi address: "; read addr;
    addr=$(echo "$addr" | sed 's/ *$//g'); count=$((count+1));
  done; echo "Using address: $addr"
}
getaddress &&\
goal account dump -a $addr | jq -r 'if (.onl == 1) then "You are online!" else "You are offline." end'

cd $HOME
rm $HOME/voi-auto.sh

# Please Faucet
echo -e "\e[1;32mLink faucet: \e[0m\e[1;36mhttps://discord.gg/voinetwork\e[0m"
