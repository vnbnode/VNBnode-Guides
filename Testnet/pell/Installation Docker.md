# Testnest

| System Required | Minimum Hardwares |
| --- | --- |
| CPUS |  4 CPUs |
| Memory | 8 GB Memory |
| Data Disk | 200+ GB Data Disk |
| RPC | 	26657 |
| REST API | 1317 |
| gRPC | 9090 |
| Prometheus| 26660 |
## Update & Upgrade
```bash
sudo apt update && sudo apt upgrade -y
```
## Install Dockers
```
export DOCKER_API_VERSION=1.41
```
```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```
```
sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```
```
sudo usermod -aG docker ${USER}
```
```
newgrp docker
```
```
docker --version
```
## Login to download docker image
```
docker login -u pellnetwork
```
#Password:
```
Paste The private password here
```
Pull the latest Pell Node image:
```
docker pull docker.io/pellnetwork/pellnode:v1.0.23-ignite-testnet
```
## Run node
change "Yournode"
```
docker run -d --name=pell-validator \
    -v /root/.pellcored:/root/.pellcored \
    -e MONIKER="Yournode" \
    -p 26656:26656 \
    -p 26660:26660 \
    -d \
    --entrypoint /usr/local/bin/start-pellcored.sh \
    docker.io/pellnetwork/pellnode:v1.0.23-ignite-testnet
```
## Enter the Docker container environment
```
docker exec -it pell-validator /bin/bash
```
#create your wallet
```
pellcored keys add wallet
```
#retrieve your wallet
```
pellcored keys show wallet
```
Check balances.
```
pellcored query bank balances wallet
```
## Set Validator Info
```

cat > ./validator.json << EOF
{
	"pubkey": $(pellcored tendermint show-validator),
	"amount": "1000000000000000000apell",
	"moniker": "Adam_VNBnode",
	"identity": "06F5F34BD54AA6C7",
	"website": "https://vnbnode.com",
	"security": "validator's (optional) security contact email",
	"details": "VNBnode is a group of professional validators / developers in blockchain",
	"commission-rate": "0.1",
	"commission-max-rate": "0.2",
	"commission-max-change-rate": "0.01",
	"min-self-delegation": "1"
}
EOF
```
## Create Validator
```
pellcored tx staking create-validator ./validator.json \
--chain-id=ignite_186-1 \
--fees=0.000001pell \
--gas=1000000 \
--from=wallet
```
## Check status of your validator
```
pellcored query staking validator $(pellcored keys show wallet --bech val -a)
```
## Check logs
```
docker logs pell-validator
```
## Check synchs
```
curl http://localhost:26657/status | jq .result.sync_info
```
## Get validator info
```
curl http://localhost:26657/status | jq .result.validator_info
```
## Check node info
```
pellcored status 2>&1 | jq
```
## Check active validators info

https://testnet.pell.explorers.guru/validators

