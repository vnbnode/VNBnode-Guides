### 1. Register for validators Avail:
[Click this link](https://docs.google.com/forms/d/e/1FAIpQLScpwE8yuUkqJVQrVpLRqua5p8oA8DGUBYho9Rwjm1bmG8LebQ/viewform?ref=blog.availproject.org)
### 2. Hardware required
**This is the hardware configuration required to set up an Avail full node:**

![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/5f43fa88-fd00-4ec1-97d6-2535929801bf)

**Step 1: Update system**
```php
sudo apt update && sudo apt upgrade -y
```
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/63be3627-1663-4e66-931a-1e2d11f20d4b)

**Step 2: Install packages**
```php
sudo apt install make clang pkg-config libssl-dev build-essential git screen protobuf-compiler -y
```
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/17f8fcb7-eebe-4f99-a796-166ba3671bfa)

**Step 3: Install Rust**
```php
curl https://sh.rustup.rs -sSf | sh
```
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/96afa55d-b165-4a63-9723-4fc90653021f)

**Select 1 and enter**
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/9e49c1f3-31e1-4edc-a0c3-7a4402619c0d)

**Step 4: Go to home**
```php
source $HOME/.cargo/env
```
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/a45b90a3-7197-4a6e-a174-cc1b23ec1c48)

**Step 5: Update rust**
```php
rustup update nightly
```
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/ac301aa9-2633-470e-8596-28fdecbb2435)

**Step 6: Add tools**
```php
rustup target add wasm32-unknown-unknown --toolchain nightly
```
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/a9683eb9-2f02-49b7-8fe0-605cf4f5af2a)

**Step 7: Clone avail.git**
```php
git clone https://github.com/availproject/avail.git
```
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/b06318f0-00b8-4e41-8caf-7c568d1d2924)

**Step 8: Access Avail folder**
```php
cd avail
```

**Step 9: Build data**
```php
cargo build --release -p data-avail
```
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/96390bb0-df57-4d5f-83df-63241a57b704)
*This step takes long time to finish, be patient!*

**Step 10: Make output folder**
```php
mkdir -p output
```
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/6ee1e07b-1162-4696-bb78-8a4beb77bd73)

**Step 11: Switch git**
```php
git checkout v1.7.2
```
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/b7556554-51f9-443c-9b34-5585336a6a5d)

**Step 12: Run**
```php
cargo run --locked --release -- --chain kate -d ./output
```
*This step also takes time, be patient! Once it finished, you will see this screen:*
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/122cc330-0234-4ed2-8f2e-cafe1caa75e1)
*Then you can escape by ctrl + c*

**Step 13: Create service file**
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/e1e88af4-f8de-4d16-a16b-4469bc3c1e62)

**Step 14: Edit service file**
```php
sudo nano /etc/systemd/system/availd.service
```
*you will see this screen*
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/d27ebd0c-d3f5-4064-bd24-9f940488aa07)
*Copy and Paste the content of service file as:*
*Replace “VNBnode” by “Yourname_VNBnode”.*
```php
[Unit]
Description=Avail Validator
After=network.target
StartLimitIntervalSec=0
[Service]
User=root
ExecStart= /root/avail/target/release/data-avail --base-path `pwd`/data --chain kate --name "VNBnode_Founder"
Restart=always
RestartSec=120
[Install]
WantedBy=multi-user.target
```

**Step 15: Enable the service file**
```php
sudo systemctl enable availd.service
```
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/e0653656-1542-4f56-9ef2-10d187c19131)

**Step 16: Start service file**
```php
sudo systemctl start availd.service
```
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/fad7b4e6-5ae4-4c92-bc76-6f33c82a1ce3)

**Step 17: Check status of service**
```php
sudo systemctl status availd.service
```
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/9cc1f7a1-69e8-4e0c-b813-34450ed81b99)

**Step 18: Check logs**
```php
journalctl -f -u availd
```
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/087883e8-65f8-44a8-80b7-69207cb596cd)

**Step 19: Stake as validator**
*Follow the instruction from project:* [Link](https://docs.availproject.org/operate/validator/staking/)

**Step 20: Check your node name here** [Here](https://telemetry.avail.tools/#list/0xd12003ac837853b062aaccca5ce87ac4838c48447e41db4a3dcfb5bf312350c6)
![image](https://github.com/vnbnode/Running-Nodes/assets/128967122/7b35733a-20fc-47a8-a600-5a9a08d2dbda)



