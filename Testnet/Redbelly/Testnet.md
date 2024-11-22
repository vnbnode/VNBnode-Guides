# REDBELLY TESTNET
## Website: https://www.redbelly.network/
## X.com: https://x.com/RedbellyNetwork

# Preparation
## Recommended Hardware Requirements 

|   SPEC	    |         Node              |   
| :---------: | :-----------------------: |   
|   **CPU**   |        ≥ 8 Cores          |      
|   **RAM**   |        ≥ 16 GB            |
| **Storage** |        ≥ 1 TB SSD         |  
| **NETWORK** |        ≥ 100 Mbps         |  
| **OS** |         ≥ Ubuntu 22.04.1 LTS         |  
| **PORTS** |        8545, 8546, 1111, and 1888         |  


## WARNING:
### This guide is just used for testnet purpose.
### Do not send any private key wallet - with your fund.
### Just use a fresh new wallet to testnet.

## 1st Step buy a domain & setting DNS follow this example:
![image](https://github.com/vnbnode/VNBnode-Guides/assets/128967122/c71485f4-4dfc-4873-b390-ba48ca2f7045)

### Check your DNS setting 
```
nslookup <YOUR_DNS_NAME_WITHOUT_HTTPS>
```
![image](https://github.com/user-attachments/assets/885e817f-6d70-4378-8d0b-4f9d4e58c2fe)

## BEFORE START, MAKE SURE YOU GOT EMAIL FROM REDBELLY TEAM & USING YOUR REGISTERED EMAIL TO ACCESS TO:
https://vine.redbelly.network/nds-node-register

# Part 1: Installation

## 1. Update system and install build tools
```
sudo apt update
sudo apt install snapd
sudo snap install core; sudo snap refresh core
sudo apt install net-tools
```
## 2. Install cert bot
```
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
netstat -an | grep 80
```
## 3. Download "rbn-installer.run" file and copy to $HOME/root/
```
THIS STEP IS ONLY FOR AUTHORIZED VALIDATORS - WHO RECEIVED EMAIL
```
## 4. Firewall setup
```
sudo ufw enable
sudo ufw allow 80
sudo ufw allow 22
sudo ufw allow 1888
sudo ufw allow 1111
sudo ufw allow 8545
sudo ufw allow 8546
```
## 5. Make files executable
```
chmod +x rbn-installer.run
```
## 6. Install node
```
sudo ./rbn-installer.run
```
### You need to have:
DNS without https://

Email

Node ID

Once success, you will see the service file installed:
<img width="952" alt="image" src="https://github.com/user-attachments/assets/db147b69-ecd6-4c64-8f93-088cddcfc83d">

# Part 2: Usefull commands

### Check the status of node
```
pgrep rbbc
# result should be a number
```

### Check the status of the process
```
journalctl -u redbelly.service
```

### Check the status of the Redbelly service
```
sudo systemctl status redbelly.service
```
### Check logs
```
tail -f /var/log/redbelly/rbn_logs/rbbc_logs.log
```
<img width="956" alt="image" src="https://github.com/user-attachments/assets/c344a4c2-a0a7-4fb3-b38e-262c57a16ceb">

### Check the error logs
```
tail -f  /var/log/redbelly/rbn_logs/rbbc_logs_error.log
```
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnode Inside</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
