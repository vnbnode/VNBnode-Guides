# Snapshot _(sync=warp)_
## For Systemd
### Stop Node
```
sudo systemctl stop tanssi.service
```
### Remove data  & download snapshot 
_(Replace the path if you have it in a different location)_
```
sudo apt-get install aria2
sudo apt-get install lz4
aria2c -x 16 -s 16 -o dancebox_snapshot_latest.tar.lz4 https://snapshot.tanssi.johnvnb.com/dancebox_snapshot_latest.tar.lz4
aria2c -x 16 -s 16 -o westend_moonbase_relay_testnet_snapshot_latest.tar.lz4 https://snapshot.tanssi.johnvnb.com/westend_moonbase_relay_testnet_snapshot_latest.tar.lz4
```
```
rm -rf $Home/var/lib/tanssi-data/para/chains/dancebox/paritydb/*
rm -rf $Home/var/lib/tanssi-data/relay/chains/westend_moonbase_relay_testnet/paritydb/*
```
```
lz4 -dc dancebox_snapshot_latest.tar.lz4 | tar -xf - -C $Home/var/lib/tanssi-data/para/chains/dancebox/paritydb
lz4 -dc westend_moonbase_relay_testnet_snapshot_latest.tar.lz4 | tar -xf - -C $Home/var/lib/tanssi-data/relay/chains/westend_moonbase_relay_testnet/paritydb
```
### Restart node
```
sudo systemctl restart tanssi.service
journalctl -u tanssi.service -f
```
### Remove snapshot file
```
rm dancebox_snapshot_latest.tar.lz4
rm westend_moonbase_relay_testnet_snapshot_latest.tar.lz4
```
## For Docker
### Stop Node
```
docker stop tanssi
```
### Remove data  & download snapshot
_(Replace the path if you have it in a different location)_
```
sudo apt-get install aria2
sudo apt-get install lz4
aria2c -x 16 -s 16 -o dancebox_snapshot_latest.tar.lz4 https://snapshot.tanssi.johnvnb.com/dancebox_snapshot_latest.tar.lz4
aria2c -x 16 -s 16 -o westend_moonbase_relay_testnet_snapshot_latest.tar.lz4 https://snapshot.tanssi.johnvnb.com/westend_moonbase_relay_testnet_snapshot_latest.tar.lz4
```
```
rm -rf $HOME/dancebox/para/chains/dancebox/paritydb/*
rm -rf $HOME/dancebox/relay/chains/westend_moonbase_relay_testnet/paritydb/*
```
```
lz4 -dc dancebox_snapshot_latest.tar.lz4 | tar -xf - -C $HOME/dancebox/para/chains/dancebox/paritydb
lz4 -dc westend_moonbase_relay_testnet_snapshot_latest.tar.lz4 | tar -xf - -C $HOME/dancebox/relay/chains/westend_moonbase_relay_testnet/paritydb
```
### Restart node
```
docker restart tanssi
docker logs -f tanssi
```
### Remove snapshot
```
rm dancebox_snapshot_latest.tar.lz4
rm westend_moonbase_relay_testnet_snapshot_latest.tar.lz4
```
