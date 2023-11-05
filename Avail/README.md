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



