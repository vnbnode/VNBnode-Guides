# Run Avail Docker v1.8.0.2 (Goldberg)
<p align="center">
  <img height="100" height="auto" src="/Avail/avail.png?raw=true">
</p>

## Recommended Hardware Requirements 
Minimum
>- 4GB RAM
>- 2core CPU (amd64/x86 architecture)
>- 20-40 GB Storage (SSD)

Recommended
>- 8GB RAM
>- 4core CPU (amd64/x86 architecture)
>- 200-300 GB Storage (SSD)

## Option 1 (Automatic)
```

```
## Option 2 (Manual)
### 1/ Pull image new 
```
docker pull availj/avail:v1.8.0.2
```
### 2/ Run node
```
sudo docker run -v $(pwd)/root/avail/state:/da/state:rw -v $(pwd)/root/avail/keystore:/da/keystore:rw -e DA_CHAIN=goldberg --name avail -e DA_NAME=<Fill Node name of you> -p 0.0.0.0:30333:30333 -p 9615:9615 -p 9933:9933 -d --restart unless-stopped availj/avail:v1.8.0.2
```
### 3/ Run validator on Docker
```
cd /root/avail && wget https://raw.githubusercontent.com/vnbnode/VNBnode-Guides/main/Avail/validator.sh && bash validator.sh
```
### 4/ Check log node
```
docker logs avail -f
```
## Update new version

### 1/ Stop node
```
docker stop avail
```
### 2/ Remove node
```
docker rm avail
```
### 3/ Update new version
```
docker pull availj/avail:v1.8.0.2
```
### 4/ Run node
```
sudo docker run -v $(pwd)/state:/da/state:rw -v $(pwd)/keystore:/da/keystore:rw -e DA_CHAIN=goldberg --name avail -e DA_NAME=<Fill Node name of you> -p 0.0.0.0:30333:30333 -p 9615:9615 -p 9933:9933 -d --restart unless-stopped availj/avail:v1.8.0.2
```
### 5/ Check log node
```
docker logs avail -f
```
