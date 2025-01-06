### Recommended Hardware Requirements

|   SPEC      |       Recommend          |
| :---------: | :-----------------------:|
|   **CPU**   |        1 Cores           |
|   **RAM**   |        500 Mb Ram        |
| **Storage** |        40 GB SSD         |

## Choose Tmux or Systemd.
### Run with Tmux
```
sudo apt install tmux
tmux
curl -sL1 https://nubit.sh | bash
```
### Detach from the tmux session without stopping the processes:
- Press Ctrl + b, then d.
### Run with Systemd
#### Create the systemd service file:
```
sudo tee /etc/systemd/system/nubitlight.service > /dev/null <<EOF
[Unit]
Description=Nubit Light Service
After=network.target

[Service]
Type=simple
Environment="HOME=/root"
ExecStart=/bin/bash -c 'curl -sL1 https://nubit.sh | bash'
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
```
```
sudo systemctl daemon-reload
sudo systemctl enable nubitlight.service
```
#### Start service & check logs
```
sudo systemctl start nubitlight.service && journalctl -u nubitlight.service -f
```
- Please save MNEMONIC, PUBKEY and AUTHKEY after run service
![image](https://github.com/vnbnode/VNBnode-Guides/assets/40466326/5cb06916-aea0-4e1a-be84-2a9e186f067b)
### Export seed phrase
```
cat $HOME/nubit-node/mnemonic.txt
```
### List all keys:
```
$HOME/nubit-node/bin/nkey list --p2p.network nubit-alphatestnet-1 --node.type light
```
### Import the new key
```
$HOME/nubit-node/bin/nkey add my_nubit_key --recover --keyring-backend test --node.type light --p2p.network nubit-alphatestnet-1
```
### Delete the selected key
```
$HOME/nubit-node/bin/nkey delete my_nubit_key -f --node.type light --p2p.network nubit-alphatestnet-1
```
### Uninstall nubit-node
```
rm -rf $HOME/nubit-node
rm -rf $HOME/.nubit-light-nubit-alphatestnet-1
```
### Link claim point
https://alpha.nubit.org/
