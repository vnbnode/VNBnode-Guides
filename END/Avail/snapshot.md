## Snapshot _(archive)_
### Stop Node & download snapshot
```
sudo systemctl stop availd
```
### Remove data  & download snapshot _(replace your data directory)_
```
sudo apt-get install aria2
sudo apt-get install lz4
aria2c -x 16 -s 16 -o turing_snapshot_latest.tar.lz4 https://snapturing-avail.johnvnb.com/turing_snapshot_latest.tar.lz4
rm -rf <your data directory>/chains/avail_turing_testnet/paritydb
mkdir -p <your data directory>/chains/avail_turing_network/paritydb
lz4 -dc turing_snapshot_latest.tar.lz4 | tar -xf - -C <your data directory>/chains/avail_turing_network/paritydb
```
### Restart node
```
sudo systemctl restart availd
journalctl -u availd -f
```
### Remove snapshot
```
turing_snapshot_latest.tar.lz4
```
