## Snapshot
### Stop Node & download snapshot
```
sudo systemctl stop availd
```
### Remove data  & download snapshot _(replace your data directory)_
```
sudo apt-get install aria2
sudo apt-get install lz4
aria2c -x 16 -s 16 -o mainnet_snapshot_latest.tar.lz4 https://snapshot.avail.johnvnb.com/mainnet_snapshot_latest.tar.lz4
rm -rf <your data directory>/chains/avail_da_mainnet/paritydb
mkdir -p <your data directory>/chains/avail_da_mainnet/paritydb
lz4 -dc mainnet_snapshot_latest.tar.lz4 | tar -xf - -C <your data directory>/chains/avail_da_mainnet/paritydb
```
### Restart node
```
sudo systemctl restart availd
journalctl -u availd -f
```
### Remove snapshot
```
rm mainnet_snapshot_latest.tar.lz4
```
