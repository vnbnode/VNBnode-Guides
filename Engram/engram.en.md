# Run Node Engram

## Option 1: Automatic

## Option 2: Manual
## I\. Run Node
### 1\. Update
```
sudo apt update && sudo apt upgrade -y
```

### 2\. Package
```
sudo apt install curl tar wget clang pkg-config protobuf-compiler libssl-dev jq build-essential protobuf-compiler bsdmainutils git make ncdu gcc git jq chrony liblz4-tool -y
```

### 3\. Install Docker
```
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

### 4\. SETUP
```
git clone --recursive https://github.com/engram-network/tokio-docker.git && cd tokio-docker && chmod +x ./scripts/*.sh && bash ./scripts/init-dependency.sh && mkdir -p execution consensus validator
```

### 5\. Edit file `docker-compose.yml`
```
nano docker-compose.yml
```
```
identity=avenbreaks << Replace with your discord username (e.g: avenbreaks. don't add your hastag discord user)
enr-address=0.0.0.0 << Replace with your public IPAddress
graffiti=engram-labs << Replace with your unique name
```

### 6\. Run
```
docker compose up -d
```
You will see the following:
```
$ docker compose up -d
[+] Running 4/4
 ⠿ Network tokio_default_default                           Created
 ⠿ Container striatum_init                                 Started
 ⠿ Container striatum_el                                   Started
 ⠿ Container lighthouse_cl                                 Started
```

### 7\. Check logs
```
docker logs striatum_el -f
```
- see on striatum_el:
```
INFO [09-26|19:28:45.046] Forkchoice requested sync to new head    number=30729 hash=a38be3..648659 finalized=30652
INFO [09-26|19:28:57.045] Forkchoice requested sync to new head    number=30730 hash=eb3642..45f557 finalized=30652
INFO [09-26|19:29:09.046] Forkchoice requested sync to new head    number=30731 hash=b9fd32..3748bd finalized=30652
INFO [09-26|19:29:21.046] Forkchoice requested sync to new head    number=30732 hash=51ff7b..803756 finalized=30652
INFO [09-26|19:29:33.046] Forkchoice requested sync to new head    number=30733 hash=f80ac7..19e5f7 finalized=30652
```
```
docker logs lighthouse_cl -f
```
- see on lighthouse_cl:
```
INFO Subscribed to topics
INFO Sync state updated      new_state: Evaluating known peers, old_state: Syncing Finalized Chain, service: sync
INFO Sync state updated      new_state: Syncing Head Chain, old_state: Evaluating known peers, service: sync
INFO Sync state updated      new_state: Synced, old_state: Syncing Head Chain, service: sync
INFO Subscribed to topics    topics: ["/eth2/9c4e948f/bls_to_execution_change/ssz_snappy"]
```

## II\. Engram Network Validator Node Setup