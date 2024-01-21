### 1. Server Requirements
| Component   |  Requirements  |
|-------------|----------------|
| CPU         | 8-Core (16-Thread) Intel i7/Xeon or equivalent with AVX support              |
| Storage     | 1 TB NVMe SSD is recommended         |
| Ram         | 20GB DDR4         |
| OS          |Ubuntu 22.04    |

### CPU must support AVX, check by
```php
lscpu | grep -oh avx
```
##### If result returns nothing, that means CPU does not support AVX.

### Get Rust
```php
curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
source $HOME/.cargo/env
# Add the wasm toolchain
rustup target add wasm32-unknown-unknown
```
```php
apt update
```
```php
apt install -y git binutils-dev libcurl4-openssl-dev zlib1g-dev libdw-dev libiberty-dev cmake gcc g++ python docker.io protobuf-compiler libssl-dev pkg-config clang llvm cargo awscli
```
