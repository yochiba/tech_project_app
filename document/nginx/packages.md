# nginx設定関連



## nginx https 証明書作成手順
***
```
$ cd ~ 
$ openssl genrsa 2048 > server.key
$ openssl req -new -key server.key > server.csr
$ openssl x509 -days 3650 -req -signkey server.key < server.csr > server.crt
$ sudo mv server.* /etc/nginx/conf.d/
$ cd /etc/nginx/conf.d
$ sudo chown root:root server.*
```