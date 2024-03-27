## Snapshot
_Stop Node and Reset Data_
```
sudo systemctl stop dymension
cp $HOME/.dymension/data/priv_validator_state.json $HOME/.dymension/priv_validator_state.json.backup
rm -rf $HOME/.dymension/data && mkdir -p $HOME/.dymension/data
```
_Download Snapshot_
```
curl -L https://snap.vnbnode.com/dymension/dymension_1100-1_snapshot_latest.tar.lz4 | tar -I lz4 -xf - -C $HOME/.dymension/data
```
```
mv $HOME/.dymension/priv_validator_state.json.backup $HOME/.dymension/data/priv_validator_state.json
```
_Restart Node_
```
sudo systemctl start dymension.service && sudo journalctl -u dymension -f --no-hostname -o cat
```
