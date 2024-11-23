# <p align="center"> VOI Network </p>
<p align="center">
  <img height="100" height="auto" src="https://github.com/vnbnode/binaries/blob/main/Projects/VOI/voi.jpg?raw=true">
</p>

### Recommended Hardware Requirements

|   SPEC      |        Recommend          |
| :---------: | :-----------------------: |
|   **CPU**   | 4 Cores 8 threads (ARM64 or x86-64)                                   |
|   **RAM**   |        16 GB (DDR4)       |
|   **SSD**   |    100 GB SSD or NVME     |
| **NETWORK** |        100 Mbps           |

### STEP 1: Install
```
export VOINETWORK_IMPORT_ACCOUNT=1
/bin/bash -c "$(curl -fsSL https://get.voi.network/swarm)"
```
<img width="640" alt="image" src="https://github.com/user-attachments/assets/7c9ca681-e8c3-4f3c-9390-9c36afc9e8ee">

### STEP 2: Import your VOI wallet seed phrase.

<img width="708" alt="image" src="https://github.com/user-attachments/assets/89526d3d-0137-4852-91b5-7bb56091e5d2">

## Remove your node
### Leave the Swarm
```
docker swarm leave --force
```
### Remove the ~/voi directory
```
rm -rf ~/voi/
```
### Remove the /var/lib/voi directory
```
rm -rf /var/lib/voi
```
