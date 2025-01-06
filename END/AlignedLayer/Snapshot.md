|  Pruning      |       Indexer          |
| :---------: | :-----------------------:|
|   **100/0/10**   |        null          |
## Snapshot (Updated daily)
_Stop Node and Reset Date_
```
sudo systemctl stop alignedlayer

cp $HOME/.alignedlayer/data/priv_validator_state.json $HOME/.alignedlayer/priv_validator_state.json.backup

rm -rf $HOME/.alignedlayer/data && mkdir -p $HOME/.alignedlayer/data
```
_Download Snapshot_
```
curl -L https://snap.vnbnode.com/alignedlayer/alignedlayer_snapshot_latest.tar.lz4 | tar -I lz4 -xf - -C $HOME/.alignedlayer/data
mv $HOME/.alignedlayer/priv_validator_state.json.backup $HOME/.alignedlayer/data/priv_validator_state.json
```
_Restart Node_
```
sudo systemctl restart alignedlayer && sudo journalctl -u alignedlayer -f --no-hostname -o cat
```
