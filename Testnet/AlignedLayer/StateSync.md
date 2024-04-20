## Reset blockchain data
### Make sure backup your priv_validator_state.json before reset
```
sudo systemctl stop alignedlayer
cp $HOME/.alignedlayer/data/priv_validator_state.json $HOME/.alignedlayer/priv_validator_state.json.backup
alignedlayerd tendermint unsafe-reset-all --keep-addr-book --home $HOME/.alignedlayer
```
### Configure State Sync
```
SNAP_RPC="http://109.199.118.239:24257"
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
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" ~/.alignedlayer/config/config.toml
more ~/.alignedlayer/config/config.toml | grep 'rpc_servers'
more ~/.alignedlayer/config/config.toml | grep 'trust_height'
more ~/.alignedlayer/config/config.toml | grep 'trust_hash'
```
## Backup state data
### Return state file to the previous location
```
mv $HOME/.alignedlayer/priv_validator_state.json.backup $HOME/.alignedlayer/data/priv_validator_state.json
```
### Restart your nodes after perform a state sync
```
sudo systemctl start alignedlayer && sudo journalctl -fu alignedlayer -o cat
```