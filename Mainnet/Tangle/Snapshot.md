## Snapshot _(Pruning=default)_
### Stop Node 
```
sudo systemctl stop tangle
```
### Remove data  & download snapshot _(Replace the path if you have it in a different location)_
```
sudo apt-get install aria2
sudo apt-get install lz4
aria2c -x 16 -s 16 -o tangle_snapshot_latest.tar.lz4 https://snapshot.tangle.johnvnb.com/tangle_snapshot_latest.tar.lz4
rm -rf $HOME/.tangle/data/chains/tangle-mainnet/db/*
lz4 -dc tangle_snapshot_latest.tar.lz4 | tar -xf - -C $HOME/.tangle/data/chains/tangle-mainnet/db
```
### Restart node
```
sudo systemctl restart tangle
journalctl -u tangle -f
```
### Remove snapshot
```
rm tangle_snapshot_latest.tar.lz4
```
