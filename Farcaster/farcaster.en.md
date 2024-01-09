![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/2ab91d3e-dc35-49fe-b899-8594e85adcc6)
# Run Farcaster Hubble
## Hardware requirements

|   Thông số  |        Khuyến nghị        |
| :---------: | :-----------------------: |
|   **CPU**   |        ≥ 2 Cores          |
|   **RAM**   |        ≥ 8 GB             |
|   **SSD**   |        ≥ 20 GB            |

## Download App Warpcast
### 1. [Down Here](https://warpcast.com/~/download)

### 2. Pay the $9/year fee to create an account
- Android: 219,000 VND
- IOS: 229,000 VND
  
### 3. Then, get the FID on Warpcast to prepare to run the node.

Step 1: Go to your Warpcast account.

Step 2: Go to your personal page.

Step 3: Get the FID in the About section as shown below.

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/a448bdf8-746b-4a7d-aa03-bbe42db0c476)

## Set up RPC in Alchemy
### Create an account on Alchemy
Use your Gmail to register an account here: [https://www.alchemy.com/](https://alchemy.com/?r=d9e42f283d9e2fbe)
### Create Farcaster Hubble app
Create the Farcaster Hubble app on the Ethereum mainnet

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/7fd3e7ad-f373-4a41-bade-566c76dfd7db)

Create the Farcaster Hubble app on the Optimism mainnet

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/29b4e797-c828-42df-928e-51f21c0dcdc3)

Get API keys information for both Ethereum and Optimism.

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/a23f74c0-0d04-4ce5-8c76-27db2dfa9528)

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/d8d83a13-def1-4b82-9920-ddd96403322f)

- Please copy both the Ethereum mainnet and Optimism mainnet APIs to prepare for the next step
## Run Node Farcaster
```
curl -sSL https://download.thehubble.xyz/bootstrap.sh | bash
```
![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/21dcae06-997c-4733-b645-9da0912eed5b)
## Auto Restart
```
docker update --restart=unless-stopped hubble-hubble-1
docker update --restart=unless-stopped hubble-statsd-1
docker update --restart=unless-stopped hubble-grafana-1
```
## Visit Hubble Dashboard
- `https://IP VPS:3000`

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/c088b73a-07a0-423a-a6e4-51471824d2c8)

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
