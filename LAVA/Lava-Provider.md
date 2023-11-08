### Before start install Lava provider, you must ensure you have:
* Your own domain (If yet buy one: [namecheap](https://www.namecheap.com/)
* Lava node running
* Lavap binaries installed
### Step 1: Setup A record for your domain

#### Go to DNS setting:
* Create A record: Host = LAVA; Value = Your server public IP.
![image](https://github.com/vnbnode/VNBnode-Guides/assets/128967122/91f04293-70d9-4b87-9f8b-66808ce1940a)
### Step 2: Install Required Dependencies
```php
sudo apt update
sudo apt install certbot net-tools nginx python3-certbot-nginx -y
```
### Step 3: Generate Certificate
```php
sudo certbot certonly -d yourdomain.com -d LAVA.yourdomain.com
```
***Select 1 for Nginx Web Server Plugin***
***Enter your valid email***
### Step 4: Validate Certificate
```php
sudo certbot certificates
```
![image](https://github.com/vnbnode/VNBnode-Guides/assets/128967122/daaf691f-8ed4-46f2-b22d-563176743bee)
### Step 5: Create Nginx server
```php
cd /etc/nginx/sites-available/
```
```php
sudo nano lava_server
```
***Copy & Paste***
```php
server {
    listen 443 ssl http2;
    server_name lava.your-site.com;

    ssl_certificate /etc/letsencrypt/live/your-site.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-site.com/privkey.pem;
    error_log /var/log/nginx/debug.log debug;

    location / {
        proxy_pass http://127.0.0.1:2224;
        grpc_pass 127.0.0.1:2224;
    }
}
```
### Step 6: Create a link
```php
sudo ln -s /etc/nginx/sites-available/lava_server /etc/nginx/sites-enabled/lava_server
```
### Step 7: Test Nginx Configuration
```php
sudo nginx -t
```
***Expected result***
'nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful'
