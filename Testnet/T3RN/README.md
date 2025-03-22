# T3RN v2

# Download latest release
```
mkdir t3rn & cd t3rn
curl -s https://api.github.com/repos/t3rn/executor-release/releases/latest | \
grep -Po '"tag_name": "\K.*?(?=")' | \
xargs -I {} wget https://github.com/t3rn/executor-release/releases/download/{}/executor-linux-{}.tar.gz
tar -xzf executor-linux-*.tar.gz
chmod +x $HOME/executor/executor/bin/executor
```

# Configure Settings and Environment Required Variables
```
export ENVIRONMENT=testnet
export ENABLED_NETWORKS='arbitrum-sepolia,base-sepolia,optimism-sepolia,unichain-sepolia,l2rn'
export NETWORKS_DISABLED='blast-sepolia'
export LOG_LEVEL=debug
export LOG_PRETTY=false
export EXECUTOR_PROCESS_BIDS_ENABLED=true
export EXECUTOR_PROCESS_ORDERS_ENABLED=true
export EXECUTOR_PROCESS_CLAIMS_ENABLED=true
export EXECUTOR_PROCESS_PENDING_ORDERS_FROM_API=false
export EXECUTOR_PROCESS_ORDERS_API_ENABLED=false
export EXECUTOR_ENABLE_BATCH_BIDDING=false
export PRIVATE_KEY_LOCAL=0x....
export EXECUTOR_MAX_L3_GAS_PRICE=1000
export RPC_ENDPOINTS='{
    "l2rn": ["https://b2n.rpc.caldera.xyz/http"],
    "arbt": ["https://arbitrum-sepolia.drpc.org", "https://sepolia-rollup.arbitrum.io/rpc"],
    "bast": ["https://base-sepolia-rpc.publicnode.com", "https://base-sepolia.drpc.org"],
    "opst": ["https://sepolia.optimism.io", "https://optimism-sepolia.drpc.org"],
    "unit": ["https://unichain-sepolia.drpc.org", "https://sepolia.unichain.org"],
    "blst": []
}'
```

# Start
```
$HOME/executor/executor/bin/executor
```
