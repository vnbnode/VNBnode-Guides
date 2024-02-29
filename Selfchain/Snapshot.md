## Snapshot (Automatically update daily)

_Off State Sync_
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" ~/.selfchain/config/config.toml
```
_Stop Node and Reset Date_
```
sudo systemctl stop selfchaind
cp $HOME/.selfchain/data/priv_validator_state.json $HOME/.selfchain/priv_validator_state.json.backup
rm -rf $HOME/.selfchain/data
selfchaind tendermint unsafe-reset-all --home ~/.selfchain/ --keep-addr-book
```
_Download Snapshot_ (auto daily update)
```
curl -L http://109.199.118.239/selfchain/self-dev-1_snapshot_latest.tar.lz4 | tar -I lz4 -xf - -C $HOME/.selfchain/data
```
```
mv $HOME/.selfchain/priv_validator_state.json.backup $HOME/.selfchain/data/priv_validator_state.json
```
_Restart Node_
```
sudo systemctl restart selfchaind && sudo journalctl -u selfchaind -f --no-hostname -o cat
```
