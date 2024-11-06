## Verifier Guide
### 1. Run a quick setup to obtain the **AccountId** and **PublicKey**.
```
curl -O https://raw.githubusercontent.com/vnbnode/binaries/refs/heads/main/Projects/Nillion/verifier.sh && chmod +x verifier.sh && ./verifier.sh
```
### 2. Go to the [link](https://verifier.nillion.com/) to add nillion-chain-testnet-1 network, get the wallet address, and visit [this link](https://faucet.testnet.nillion.com/) for the faucet.
### 3. Return to the [verifier.nillion.com](https://verifier.nillion.com/) page, select Verifier — Setup for Linux, and choose step 5: Initialising the verifier.
![image](https://github.com/user-attachments/assets/88215c1c-ebba-47d9-80f1-5e1760be3869)
![image](https://github.com/user-attachments/assets/a97e4996-af48-468f-9e35-492844c02dda)
![image](https://github.com/user-attachments/assets/54493a43-194e-40d2-be6f-c4f29b3dec02)
### 4. Here, you will need the **AccountId** and **PublicKey** that you received during the first setup step, fill in the corresponding fields and sign the transaction.
![image](https://github.com/user-attachments/assets/9da00dd4-4278-4a21-86d9-a7c853909a43)
![image](https://github.com/user-attachments/assets/e3944f5a-bc28-4a5f-acbd-3165b76dca37)
### 5. Go to the [faucet link](https://faucet.testnet.nillion.com/) and request tokens for the **AccountId** address you obtained during the initial setup.
![image](https://github.com/user-attachments/assets/f10d4bcc-9e5e-41bf-87ff-a92055782904)
### 6. Run the verifier: _WAIT 30-60 MINUTES_ before proceeding. Secret verification requires a delay before full registration.
```
docker run -d --name nillion -v $HOME/nillion/verifier:/var/tmp nillion/verifier:v1.0.1 verify --rpc-endpoint "https://testnet-nillion-rpc.lavenderfive.com"
```
### Commands
#### Check the node logs:
```
sudo docker logs -f nillion --tail=100
```
#### Restart the node:
```
sudo docker restart nillion
```
#### Stop the node:
```
sudo docker stop nillion
```
#### Remove the node:
```
sudo docker rm nillion
```
