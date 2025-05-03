## 🚀 **Tanssi Operator Node Setup**
### **1. Hardware Requirements**

| Component | Recommended Specs                              |
| --------- | ---------------------------------------------- |
| CPU       | 8 cores @ 3.4GHz (Intel Ice Lake+ / AMD Zen3+) |
| RAM       | 32 GB ECC                                      |
| Storage   | 500 GB NVMe SSD                                |
| Network   | 1 Gbps                                         |
| Open Port | TCP 30333                                      |

✅ Disable Hyperthreading/SMT.

### **2. Install & Prepare**

```bash
sudo dmesg | grep landlock || journalctl -kg landlock   # Check Landlock

wget https://github.com/moondance-labs/tanssi/releases/download/v0.12.0/tanssi-relay
wget https://github.com/moondance-labs/tanssi/releases/download/v0.12.0/tanssi-relay-execute-worker
wget https://github.com/moondance-labs/tanssi/releases/download/v0.12.0/tanssi-relay-prepare-worker
chmod +x ./tanssi-relay*

adduser tanssi_service --system --no-create-home
mkdir /var/lib/tanssi-data
chown -R tanssi_service /var/lib/tanssi-data
mv ./tanssi-relay* /var/lib/tanssi-data
```
### **3. Generate Node Key**

```bash
/var/lib/tanssi-data/tanssi-relay key generate-node-key --file /var/lib/tanssi-data/node-key
```
### **4. Create systemd service**

```bash
sudo nano /etc/systemd/system/tanssi.service
```

Paste this (replace **NODE\_NAME** and **YOUR\_IP**):

```ini
[Unit]
Description=Tanssi Validator
After=network.target

[Service]
User=tanssi_service
Type=simple
Restart=always
ExecStart=/var/lib/tanssi-data/tanssi-relay --chain=dancelight \
  --base-path=/var/lib/tanssi-data \
  --node-key-file=/var/lib/tanssi-data/node-key \
  --database=paritydb \
  --rpc-port=9944 \
  --prometheus-port=9615 \
  --prometheus-external \
  --name=NODE_NAME \
  --listen-addr=/ip4/0.0.0.0/tcp/30333 \
  --public-addr=/ip4/YOUR_IP/tcp/30333 \
  --state-pruning=archive \
  --blocks-pruning=archive \
  --telemetry-url='wss://telemetry.polkadot.io/submit/ 0' \
  --validator

[Install]
WantedBy=multi-user.target
```
### **5. Enable & Start**

```bash
sudo systemctl enable tanssi.service
sudo systemctl start tanssi.service
sudo systemctl status tanssi.service
journalctl -f -u tanssi.service
```
### **6. Setup Account & Map Session Keys**

✅ **Generate session keys:**

```bash
curl http://127.0.0.1:9944 -H "Content-Type:application/json" -d '{"jsonrpc":"2.0","id":1,"method":"author_rotateKeys","params":[]}'
```
Copy the **"result"** hex string.
✅ **Map keys to your account:**
![image](https://github.com/user-attachments/assets/26b2fcee-53f9-40d0-9a97-5c9b5489c99d)
1. Go to https://polkadot.js.org/apps/?rpc=wss://dancelight.tanssi-api.network#/extrinsics
2. Navigate to **Developer → Extrinsics**
3. Select your validator account
4. Module: **session**
5. Extrinsic: **setKeys**
6. Keys: paste the session keys
7. Proof: `0x`
8. Submit the transaction → sign with wallet

✅ **Verify mapping:**
1. Go to **Developer → Chain state**
2. Module: **session**
3. Query: **keyOwner**
4. Key type: `gran`
5. Bytes: first **66 characters** of your session key (e.g., `0xabc123...`)
6. Click **+** → your validator account should be displayed.
### **7. Register in Symbiotic (via MetaMask & Etherscan)**
1. Go to Contract (Sepolia)

https://sepolia.etherscan.io/address/0x6F75a4ffF97326A00e52662d82EA4FdE86a2C548#writeContract
![image](https://github.com/user-attachments/assets/67970c09-03c6-4ffd-b8a9-feb4b074a44e)
2. Connect Wallet
* Click **“Connect to Web3”**
* Select **MetaMask** (make sure MetaMask is on **Sepolia network**)

✅ Confirm connection.

3. Register Operator
![image](https://github.com/user-attachments/assets/13f7c621-3802-44be-b805-0cfedee022c3)
* Find **`registerOperator()`** function
* Click **“Write”**
* Confirm the transaction in MetaMask

✅ You’ve submitted the registration.

4. Check Registration Status
  ![image](https://github.com/user-attachments/assets/136e97bc-0b78-431c-8af7-e910684c185e)
* Go to **“Read Contract”** tab
* Find **`isEntity()`**
* Enter your wallet address
* Click **“Query”**
→ Returns **true** = registration successful.
### **8. Opt In to Tanssi (via MetaMask & Etherscan)**
1. Opt In to Vault
2. 
👉 Open contract:

https://sepolia.etherscan.io/address/0x95CC0a052ae33941877c9619835A233D21D57351#writeContract
![image](https://github.com/user-attachments/assets/44d564d7-6fb6-41a2-9772-87f62f8010a4)

✅ Click **“Connect to Web3”** → choose **MetaMask (Sepolia network)**

✅ Find **`optin(address)`** function

→ Enter vault address:
`0xB94f8852443FB4faB18363D22a45cA64a8CF4482`

✅ Click **“Write”** → confirm transaction in MetaMask

Done ✅

3. Check Opt In Status

👉 Open contract:

https://sepolia.etherscan.io/address/0x95CC0a052ae33941877c9619835A233D21D57351#readContract
![image](https://github.com/user-attachments/assets/6622c367-eff5-4a3d-aa2a-d8f3cae3680a)

✅ Find **`isOptedIn(address who, address where)`**

→ `who`: your wallet address
→ `where`: `0xB94f8852443FB4faB18363D22a45cA64a8CF4482`
→ Click **“Query”**

✅ Result **true** = Opted in

4. Opt In to Tanssi Network

👉 Open contract:

https://sepolia.etherscan.io/address/0x58973d16FFA900D11fC22e5e2B6840d9f7e13401#writeContract

✅ **Connect Web3** (MetaMask, Sepolia)

✅ Find **`optin(address)`** function

→ Enter network address:
`0xdaD051447C4452e15B35B7F831ceE8DEb890f1a4`

✅ Click **“Write”** → confirm transaction in MetaMask

Done ✅

6. Check the Registration Status:

👉 Open contract:

https://sepolia.etherscan.io/address/0x58973d16FFA900D11fC22e5e2B6840d9f7e13401#readContract
![image](https://github.com/user-attachments/assets/7b147a76-4aa4-4c25-ae8b-c68ba1bb7af4)

✅ Find **`isOptedIn(address who, address where)`**

→ `who`: your wallet address
→ `where`: `0xdaD051447C4452e15B35B7F831ceE8DEb890f1a4`
→ Click **“Query”**

✅ Result **true** = Opted in

### **9. Deposit**
1. Wrap ETH to stETH
👉 Go to Lido Sepolia (testnet):

https://stake-sepolia.testnet.fi/

✅ Swap desired amount of Sepolia ETH → stETH

✅ Confirm transaction in MetaMask

3. Approve Vault to Spend stETH
👉 Open Collateral contract on Etherscan:

https://sepolia.etherscan.io/address/0x3e3FE7dBc6B4C189E7128855dD526361c49b40Af#writeContract
![image](https://github.com/user-attachments/assets/0b6274d4-14df-4af0-8e69-d00bde67599a)

✅ Connect Web3

✅ Find approve(address spender, uint256 amount)

→ spender:
`0xB94f8852443FB4faB18363D22a45cA64a8CF4482`
→ amount: (your deposit amount in wei)

✅ Click “Write”, confirm in MetaMask

4. Deposit to Vault
👉 Open Vault contract on Etherscan:

https://sepolia.etherscan.io/address/0xB94f8852443FB4faB18363D22a45cA64a8CF4482#writeProxyContract
![Screenshot 2025-05-03 142151](https://github.com/user-attachments/assets/d9120ee7-8201-4f8c-9730-147850d9db57)

✅ Connect Web3

✅ Find deposit(address operator, uint256 amount)

→ operator: your wallet address
→ amount: deposit amount (in wei)

✅ Click “Write”, confirm in MetaMask

🎉 Done! You’re opted in and have deposited collateral to the Vault for Tanssi (Sepolia testnet).
