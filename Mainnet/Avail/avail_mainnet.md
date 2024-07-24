**Step 1: Update and install packages for compiling**
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/update-binary.sh)
```
**Step 2: Install Rust**
```php
curl https://sh.rustup.rs -sSf | sh
```

Select 1 and enter

**Step 3: Go to home**
```php
source $HOME/.cargo/env
```

**Step 4: Update rust**
```php
rustup update nightly
```

**Step 5: Add tools**
```php
rustup target add wasm32-unknown-unknown --toolchain nightly
```
**Step 6: Access Avail folder**
```php
mkdir avail
cd avail
```
**Step 7: Download Binary**
```
wget https://github.com/availproject/avail/releases/download/v2.2.4.1/x86_64-ubuntu-2204-avail-node.tar.gz
```
**Step 8: Extract**
```
tar -xf x86_64-ubuntu-2204-avail-node.tar.gz
```
**Step 9: run node**
```php
./avail-node --chain mainnet --name "Yourname_VNBnode" --validator -d ./node-data
```
CTRL + C to escape

**Step 10: Edit service file**
```php
sudo nano /etc/systemd/system/availd.service
```
*Copy and Paste the content of service file as:*
*Replace yourname in “Yourname_VNBnode”.*
```php
[Unit]
Description=Avail Validator
After=network.target
StartLimitIntervalSec=0
[Service]
User=root
ExecStart= /root/avail/avail-node -d /root/avail/node-data --chain mainnet --validator --name "✅Your-Name|VNBnode✅"
Restart=always
RestartSec=120
[Install]
WantedBy=multi-user.target
```
**Step 11: Enable the service file**
```php
sudo systemctl daemon-reload
sudo systemctl enable availd.service
```

**Step 12: Start service file**
```php
sudo systemctl start availd.service
```

**Step 13: Check status of service**
```php
sudo systemctl status availd.service
```
**Step 14: Check logs**
```php
journalctl -f -u availd
```
