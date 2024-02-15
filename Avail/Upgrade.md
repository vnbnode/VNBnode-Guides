## Guide to upgrade Avail binaries to v1.11.0.0 (Latest version)
```php
cd $Home
cd avail
```
### Stop Service
```php
sudo systemctl stop availd.service
```
### Download
```php
git pull
```
```php
git checkout v1.11.0.0
```
### Install
```php
cargo run --locked --release -- --chain goldberg  --validator -d ./output
```
![image](https://github.com/vnbnode/VNBnode-Guides/assets/128967122/b3b5ecb9-e74e-4883-9c24-e544c991d4cc)

### Enable service
```php
sudo systemctl disable availd.service 
sudo systemctl daemon-reload
sudo systemctl enable availd.service 
```
### Restart and Check status
```php
sudo service availd restart
```
### Check logs
```php
journalctl -f -u availd
```

## Guide to upgrade Avail binaries to v1.10.0.0 (old version)
```php
cd $Home
cd avail
```
### Stop Service
```php
sudo systemctl stop availd.service
```
### Download
```php
git pull
```
```php
git checkout v1.10.0.0
```
### Install
```php
cargo run --locked --release -- --chain goldberg  --validator -d ./output
```
### Remove rocksdb and Network
```php
cd $Home
rm -r /output/chains/avail_goldberg_testnet/db/*
rm -r /output/chains/avail_goldberg_testnet/network/*
```
### Download snapshot
```php
curl -o - -L http://snapshots.staking4all.org/snapshots/avail/latest/avail.tar.lz4 | lz4 -c -d - | tar -x -C /output/chains/avail_goldberg_testnet/
```
### Add peers
###### Remember to change your node's name correctly.
```php
sudo nano /etc/systemd/system/availd.service
```
###### Add the following flag
```php
--reserved-nodes \
"/dns/bootnode-001.goldberg.avail.tools/tcp/30333/p2p/12D3KooWCVqFvrP3UJ1S338Gb8SHvEQ1xpENLb45Dbynk4hu1XGN" \
"/dns/bootnode-002.goldberg.avail.tools/tcp/30333/p2p/12D3KooWD6sWeWCG5Z1qhejhkPk9Rob5h75wYmPB6MUoPo7br58m" \
"/dns/bootnode-003.goldberg.avail.tools/tcp/30333/p2p/12D3KooWMR9ZoAVWJv6ahraVzUCfacNbFKk7ABoWxVL3fJ3XXGDw" \
"/dns/bootnode-004.goldberg.avail.tools/tcp/30333/p2p/12D3KooWMuyLE3aPQ82HTWuPUCjiP764ebQrZvGUzxrYGuXWZJZV" \
"/dns/bootnode-005.goldberg.avail.tools/tcp/30333/p2p/12D3KooWKJwbdcZ7QWcPLHy3EJ1UiffaLGnNBMffeK8AqRVWBZA1" \
"/dns/bootnode-006.goldberg.avail.tools/tcp/30333/p2p/12D3KooWM8AaHDH8SJvg6bq4CGQyHvW2LH7DCHbdv633dsrti7i5" \
--reserved-only
```
### Enable service
```php
sudo systemctl disable availd.service 
sudo systemctl daemon-reload
sudo systemctl enable availd.service 
```
### Restart and Check status
```php
sudo service availd restart
```
### Check logs
```php
journalctl -f -u availd
```
![image](https://github.com/vnbnode/VNBnode-Guides/assets/128967122/9760b907-3c83-44c1-ae70-f1f5baf3c203)


## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
