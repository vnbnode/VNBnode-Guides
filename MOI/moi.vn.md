# MOI (Guardian Node)

## Cấu hình khuyến nghị

|   Thông số  |        Khuyến nghị        |
| :---------: | :-----------------------: |
|   **CPU**   | 4 Cores (ARM64 or x86-64) |
|   **RAM**   |        16 GB (DDR4)       |
|   **SSD**   |           512 GB          |
| **NETWORK** |          500 Mbps         |

* Đây là cấu hình khuyến nghị mà dự án đề ra.

## Tạo tài khoản

### Step 1: Tạo tài khoản MOI ID từ IOMe
*   Truy cập [**IOMe Login Page**](https://iome.ai/login/), để tạo tài khoản.

    ![Login with IOMe](https://docs.moi.technology/assets/images/iome-login-b3874e62852d1a3f48a47fbb5feb9ff6.png)
*   Nhập `username` và `password`. Sau đó, bạn sẽ được chuyển hướng đến phần `Cụm từ khôi phục bí mật`.

    ![Secret Recovery Generation](https://docs.moi.technology/assets/images/secret-recovery-89743716e6600f1f7d3fdc34a7b1ea65.png)
* Chọn `Create secret recovery phrase for me`, để tạo cụm từ bí mật.\
  ![Secret Recovery Backup](https://docs.moi.technology/assets/images/recovery-backup-abbb0c28b9b1c5e9ae05e9259e17f756.png)
* Sau khi tạo xong cụm từ bí mật, lưu nó lại và chọn `I've copied` để hoàn tất.

### Step 2: KYC tài khoản MOI ID
*   Đăng nhập vào tài khoản `IOMe Account` và tiến hành `KYC` theo ảnh bên dưới.

    ![KYC Prompt](https://docs.moi.technology/assets/images/kyc-prompt-8d1e96b8804f791bb15818d44301dc1c.png)
* Sau khi hoàn tất quá trình `KYC`, quá trình xác minh có thể mất một chút thời gian. Sau khi xác minh xong, bạn có thể sử dụng tài khoản vừa kích hoạt này để đăng nhập và sử dụng [MOI Voyage](https://voyage.moi.technology/).

### Step 3: Tạo Krama ID trên MOI Voyage
* Truy cập [MOI Voyage](https://voyage.moi.technology/)
*   Đăng nhập bằng tài khoản `IOMe` bạn vừa tạo.

    ![Login to MOI Voyage](https://docs.moi.technology/assets/images/voyage-login-377cf38b6787fe0f073643916f95121a.gif)
*   Chọn `Guardians`.

    ![Guardians Page](https://docs.moi.technology/assets/images/voyage-guardians-nav-60c468c00e96344d0ed95ebac7e5a17c.png)
*   Chọn `Become a Guardian` để tiến hành tạo Krama ID.

    ![Become a Guardian](https://docs.moi.technology/assets/images/become-guardian-967292760efe12da6192719e6d026f00.gif)![Waitlist Guardians](https://docs.moi.technology/assets/images/waitlist-guardian-1d0e291d54f2d86b5f251d01fa2496aa.png)![Approved Guardian](https://docs.moi.technology/assets/images/approved-guardian-f8552b6581b5ff581cce49c9db50e097.png)
* Truy cập [Discord](https://discord.gg/x4SnJwHk7A) để nhờ MOD Approved Krama ID.
*   Tải xuống `Keystore`, điền `password` vào và `download`.

    ![Download Keystore](https://docs.moi.technology/assets/images/download-keystore-9e17e6ca9121b7a76d6bf3d363eb75ad.gif)

## Option 1: Automatic
``` 
cd $HOME && mkdir moi && cd moi
```
- Download keystore.json --> $HOME/moi/keystore.json
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/MOI/moi-auto.sh)
```
## Option 2: Manual
### Cài đặt Docker

```
sudo apt update && sudo apt upgrade -y
sudo apt-get update
sudo apt-get install \
ca-certificates \
curl \
gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### Tiến hành mở các cổng trên Router

<table><thead><tr><th width="130">Transport</th><th width="76" align="center">Port</th><th width="179">Reachability</th><th>Purpose</th></tr></thead><tbody><tr><td>TCP/UDP</td><td align="center">6000</td><td>Inbound/Outbound</td><td>Protocol P2P Interface</td></tr><tr><td>TCP</td><td align="center">1600</td><td>Inbound</td><td>JSON RPC Interface</td></tr></tbody></table>

### Register the Guardian Node <a href="#register-the-guardian-node" id="register-the-guardian-node"></a>
#### 1\. CPU from 2015 or later
```
sudo docker run --network host --rm -it -w /data -v $(pwd):/data sarvalabs/moipod:latest register --data-dir {DIRPATH} --mnemonic-keystore-path {KEYSTORE_PATH} --mnemonic-keystore-password {MNEMONIC_KEYSTORE_PASSWORD} --watchdog-url https://babylon-watchdog.moi.technology/add --node-password {NODE_PWD} --network-rpc-url https://voyage-rpc.moi.technology/babylon --wallet-address {ADDRESS} --node-index {NODE_IDX} --local-rpc-url http://{IP_or_Domain}:1600
```
#### 2\. CPU from 2015 or earlier
```
sudo docker run --network host --rm -it -w /data -v $(pwd):/data sarvalabs/moipod:v0.5.0-port register --data-dir {DIRPATH} --mnemonic-keystore-path {KEYSTORE_PATH} --mnemonic-keystore-password {MNEMONIC_KEYSTORE_PASSWORD} --watchdog-url https://babylon-watchdog.moi.technology/add --node-password {NODE_PWD} --network-rpc-url https://voyage-rpc.moi.technology/babylon --wallet-address {ADDRESS} --node-index {NODE_IDX} --local-rpc-url http://{IP_or_Domain}:1600
```
`{DIRPATH}`: đường dẫn thư mục bạn tạo để lưu trữ node, ví dụ `moi`

`{KEYSTORE_PATH}`: đường dẫn file keystore mà bạn đã tải lúc tạo Krama ID, ví dụ nếu bạn cho keystore vào trong thư mục moi thì đường dẫn sẽ là `moi/keystore.json`

`{MNEMONIC_KEYSTORE_PASSWORD}`: password lúc bạn điền vào để download file keystore.json về

`{NODE_PWD}`: password lúc bạn điền vào để download file keystore.json về

`{ADDRESS}`: Lấy địa chỉ ví của bạn tại đây [MOI Voyage](https://voyage.moi.technology/)

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/455c4157-0eba-48a9-963b-509a91756acd)

`{NODE_IDX}`: muốn khởi chạy Krama ID số bao nhiêu thì nhập số đó vào

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/c25e9a5a-2087-4487-a710-9cab7890359a)

`{IP_or_Domain}`: đây là địa chỉ IP WAN để kết nối ra bên ngoài, có thể thay thế bằng địa chỉ ddns. Khuyến khích dùng dịch vụ [NoIP](https://www.noip.com/).

### Start the Guardian Node <a href="#start-the-guardian-node" id="start-the-guardian-node"></a>
#### 1\. CPU from 2015 or later
```
sudo docker run --network host -it -d -w /data -v $(pwd):/data sarvalabs/moipod:latest server --babylon --data-dir {DIRPATH} --log-level DEBUG --node-password {NODE_PWD}
```
#### 2\. CPU from 2015 or earlier
```
sudo docker run --network host -it -d -w /data -v $(pwd):/data sarvalabs/moipod:v0.5.0-port server --babylon --data-dir {DIRPATH} --log-level DEBUG --node-password {NODE_PWD}
```
`{DIRPATH}`: đường dẫn thư mục bạn tạo để lưu trữ node, ví dụ `moi`

`{NODE_PWD}`: có thể đặt password giống như lúc tải file keystore về

## Check Status Node

* Nếu Status hiển thị trạng thái: `Up xx minutes` là node đã chạy thành công.
* Nếu Status hiển thị trạng thái: `Exited` là lúc khởi chạy đã bị lỗi.

<table><thead><tr><th width="112">Container ID</th><th width="80">Image</th><th width="121">Command</th><th width="93">Created</th><th width="83">Status</th><th width="81">Ports</th><th>Names</th></tr></thead><tbody><tr><td>f00f11223344</td><td>my-image</td><td>"/bin/bash"</td><td>10 minutes ago</td><td>Up 10 minutes</td><td></td><td>my-container</td></tr></tbody></table>

## List command

* Kiểm tra các node đang chạy trên docker

```
docker ps -a
```

* Thay đổi tên container

```
docker rename <container_names> <name new>
```

* Check logs của container

<pre><code><strong>docker logs -f &#x3C;container_names>
</strong></code></pre>

* Lệnh này dùng để tự động restart lại node khi máy tính khởi động lại

```
docker update --restart=unless-stopped <container_names>
```

* Kiểm tra logs bên trong thư mục của node
* `moi`/log/3\*: thay đổi thư mục `moi` thành tên `moi1` hoặc `moi2` để kiểm tra logs của các node `moi` khác

```
tail -f moi/log/3*
```

## Upgrading Moipod[**​**](https://docs.moi.technology/docs/guard/guardian-faq#2-stop-the-current-container)

* Dừng các container moi

```
docker stop <container_name>
```

* Xóa tất cả container moi[**​**](https://docs.moi.technology/docs/guard/guardian-faq#3-remove-unnecessary-containers-and-images)

```
docker container prune
```

* Pull image version mới nhất về

```
docker container prune
```

* Chạy lại node
#### 1\. CPU from 2015 or later
```
sudo docker run --network host -it -d -w /data -v $(pwd):/data sarvalabs/moipod:latest server --babylon --data-dir {DIRPATH} --log-level DEBUG --node-password {NODE_PWD}
```
#### 2\. CPU from 2015 or earlier
```
sudo docker run --network host -it -d -w /data -v $(pwd):/data sarvalabs/moipod:v0.5.0-port server --babylon --data-dir {DIRPATH} --log-level DEBUG --node-password {NODE_PWD}
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
