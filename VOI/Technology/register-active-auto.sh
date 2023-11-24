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

# Register and Active Participating
echo -e "\e[1m\e[32m11. Register and Active Participating... \e[0m" && sleep 1
cd $HOME
getaddress() {
  if [ "$addr" == "" ]; then echo -ne "\nNote: Completing this will remember your address until you log out. "; else echo -ne "\nNote: Using previously entered address. "; fi; echo -e "To forget the address, press Ctrl+C and enter the command:\n\tunset addr\n";
  count=0; while ! (echo "$addr" | grep -E "^[A-Z2-7]{58}$" > /dev/null); do
    if [ $count -gt 0 ]; then echo "Invalid address, please try again."; fi
    echo -ne "\nEnter your voi address: "; read addr;
    addr=$(echo "$addr" | sed 's/ *$//g'); count=$((count+1));
  done; echo "Using address: $addr"
}
getaddress &&\
goal account changeonlinestatus -a $addr -o=1 &&\
sleep 1 &&\
goal account dump -a $addr | jq -r 'if (.onl == 1) then "You are online!" else "You are offline." end'
sleep 1

cd $HOME
rm $HOME/register-active-auto.sh

# Faucet again
echo -e "\e[1m\e[32mPlease Faucet again \e[0m" && sleep 1

# Link check status
echo -e "\e[1;32mExplorer: \e[0m\e[1;36mhttps://voi.observer/explorer/home\e[0m"
echo -e "\e[1;32mCheck status: \e[0m\e[1;36mhttps://cswenor.github.io/voi-proposer-data/health.html\e[0m"
echo -e "\e[1;32mCheck reward: \e[0m\e[1;36mhttps://voi-node-info.boeieruurd.com/\e[0m"

# Command check
echo -e "\e[1;32mView the logs from the running: \e[0m\e[1;36mgoal node status -w 1000\e[0m"
