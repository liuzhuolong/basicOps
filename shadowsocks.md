# Server

## 安装

```shell
apt-get update --fix-missing
apt-get install -y python-pip
# pip install shadowsocks
pip install git+https://github.com/shadowsocks/shadowsocks.git@master
# 安装libsodium库
sudo su -
apt-get install build-essential wget -y
wget https://download.libsodium.org/libsodium/releases/LATEST.tar.gz
tar zxvf LATEST.tar.gz && cd libsodium-*
./configure && make && make install
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
```

## 部署

```shell
# 直接后台运行
ssserver -p <port> -k <password> -m aes-256-cfb --user nobody -d start
# tmux内运行
tmux
ssserver -p <port> -k <password> -m aes-256-cfb --fast-open
# 其他加密方式：
chacha20-ietf-poly1305
aes-256-gcm
```

## BUG

```python
Traceback (most recent call last):
  File "/usr/local/bin/ssserver", line 11, in <module>
    sys.exit(main())
  File "/usr/local/lib/python2.7/dist-packages/shadowsocks/server.py", line 34, in main
    config = shell.get_config(False)
  File "/usr/local/lib/python2.7/dist-packages/shadowsocks/shell.py", line 262, in get_config
    check_config(config, is_local)
  File "/usr/local/lib/python2.7/dist-packages/shadowsocks/shell.py", line 124, in check_config
    encrypt.try_cipher(config['password'], config['method'])
  File "/usr/local/lib/python2.7/dist-packages/shadowsocks/encrypt.py", line 44, in try_cipher
    Encryptor(key, method)
  File "/usr/local/lib/python2.7/dist-packages/shadowsocks/encrypt.py", line 83, in __init__
    random_string(self._method_info[1]))
  File "/usr/local/lib/python2.7/dist-packages/shadowsocks/encrypt.py", line 109, in get_cipher
    return m[2](method, key, iv, op)
  File "/usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py", line 76, in __init__
    load_openssl()
  File "/usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py", line 52, in load_openssl
    libcrypto.EVP_CIPHER_CTX_cleanup.argtypes = (c_void_p,)
  File "/usr/lib/python2.7/ctypes/__init__.py", line 379, in __getattr__
    func = self.__getitem__(name)
  File "/usr/lib/python2.7/ctypes/__init__.py", line 384, in __getitem__
    func = self._FuncPtr((name_or_ordinal, self))
AttributeError: /usr/lib/x86_64-linux-gnu/libcrypto.so.1.1: undefined symbol: EVP_CIPHER_CTX_cleanup
```

解决：

```shell
vim /usr/local/lib/python2.7/dist-packages/shadowsocks/crypto/openssl.py

搜索 cleanup
修改为 reset
```

## 开启bbr

**修改系统变量**

```shell
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
```

**2、保存生效**

```shell
sysctl -p
```

**3、查看内核是否已开启BBR**

```shell
sysctl net.ipv4.tcp_available_congestion_control
```

显示以下即已开启：

```shell
net.ipv4.tcp_available_congestion_control = bbr cubic reno
```

**4、查看BBR是否启动**

```shell
lsmod | grep bbr
```

显示以下即启动成功：

```shell
tcp_bbr                20480  14
```



# Client

## Linux

- https://github.com/shadowsocks/shadowsocks-libev
- 教程：https://www.itfanr.cc/2016/10/02/use-shadowsocks-to-have-better-internet-experienc