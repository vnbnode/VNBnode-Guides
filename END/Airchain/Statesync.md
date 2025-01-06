### Reset blockchain data
Make sure backup your priv_validator_state.json before reset
```
sudo systemctl stop junction
cp $HOME/.junction/data/priv_validator_state.json $HOME/.junction/priv_validator_state.json.backup
junctiond tendermint unsafe-reset-all --keep-addr-book --home $HOME/.junction
```
### Configure State Sync
```
SNAP_RPC="https://rpc-airchain.vnbnode.com"
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash)
```
```
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH
```
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \

s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \

s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \

s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.junction/config/config.toml

more ~/.junction/config/config.toml | grep 'rpc_servers'

more ~/.junction/config/config.toml | grep 'trust_height'

more ~/.junction/config/config.toml | grep 'trust_hash'
```
### Backup state data
Return state file to the previous location
```
mv $HOME/.junction/priv_validator_state.json.backup $HOME/.junction/data/priv_validator_state.json
```
### Restart your nodes after perform a state sync
```
sudo systemctl start junction && sudo journalctl -fu junction -o cat
```
