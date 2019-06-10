## 安装 docker

https://docs.docker-cn.com/engine/installation/

## 基础操作

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

## 镜像源

换源：配置 `/etc/docker/daemon.json`

```shell
{
	"registry-mirrors":[
		<镜像源>
	]
}
```



国内源: https://registry.docker-cn.com



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



## 创建私有 docker registry

1. 拉取 [registry 镜像](https://hub.docker.com/_/registry?tab=description)

   ```shell
   docker pull registry:latest
   ```

2. 启动容器以启动仓库服务

   ```shell
   docker run -d -p 5000:5000 --restart=always --name=registry-srv -v /cache1/dockerRegistry:/var/lib/registry registry
   ```

3. 拉取 [hyper/docker-registry-web 镜像](https://hub.docker.com/r/hyper/docker-registry-web) ，用于实时查看仓库镜像

   ```shell
   docker pull hyper/docker-registry-web
   ```

4. 启动服务

   ```shell
   docker run -it -d -p 5001:8080 --name registry-web --link registry-srv -e REGISTRY_URL=http://registry-srv:5000/v2 -e REGISTRY_NAME=localhost:5000 hyper/docker-registry-web
   ```



### 使用方法

1. 在 `/etc/docker/daemon.json` 中添加仓库地址

   ```json
   {
   	"insecure-registries": ["<host:port>"]    
   }
   ```

2. 将 docker image tag 成指定格式

   ```shell
   docker tag <image_id> <host>:<port>/<image_name>:<tag>
   ```

2.  push 镜像

   ```shell
   docker push <host>:<port>/<image_name>:<tag>
   ```

3. 拉取也是一样

   ```shell
   docker pull <host>:<port>/<image_name>:<tag>
   ```

   



### bugfix

启动web服务时遇到错误

```shell
Error response from daemon: mkdir /var/lib/docker/overlay/*** : invalid argument
```

使用 `docker info` 发现（事实上是google发现） `Storage Driver: overlay` ，需要改成 `devicemapper`

在 `/etc/docker/daemon.json` 添加：

```json
{
    "storage-driver": "devicemapper"
}
```

**注意！！！修改这个操作会丢失所有当前镜像和容器！！**

确认修改的话，使用`systemctl restart docker` 生效



















































