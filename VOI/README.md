# <p align="center"> VOI Network </p>
<p align="center">
  <img height="100" height="auto" src="/VOI/voi.jpg?raw=true">
</p>

### 1/ Need install software and its updates
```
sudo apt install -y jq bc gnupg2 curl software-properties-common
curl -o - https://releases.algorand.com/key.pub | sudo tee /etc/apt/trusted.gpg.d/algorand.asc
sudo add-apt-repository "deb [arch=amd64] https://releases.algorand.com/deb/ stable main"
```
![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/1fb9bf1d-8d3c-4ee8-9def-ba151d1b56b9)
- Select ENTER
### 2/ Install Node Algorand
```
sudo apt update && sudo apt install -y algorand && echo OK
```
### 3/ Stop Node Algorand
```
sudo systemctl stop algorand && sudo systemctl disable algorand && echo OK
```
### 4/ Setup goal
```
echo -e "\nexport ALGORAND_DATA=/var/lib/algorand/" >> ~/.bashrc && source ~/.bashrc && echo OK
```
### 5/ Configure Node VOI
```
sudo algocfg set -p DNSBootstrapID -v "<network>.voi.network" -d /var/lib/algorand/ &&\
sudo algocfg set -p EnableCatchupFromArchiveServers -v true -d /var/lib/algorand/ &&\
sudo chown algorand:algorand /var/lib/algorand/config.json &&\
sudo chmod g+w /var/lib/algorand/config.json &&\
echo OK
```
```
sudo curl -s -o /var/lib/algorand/genesis.json https://testnet-api.voi.nodly.io/genesis &&\
sudo chown algorand:algorand /var/lib/algorand/genesis.json &&\
echo OK
```
```
sudo cp /lib/systemd/system/algorand.service /etc/systemd/system/voi.service &&\
sudo sed -i 's/Algorand daemon/Voi daemon/g' /etc/systemd/system/voi.service &&\
echo OK
```
### 6/ Start Node VOI
```
sudo systemctl start voi && sudo systemctl enable voi && echo OK
```
### 7/ Check Status
```
goal node status
```
### 8/ Get catch up with the network
```
goal node catchup $(curl -s https://testnet-api.voi.nodly.io/v2/status|jq -r '.["last-catchpoint"]') &&\
echo OK
```
### 9/ Wait for catchup to complete:
```
goal node status -w 1000
```
### 10/ Enable Telemetry Node Name
```
sudo ALGORAND_DATA=/var/lib/algorand diagcfg telemetry name -n Nodename
```
```
sudo ALGORAND_DATA=/var/lib/algorand diagcfg telemetry enable &&\
sudo systemctl restart voi
```
### 11/ Create Wallet
```
goal wallet new voi
```
### 12/ To create a new account
```
goal account new
```

### 13/ Save
```
echo -ne "\nEnter your voi address: " && read addr &&\
goal account export -a $addr
```
### 14/ Generate your participation keys:
```
getaddress() {
  if [ "$addr" == "" ]; then echo -ne "\nNote: Completing this will remember your address until you log out. "; else echo -ne "\nNote: Using previously entered address. "; fi; echo -e "To forget the address, press Ctrl+C and enter the command:\n\tunset addr\n";
  count=0; while ! (echo "$addr" | grep -E "^[A-Z2-7]{58}$" > /dev/null); do
    if [ $count -gt 0 ]; then echo "Invalid address, please try again."; fi
    echo -ne "\nEnter your voi address: "; read addr;
    addr=$(echo "$addr" | sed 's/ *$//g'); count=$((count+1));
  done; echo "Using address: $addr"
}
getaddress &&\
echo -ne "\nEnter duration in rounds [press ENTER to accept default)]: " && read duration &&\
start=$(goal node status | grep "Last committed block:" | cut -d\  -f4) &&\
duration=${duration:-2000000} &&\
end=$((start + duration)) &&\
dilution=$(echo "sqrt($end - $start)" | bc) &&\
goal account addpartkey -a $addr --roundFirstValid $start --roundLastValid $end --keyDilution $dilution
```
- Fill: 8000000
### 15/ Check your participation status
```
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
```
### 16/You can register your account as participating:
[Faucet](https://discord.gg/voinetwork)
```
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
```
### 17/ Faucet again
### 18/ Check
- Explorer: https://voi.observer/explorer/home    
- https://cswenor.github.io/voi-proposer-data/health.html
- https://voi-node-info.boeieruurd.com/
