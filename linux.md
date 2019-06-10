## 通用

用sudo执行命令是以root身份执行，~/.bashrc不起作用

全局环境变量：
1. 写在 /etc/bashrc下
2. 在/etc/profile.d/下创建一个sh脚本，在里面添加PATH，这个文件夹下的所有脚本会在每次启动时执行一次

### 设置时区

1. 通过环境变量 TZ 修改时间

   `tzselect` 进入引导教程

   `export TZ='Asia/Shanghai'` 即可修改时间

2. 通过修改文件修改时间 (Ubuntu)

   ```
   mv /etc/localtime /etc/localtime.bak
   cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
   echo "Asia/Shanghai" > /etc/timezone
   dpkg-reconfigure -f noninteractive tzdata
   ```

### crontab

#### 使用 date 命令

- 需写成 `$(date +\$F)` 的形式才能生效
- 需要通过修改文件来修改时区，才能影响到 crontab 的 date 命令

## 解压缩

- 解压 .tar.gz

  ```shell
  # -z 是否同时具有 gzip 属性，即是否需要用 gzip 解压
  # -x 解压缩，-c 代表压缩
  # -v 列出详细解压过程
  # -f 从文件解压，后面跟文件名，-zxfv <filename>.tar.gz 是错误的
  tar -zxvf <filename>.tar.gz
  ```

- 解压 tar.bz2

  ```shell
  # -j 使用 bz2 解压
  tar -jxvf <filename>.tar.bz2
  ```

  





## 网络配置

1. 配置 `etc/sysconfig/network-scripts/ifcfg-ethxxx`

   ```shell
   DEVICE=eth0 #设置网络接口名称
   ONBOOT=yes # 设置网络接口在系统启动时激活。
   BOOTPROTO=static # 配置为静态地址
   IPADDR=192.168.1.10 # 配置IP地址
   NETMASK=255.255.255.0 # 配置子网掩码
   GATEWAY=192.168.1.1 # 网络接口的默认网关
   ```

2. 配置`etc/sysconfig/network`

   ```shell
   NETWORKING=yes
   HOSTNAME=<hostname> # 修改hostname之一
   ```

3. 配置`etc/resolv.conf`

   ```shell
   search xxx.com # 设置主机的默认查找域名
   nameserver 192.168.137.1 # 设置DNS服务器
   ```

4. 配置 `/etc/hosts`：将`127.0.0.1`和`::1`后面的 `localhost.localdomain` 改为想要的主机名（修改hostname之二）
5. 配置 `/etc/hostname`：将原内容替换成想要的主机名（修改hostname之三）

6.  `systemctl restart network` 重启网络服务



## 配置 vim

修改或创建 `~/.vimrc` 如下：

```shell
syn on
set nu
set smartindent
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set viminfo='20,\"5000
set tags=tags;/

colorscheme elflord
```

## .bashrc 配置

```shell
# set shell prompt
PS1='\[\e[0;33m[\]\u@\h \W]\[\e[m\] \$ '


# some aliases
# ls
alias la='ls -AlFh'
# docker
alias dk='docker'
alias di='docker images'
# du
alias dsh='du -sh'

```


