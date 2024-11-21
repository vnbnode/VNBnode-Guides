## Recommended Hardware Requirements 

|   SPEC	    |         Node              |   
| :---------: | :-----------------------: |   
|   **CPU**   |        ≥ 8 Cores          |      
|   **RAM**   |        ≥ 16 GB            |
| **Storage** |        ≥ 1 TB SSD         |  
| **NETWORK** |        ≥ 100 Mbps         |  

## WARNING:
### This guide is just used for testnet purpose.
### Do not send any private key wallet - with your fund.
### Just use a fresh new wallet to testnet.

### 1st Step buy a domain & setting DNS follow this example:
![image](https://github.com/vnbnode/VNBnode-Guides/assets/128967122/c71485f4-4dfc-4873-b390-ba48ca2f7045)

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
