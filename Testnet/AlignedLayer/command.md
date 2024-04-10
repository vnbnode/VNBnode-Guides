### Create wallet
```
alignedlayerd keys add wallet
```

### Create validator.json
```
cd $HOME
alignedlayerd tendermint show-validator
```

![image](https://github.com/vnbnode/VNBnode-Guides/assets/76662222/b64a2a03-e384-4b8b-b962-22bad6cfe422)

Please create `validator.json` replace {...} inside like below
```
nano $HOME/.alignedlayer/config/validator.json
```
```
{
    "pubkey": {"@type":"/cosmos.crypto.ed25519.PubKey","key":"IkGeamll8JFsV5jqoT37JfI37Ey/viBTZJLvLv8hlF0="},
    "amount": "1000000stake",
    "moniker": "Name-VNBnode",
    "identity": "06F5F34BD54AA6C7",
    "website": "https://vnbnode.com",
    "details": "VNBnode is a group of professional validators",
    "commission-rate": "0.1",
    "commission-max-rate": "0.2",
    "commission-max-change-rate": "0.01",
    "min-self-delegation": "1"
}
```
### Proceed to create validation
```
alignedlayerd tx staking create-validator $HOME/.alignedlayer/config/validator.json \
--from wallet --chain-id alignedlayer \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.0001stake
--node tcp://rpc-node.alignedlayer.com:26657
```
### Command
Delegate
```
alignedlayerd tx staking delegate $(alignedlayerd keys show wallet --bech val -a) 1000000stake --from wallet --chain-id alignedlayer --gas-adjustment 1.4 --gas auto --gas-prices 0.0001stake -y
```
Unjail
```
alignedlayerd tx slashing unjail --from wallet --chain-id alignedlayer --gas-adjustment 1.4 --gas auto --gas-prices 0.0001stake -y
```
Edit validator
```
alignedlayerd tx staking edit-validator \
--new-moniker "Name-VNBnode" \
--identity "06F5F34BD54AA6C7" \
--website "https://vnbnode.com" \
--details "VNBnode is a group of professional validators" \
--security-contact "email" \
--chain-id alignedlayer \
--commission-rate 0.05 \
--from wallet \
--gas-adjustment 1.4 \
--gas auto \
--gas-prices 0.0001stake \
-y
```
