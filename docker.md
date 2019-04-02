Note: `<>`中内容表示类型

### 载入本地镜像
```
$ docker load --input <docker_image>.tar 
```
或
```
$ docker load -i <docker_image>.tar 
```
或
```
$ docker load < <docker_image>.tar
```


### 将当前容器输出为镜像
```
docker commit -m "<commit_message>" -a <author_info> <container_id> <images_name:<version>>
```

### 将镜像输出为.tar文件
```
docker save -o <name.tar> <image_id>
```

### 在宿主机和docker容器间传文件
1. 从宿主机传到docker容器
```
docker cp <local_file> <container_id>:<container_path>
```
2. 从docker容器传到宿主机
```
docker cp <container_id>:<container_path> <local_file>
```

## Nvidia-Docker

1.安装nvidia-docker方法如下，需要先安装docker，然后在安装nvidia-docker，以下方法实测可用：
https://www.cnblogs.com/jessezeng/p/7450072.html
2.	运行docker实例：
进入https://hub.docker.com/r/nvidia/cuda/tags可获得nvidia显卡支持的docker
如：nvidia-docker run -it nvidia/cuda:9.2-cudnn7-runtime-centos7 /bin/sh

可能会遇到的错误：
docker: Error response from daemon: create nvidia_driver_410.78: error looking up volume plugin nvidia-docker: plugin "nvidia-docker" not found.

解决方法：service nvidia-docker star



## 不加 sudo 直接 docker

```shell
cat /etc/group | grep docker # 查找 docker 组，确认其是否存在
groups # 列出自己的用户组，确认自己在不在 docker 组中

# 如果 docker 组不存在，则添加之：
sudo groupadd docker

# 将当前用户添加到 docker 组
sudo gpasswd -a ${USER} docker

# 重启服务
sudo service docker restart

# 切换一下用户组（刷新缓存）
newgrp - docker;
newgrp - `groups ${USER} | cut -d' ' -f1`; # TODO：必须逐行执行，不知道为什么，批量执行时第二条不会生效
# 或者，注销并重新登录
pkill X
```



## sshfs

```shell
# mount
sshfs [user@]hostname:[directory] mountpoint

# configure: allow other user access the mounted files
-o allow_other 

# unmount
fusermount -u mountpoint
```

