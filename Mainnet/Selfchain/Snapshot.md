## Snapshot (Automatically update daily)

_Off State Sync_
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" ~/.selfchain/config/config.toml
```
_Stop Node and Reset Date_
```
sudo systemctl stop selfchain
cp $HOME/.selfchain/data/priv_validator_state.json $HOME/.selfchain/priv_validator_state.json.backup
rm -rf $HOME/.selfchain/data
selfchaind tendermint unsafe-reset-all --home ~/.selfchain/ --keep-addr-book
```
_Download Snapshot_ (auto daily update)
```
curl -L https://snap.vnbnode.com/selfchain/self-1_snapshot_latest.tar.lz4 | tar -I lz4 -xf - -C $HOME/.selfchain/data
```
```
mv $HOME/.selfchain/priv_validator_state.json.backup $HOME/.selfchain/data/priv_validator_state.json
```
_Restart Node_
```
sudo systemctl restart selfchain && sudo journalctl -u selfchain -f --no-hostname -o cat
```
