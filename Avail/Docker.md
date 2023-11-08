# Run Avail Docker

## Version 1.8.0.0 (Goldberg)

### 1/ Pull image new 
```
docker pull availj/avail:v1.8.0.0
```
### 2/ Run node
```
sudo docker run -v $(pwd)/state:/da/state:rw -v $(pwd)/keystore:/da/keystore:rw -e DA_CHAIN=goldberg --name avail -e DA_NAME=<Fill Node name of you> -p 0.0.0.0:30333:30333 -p 9615:9615 -p 9933:9933 -d --restart unless-stopped availj/avail:v1.8.0.0
```
### 3/ Check log node
```
docker logs avail -f
```

## Update Pactus

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
docker pull ............
```
### 4/ Run node
```
sudo docker run -v $(pwd)/state:/da/state:rw -v $(pwd)/keystore:/da/keystore:rw -e DA_CHAIN=goldberg --name avail -e DA_NAME=<Fill Node name of you> -p 0.0.0.0:30333:30333 -p 9615:9615 -p 9933:9933 -d --restart unless-stopped availj/avail:v1.8.0.0
```
### 5/ Check log node
```
docker logs avail -f
```
