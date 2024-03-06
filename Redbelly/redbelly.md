## WARNING:
### This guide is just used for testnet purpose.
### Do not send any private key wallet - with your fund.
### Just use a fresh new wallet to testnet.

### 1st Step buy a domain & setting DNS follow this example:
![image](https://github.com/vnbnode/VNBnode-Guides/assets/128967122/c71485f4-4dfc-4873-b390-ba48ca2f7045)

## Part 1: Automatic Install Redbelly node
```
cd $HOME && curl -o auto-run.sh https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Redbelly/auto-run.sh && bash auto-run.sh
```
## Part 2: Usefull commands
### Check status of node
```
pgrep rbbc
# result should be a number
```
### Check logs
```
cat ./logs/rbbcLogs
```
or
```
tail -f $HOME/logs/rbbcLogs
```
## Trouble Shoot
### Handshake TLS Error
```
pgrep rbbc
# you will see a NUMBER (if your node was running before)
```
```
kill NUMBER
```
```
# RUN AGAIN
./start-rbn.sh
```
### Renew certificate
```
sudo systemctl stop apache2
```
```
sudo certbot certonly --standalone -d YOUR-DOMAIN. --non-interactive --agree-tos -m YOUR-EMAIL
```
```
sudo certbot certificates
```
```
pgrep rbbc
# you will see a NUMBER (if your node was running before)
```
```
kill NUMBER
```
```
# RUN AGAIN
./start-rbn.sh
```
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
