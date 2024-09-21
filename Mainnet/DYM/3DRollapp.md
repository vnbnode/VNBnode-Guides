```
sudo apt update && sudo apt upgrade -y
```
<img width="879" alt="image" src="https://github.com/user-attachments/assets/90d863c5-b63f-4199-8a95-3e009da61e55">
```
sudo apt install -y build-essential clang curl aria2 wget tar jq libssl-dev pkg-config make
```
<img width="532" alt="image" src="https://github.com/user-attachments/assets/908b8f83-e7f9-4558-a3ea-ae9ee6158984">
```
export DOCKER_API_VERSION=1.41
```
```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```
<img width="852" alt="image" src="https://github.com/user-attachments/assets/42b63b1f-92d0-4224-9785-8c488fbf5765">
