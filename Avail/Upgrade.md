### Guide to upgrade Avail binaries from V1.8.0.3 to V1.9.0.0
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
git checkout v1.9.0.0
```
### Install
```php
cargo run --locked --release -- --chain goldberg  --validator -d ./output
```
### Restart and Check status
```php
sudo service availd restart
systemctl status availd.service
```
## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
