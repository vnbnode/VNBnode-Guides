# Guide to run Light Client Avail Goldberg (Lastest Version 1.7.10)
<p align="center">
  <img height="100" height="auto" src="https://github.com/vnbnode/binaries/blob/main/Projects/Avail/avail.png?raw=true">
</p>

## Recommended Hardware Requirements 
![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/7449170a-c03a-4502-8ffb-26455e413e33)

### OPTION 1: Automatic installation from binaries
```
cd $HOME && curl -o lightnode-autorun.sh https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Avail/lightnode-autorun.sh  && bash lightnode-autorun.sh
```
### OPTION 2: Automatic installation from Avail releases
```
cd $HOME && curl -o lightclient-pre-auto.sh https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Avail/lightclient-pre-auto.sh  && bash lightclient-pre-auto.sh
```
### Upgrade version

```
cd $HOME
systemctl stop availd.service
rm-rf /root/avail-light
git clone https://github.com/availproject/avail-light.git
cd avail-light
git checkout v1.7.10
cargo build --release
systemctl restart availd.service && journalctl -f -u availd
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
