# Hedge Block
Chain ID: `berberis-1`

## Recommended Hardware Requirements

|   SPEC      |       Recommend       |       Minimum        |
| :---------: | :--------------------:|:--------------------:|
|   **CPU**   |        8 Cores        |        4 Cores       |
|   **RAM**   |        32 GB          |        16 GB         |
|   **SSD**   |        200 GB         |        200 GB        |
| **NETWORK** |        100 Mbps       |        100 Mbps      |
| **Port**    |        10256          |

### Update and install packages for compiling
```
cd $HOME && source <(curl -s https://raw.githubusercontent.com/vnbnode/binaries/main/docker-install.sh)
```

### Build binary
```
cd $HOME
mkdir .hedged
curl -Ls https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Hedge/.env > $HOME/hedge/.env
```

### Setup Node
```
docker run -d -p 10290:10290 -p 10257:10257 -p 10256:10256 -p 10217:10217 -v $HOME/hedge:/root/hedge --env-file $HOME/hedge/.env  --name hedge hedgeblock/berberis:v0.1
```

### Configure
```
docker stop hedge
sed -i -e "s|^seeds *=.*|seeds = \"86c1be378070c100aa614e47c6abe4978d91f4d7@rpc-t.hedge.nodestake.org:666\"|" $HOME/hedge/berberis-1/config/config.toml
sed -i -e 's|^persistent_peers *=.*|persistent_peers ="b2a0bfb93d98e62802ec21eac60eaf11f17354d8@89.117.145.86:11856,b5d5226ac957b8b384644e0aa2736be4b40f806c@46.38.232.86:14656,70f7dc74d3b6afa12b988d61707229e8e191d9a2@213.246.45.16:55656,7f53c0fba561febc278e00334a7d9af8d155c538@109.199.97.149:26656,e17e1afbd58c6262c6d6a8c991b4a1e570d6c1c4@84.247.128.239:26656,cd0c25fcfca4e8fc17a22f2bb6cec4923d078fd3@27.66.100.4:26656,56147d1f212f01bc68bec8161d537d93900d3414@45.85.147.82:11856,a5ce7811bc2a19e20b7ce1da0635f738ed9969ac@44.193.5.65:26656,e4ad93631cdb9da1015dd46347c5e7c34bb762c1@84.247.147.224:26656"|' $HOME/hedge/berberis-1/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.025uhedge\"|" $HOME/hedge/berberis-1/config/app.toml
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "19"|' \
  $HOME/hedge/berberis-1/config/app.toml
```

### Custom Port
```
echo 'export hedge="102"' >> ~/.bash_profile
source $HOME/.bash_profile
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://0.0.0.0:${hedge}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${hedge}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${hedge}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${hedge}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${hedge}60\"%" $HOME/hedge/berberis-1/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${hedge}17\"%; s%^address = \":8080\"%address = \":${hedge}80\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:${hedge}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${hedge}91\"%; s%:8545%:${hedge}45%; s%:8546%:${hedge}46%; s%:6065%:${hedge}65%" $HOME/hedge/berberis-1/config/app.toml
hedged config node tcp://localhost:${hedge}57
```

### Snapshot
```
cp $HOME/hedge/berberis-1/data/priv_validator_state.json $HOME/hedge/priv_validator_state.json.backup
rm -rf $HOME/hedge/berberis-1/data
curl -L https://snap.nodex.one/hedge-testnet/hedge-latest.tar.lz4 | tar -Ilz4 -xf - -C $HOME/hedge/berberis-1
mv $HOME/hedge/priv_validator_state.json.backup $HOME/hedge/berberis-1/data/priv_validator_state.json
```

### Start Node
```
docker restart hedge
docker logs -f hedge
```

### Backup Node
```
mkdir -p $HOME/backup/hedge
cp $HOME/hedge/berberis-1/config/priv_validator_key.json $HOME/backup/hedge
```

### Remove Node
```
docker stop hedge
docker rm hedge
rm -rf $HOME/hedge
```

## Thank to support VNBnode.
### Visit us at:

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/VNBnodegroup" target="_blank">VNBnodegroup</a>

<img src="https://user-images.githubusercontent.com/50621007/183283867-56b4d69f-bc6e-4939-b00a-72aa019d1aea.png" width="30"/> <a href="https://t.me/Vnbnode" target="_blank">VNBnode News</a>

<img src="https://github.com/vnbnode/binaries/blob/main/Logo/VNBnode.jpg" width="30"/> <a href="https://VNBnode.com" target="_blank">VNBnode.com</a>
