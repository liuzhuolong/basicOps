## 安装 php 

### CentOS 7

```shell
yum install -y \ 
	php-5.4.16-46.el7.x86_64 \
	php-devel-5.4.16-46.el7.x86_64
wget http://pecl.php.net/get/vld-0.14.0.tgz
tar zxvf vld-0.14.0.tgz
cd ./vld-0.14.0
phpize
./configure --with-php-config=/usr/bin/php-config --enable-vld
make && make install
cat 'extension=vld.so' >> /etc/php.ini
systemctl restart httpd
```

### 

