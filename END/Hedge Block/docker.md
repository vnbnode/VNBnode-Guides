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
mkdir hedge
curl -Ls https://raw.githubusercontent.com/vnbnode/binaries/main/Projects/Hedge/.env > $HOME/hedge/.env
```

### Setup Node
```
docker run -d -p 1290:1290 -p 1257:1257 -p 1256:1256 -p 1217:1217 -v $HOME/hedge:/root/hedge --env-file $HOME/hedge/.env  --name hedge hedgeblock/berberis:v0.1
```

### Configure
```
docker stop hedge
sed -i -e "s|^seeds *=.*|seeds = \"86c1be378070c100aa614e47c6abe4978d91f4d7@rpc-t.hedge.nodestake.org:666\"|" $HOME/hedge/berberis-1/config/config.toml
sed -i -e 's|^persistent_peers *=.*|persistent_peers ="9b4c775424e0f1a57bf47dff99c0f65ad75a7acb@84.247.135.4:11856,e2ee3820cc5301a36b5a25f81e2debaaac4ac211@135.181.130.103:11856,aee371f8457fc1f712982f6f9b79750f7a7f3e2e@89.58.58.195:12656,bbf8ef70a32c3248a30ab10b2bff399e73c6e03c@65.21.198.100:24056,c7c80f0f5b6dfe4837abd6a7eab4c8342e5c2a95@65.109.115.56:11856,2c6ae886df41b08b6361de953ad44c6f574afb05@51.178.92.69:12656,1a160c270b03c7d81b1acaec3e58240c551b83ae@14.161.28.247:26656,e17e1afbd58c6262c6d6a8c991b4a1e570d6c1c4@84.247.128.239:26656,09689645c883cab940b65695874d7e68d08ee76c@168.119.11.176:26656,15cbe08525e6aa988ee64acddd59a04c295e25f8@31.220.74.78:26656,1145e1f9e1be00c654b5368ce03932f481c599cb@65.21.17.15:12656,d21aacf53a8811900058043af47ad9eac9ff2741@161.97.132.248:12656,fd5ef6b9dade0d036208fb734ccb6349c2a5a6dd@217.76.56.229:19656,760d7921d74dc75d06e7e6dbd44509092eb8387f@37.60.226.183:10656,6710c70956dd763160a2cacb932fb135dcb1de86@152.53.46.144:12656"|' $HOME/hedge/berberis-1/config/config.toml
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
echo 'export hedge="12"' >> ~/.bash_profile
source $HOME/.bash_profile
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://0.0.0.0:${hedge}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://0.0.0.0:${hedge}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${hedge}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${hedge}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${hedge}60\"%" $HOME/hedge/berberis-1/config/config.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${hedge}17\"%; s%^address = \":8080\"%address = \":${hedge}80\"%; s%^address = \"localhost:9090\"%address = \"0.0.0.0:${hedge}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${hedge}91\"%; s%:8545%:${hedge}45%; s%:8546%:${hedge}46%; s%:6065%:${hedge}65%" $HOME/hedge/berberis-1/config/app.toml
hedged config node tcp://localhost:${hedge}57
```

### Snapshot
```
cp $HOME/hedge/berberis-1/data/priv_validator_state.json $HOME/hedge/priv_validator_state.json.backup
rm -r $HOME/hedge/wasm
curl -o - -L https://snapshot-de-1.genznodes.dev/hedgeblock/hedge-testnet-1509189.tar.lz4 | lz4 -c -d - | tar -x -C $HOME/hedge
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
