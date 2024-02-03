### Guide to upgrade Avail binaries to v1.10.0.0
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
rm -r output/chains/avail_goldberg_testnet/db/*
rm -r output/chains/avail_goldberg_testnet/network/*
```
### Download snapshot
```php
curl -o - -L https://snapshots.avail.nexus/goldberg/avail_goldberg_testnet_snapshot_jan_31.tar.gz | tar -xz -C output/chains/avail_goldberg_testnet/
```
### Add peers
```php
sudo sed -i 's|ExecStart=.*|ExecStart= /root/avail/target/release/data-avail -d ./output --validator --name "✅ Your-Name|VNBnode ✅" --chain goldberg \\\n--reserved-nodes \\\n"/dns/bootnode-001.goldberg.avail.tools/tcp/30333/p2p/12D3KooWCVqFvrP3UJ1S338Gb8SHvEQ1xpENLb45Dbynk4hu1XGN" \\\n"/dns/bootnode-002.goldberg.avail.tools/tcp/30333/p2p/12D3KooWD6sWeWCG5Z1qhejhkPk9Rob5h75wYmPB6MUoPo7br58m" \\\n"/dns/bootnode-003.goldberg.avail.tools/tcp/30333/p2p/12D3KooWMR9ZoAVWJv6ahraVzUCfacNbFKk7ABoWxVL3fJ3XXGDw" \\\n"/dns/bootnode-004.goldberg.avail.tools/tcp/30333/p2p/12D3KooWMuyLE3aPQ82HTWuPUCjiP764ebQrZvGUzxrYGuXWZJZV" \\\n"/dns/bootnode-005.goldberg.avail.tools/tcp/30333/p2p/12D3KooWKJwbdcZ7QWcPLHy3EJ1UiffaLGnNBMffeK8AqRVWBZA1" \\\n"/dns/bootnode-006.goldberg.avail.tools/tcp/30333/p2p/12D3KooWM8AaHDH8SJvg6bq4CGQyHvW2LH7DCHbdv633dsrti7i5" \\\n--reserved-only|; s|Restart=.*|Restart=always|; s|RestartSec=.*|RestartSec=120|' /etc/systemd/system/availd.service 
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
![image](https://github.com/vnbnode/VNBnode-Guides/assets/128967122/90da0394-f17b-4ddf-9064-e73729e6cad7)

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
