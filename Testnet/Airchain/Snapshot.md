## Snapshot (Automatically updates daily)
_Stop Node and Reset Date_
```
sudo systemctl stop junction
cp $HOME/.junction/data/priv_validator_state.json $HOME/.junction/priv_validator_state.json.backup
rm -rf $HOME/.junction/data && mkdir -p $HOME/.junction/data
```
_Download Snapshot_ (auto daily update)
```
curl -L https://snap.vnbnode.com/airchain/junction_snapshot_latest.tar.lz4 | tar -I lz4 -xf - -C $HOME/.junction/data
```
```
mv $HOME/.junction/priv_validator_state.json.backup $HOME/.junction/data/priv_validator_state.json
```
_Restart Node_
```
sudo systemctl restart junction && sudo journalctl -u junction -f --no-hostname -o cat
```
