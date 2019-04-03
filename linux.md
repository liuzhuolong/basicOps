## 通用

用sudo执行命令是以root身份执行，~/.bashrc不起作用

全局环境变量：
1. 写在 /etc/bashrc下
2. 在/etc/profile.d/下创建一个sh脚本，在里面添加PATH，这个文件夹下的所有脚本会在每次启动时执行一次



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

# set mouse=a  # 可选项，推荐初学者使用

colorscheme elflord
```



