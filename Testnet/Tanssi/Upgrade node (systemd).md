```
systemctl stop tanssi.service
cd /var/lib/tanssi-data
rm tanssi-relay
wget https://github.com/moondance-labs/tanssi/releases/download/v0.13.0/tanssi-relay
wget https://github.com/moondance-labs/tanssi/releases/download/v0.13.0/tanssi-relay-execute-worker
wget https://github.com/moondance-labs/tanssi/releases/download/v0.13.0/tanssi-relay-prepare-worker
chmod +x ./tanssi-relay*

systemctl restart tanssi.service
journalctl -f -u tanssi.service
```
