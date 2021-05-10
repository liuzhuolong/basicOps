

## 自签名证书 + 签发证书

### 自签名CA

```shell
# 生成私钥
openssl genrsa -out ca.key 4096
# 生成自签名CA证书
openssl req -x509 -new -nodes -sha512 -days 3650 \
 -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=yourdomain.com" \
 -key ca.key \
 -out ca.crt
```

### 服务端证书

```shell
# 生成私钥 
openssl genrsa -out yourdomain.com.key 4096
# 生成CSR(certificate signing request) 
# 据说若为IP签署证书则CN可以随便写，没试过
openssl req -sha512 -new \
    -subj "/C=CN/ST=Beijing/L=Beijing/O=example/OU=Personal/CN=yourdomain.com" \
    -key yourdomain.com.key \
    -out yourdomain.com.csr
# 生成v3.ext文件
# 其实只有这个[alt_names]是必须的
cat > v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
IP.1=192.168.123.123 # 如果为ip签署证书则需要这项
DNS.1=yourdomain.com
DNS.2=yourdomain
DNS.3=hostname
EOF

# 签发证书
openssl x509 -req -sha512 -days 3650 \
    -extfile v3.ext \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -in yourdomain.com.csr \
    -out yourdomain.com.crt
```





## docker 添加受信证书

将证书放入 `/etc/docker/certs.d/<domain>/` 目录下，若为服务端验证，则使用`.crt`格式，若用作客户端验证，则需要`.key`密钥和`.cert`格式



## curl 添加受信证书

- 获得curl默认引用的根证书集合文件：`curl-config --ca`
- `cat /path/to/ca.crt >> /path/to/<curl.pem>`



## centos 添加受信任CA

- 不知道哪些部分受到这个影响
- 复制证书至 `/etc/pki/ca-trust/source/anchors/` 目录，使用`update-ca-trust` 更新证书列表