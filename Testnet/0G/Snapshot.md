## Snapshot (Automatically updates daily)
_Stop Node and Reset Date_
```
sudo systemctl stop og
cp $HOME/.0gchain/data/priv_validator_state.json $HOME/.0gchain/priv_validator_state.json.backup
rm -rf $HOME/.0gchain/data && mkdir -p $HOME/.0gchain/data
```
_Download Snapshot_ (auto daily update)
```
curl -L https://snap.vnbnode.com/0g/zgtendermint_16600-1_snapshot_latest.tar.lz4 | tar -I lz4 -xf - -C $HOME/.0gchain/data
```
```
mv $HOME/.0gchain/priv_validator_state.json.backup $HOME/.0gchain/data/priv_validator_state.json
```
_Restart Node_
```
sudo systemctl restart og && sudo journalctl -u og -f --no-hostname -o cat
```
