## 离线安装harbor

- https://goharbor.io/docs/2.2.0/install-config/installation-prereqs/
- 安装docker及docker-compose
- 在 https://github.com/goharbor/harbor/releases 下载离线安装包
- 解压 `tar zxvf  harbor-offline-installer-<version>.tgz`
- （此步骤可以最后来）根据 https://goharbor.io/docs/2.2.0/install-config/configure-https/ 生成、配置证书
  - 若使用IP地址作为Harblr地址，alt_names处需要添加`IP.1=xxx.xxx.xxx.xxx`
- 根据 https://goharbor.io/docs/2.2.0/install-config/configure-yml-file/，将`harbor.yml.tmpl`复制为`harbor.yml`，编辑文档，至少需要修改`hostname`，使用离线版本还需要修改`trivy:skip_update`为true
- 运行 `./install.sh --with-trivy` 安装harbor，全部是以docker的形式部署的
- 在 https://github.com/aquasecurity/trivy-db/releases 下载trivy的离线数据库，解压至`/data/trivy-adapter/trivy/db/`目录下（db目录需要创建)，若不使用默认安装选项，则自行根据docker-compose.yml文档将数据库解压至trivy-adapter容器`/home/scanner/.cache/trivy/db`目录对应的宿主机挂载目录内
  - 重要：记得使用 `chmod 666 xxx` 更改权限