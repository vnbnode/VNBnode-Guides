# Titan Edge
## Install Docker
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/docker-install.sh)
```
## Single Node
```
docker run --name titan --network=host -d -v ~/.titan:/root/.titanedge nezha123/titan-edge:latest
docker run --rm -it -v ~/.titan:/root/.titanedge nezha123/titan-edge:latest config set --storage-size=20GB
docker run --rm -it -v ~/.titan:/root/.titanedge nezha123/titan-edge:latest config set --listen-address 0.0.0.0:1234
docker update --restart=unless-stopped titan
docker restart titan
```
## Binding Node
https://test1.titannet.io/newoverview/activationcodemanagement

![image](https://github.com/user-attachments/assets/251829a8-5815-469e-abb4-6ada76bb9956)

```
docker run --rm -it -v ~/.titan:/root/.titanedge nezha123/titan-edge:latest bind --hash=xxx https://api-test1.container1.titannet.io/api/v2/device/binding
```
## Multi Node: Max 5
### Node 1
```
docker run --name titan1 --network=host -d -v ~/.titan1:/root/.titanedge nezha123/titan-edge:latest
docker run --rm -it -v ~/.titan:/root/.titanedge nezha123/titan-edge:latest config set --storage-size=20GB
docker run --rm -it -v ~/.titan:/root/.titanedge nezha123/titan-edge:latest config set --listen-address 0.0.0.0:1234
docker update --restart=unless-stopped titan1
docker restart titan1
```
### Node 2
```
docker run --name titan2 --network=host -d -v ~/.titan2:/root/.titanedge nezha123/titan-edge:latest
docker run --rm -it -v ~/.titan2:/root/.titanedge nezha123/titan-edge:latest config set --storage-size=20GB
docker run --rm -it -v ~/.titan2:/root/.titanedge nezha123/titan-edge:latest config set --listen-address 0.0.0.0:1235
docker update --restart=unless-stopped titan2
docker restart titan2
```
### Node 3
```
docker run --name titan3 --network=host -d -v ~/.titan3:/root/.titanedge nezha123/titan-edge:latest
docker run --rm -it -v ~/.titan3:/root/.titanedge nezha123/titan-edge:latest config set --storage-size=20GB
docker run --rm -it -v ~/.titan3:/root/.titanedge nezha123/titan-edge:latest config set --listen-address 0.0.0.0:1236
docker update --restart=unless-stopped titan3
docker restart titan3
```
### Node 4
```
docker run --name titan4 --network=host -d -v ~/.titan4:/root/.titanedge nezha123/titan-edge:latest
docker run --rm -it -v ~/.titan5:/root/.titanedge nezha123/titan-edge:latest config set --storage-size=20GB
docker run --rm -it -v ~/.titan4:/root/.titanedge nezha123/titan-edge:latest config set --listen-address 0.0.0.0:1237
docker update --restart=unless-stopped titan4
docker restart titan4
```
### Node 5
```
docker run --name titan5 --network=host -d -v ~/.titan5:/root/.titanedge nezha123/titan-edge:latest
docker run --rm -it -v ~/.titan5:/root/.titanedge nezha123/titan-edge:latest config set --storage-size=20GB
docker run --rm -it -v ~/.titan5:/root/.titanedge nezha123/titan-edge:latest config set --listen-address 0.0.0.0:1238
docker update --restart=unless-stopped titan5
docker restart titan5
```

