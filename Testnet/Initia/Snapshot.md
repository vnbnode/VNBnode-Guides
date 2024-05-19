## Snapshot (Automatically updates daily)
_Stop Node and Reset Date_
```
sudo systemctl stop initia
cp $HOME/.initia/data/priv_validator_state.json $HOME/.initia/priv_validator_state.json.backup
rm -rf $HOME/.initia/data && mkdir -p $HOME/.initia/data
```
_Download Snapshot_
```
curl -L https://snap.vnbnode.com/initia/initation-1_snapshot_latest.tar.lz4 | tar -I lz4 -xf - -C $HOME/.initia/data
```
```
mv $HOME/.initia/priv_validator_state.json.backup $HOME/.initia/data/priv_validator_state.json
```
_Restart Node_
```
systemctl restart initia && journalctl -u initia -f -o cat
```
