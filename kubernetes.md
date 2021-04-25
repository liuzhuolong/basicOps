- 安装kubeadm：https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
- 使用 kubeadm 创建集群：https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
- **第一次搭建失败，第二次使用官网centos 7.9的镜像成功搭建，很多之前的问题都没有遇到**
  - `D:\system_images\CentOS-7-x86_64-DVD-2009.iso`



# 第二次尝试

## 基本环境

- 使用 windows 宿主机上的 vmware 创建虚拟机
- 使用 centos 7
- 创建三台虚拟机：
  - k8s-master
    - 200GB 硬盘
    - 4G 内存
    - 2 CPU，每 CPU 分配 2核
    - 使用 NAT 网络
  - k8s-worker1 & k8s-worker2
    - 100GB 硬盘
    - 2G 内存
    - 1CPU，每 CPU 分配2核
    - 使用 NAT 网络



## 虚拟机基本配置过程

- 为每台虚拟机配置网络

  - vmware 中，选择 `编辑` -> `虚拟网络编辑器`，右下角 `更改设置` 开启编辑权限，选择 `VMnet8`（NAT模式），点击 `NAT设置`，查看子网IP/子网掩码和网关IP

  - 在每台虚拟机中，编辑 `/etc/sysconfig/network-scripts/ifcfg-xxxxx`，根据实际子网IP/子网掩码/网关IP，修改或添加以下项：

    ```
    BOOTPROTO=static
    ONBOOT=yes
    
    IPADDR=192.168.xxx.xxx
    NETMASK=255.255.255.0
    GATEWAY=192.168.xxx.xxx
    
    DNS1=8.8.8.8
    ```

  - 配置的同时记下 HWADDR 项的值，即网卡 MAC 地址，确保每个 MAC 地址不同（kubeadm 的要求，通常不用管）

  - 使用 `systemctl restart network` 重启网络，`curl www.baidu.com` 测试网络连通

  - 回到 vmware 的 `NAT设置` 中，配置端口转发，将每一台的 22 端口转发出来，方便通过 xshell 登录（非必须）

  - 注：由于同属一个子网，且没有进行额外限制，虚拟机之间的网络是互通的

- 使用 `hostnamectl set-hostname <new_hostname>` 命令为每台虚拟机设置不同的主机名（kubeadm要求）分别为：

  - k8s-master

- 在 `/etc/hosts` 文件的 127.0.0.1 项最后追加主机名，保证可以通过主机名访问到本机

- 使用 `cat /sys/class/dmi/id/product_uuid` 命令获取每台虚拟机的 product_uuid ，确保每个节点上的该值是唯一的

- 启用 `br_netfilter`，并允许 iptables 检查桥接流量

  - 根据以下资料，在3.19内核版本以前，`br_netfilter`是一个内建模块，不需要 `mobprobe br_netfilter` 命令来进行加载

    - https://askubuntu.com/questions/677827/br-netfilter-missing-in-ubuntu-14-04
    - https://github.com/moby/moby/issues/13969
    - https://github.com/moby/moby/pull/13981

  - 设置 `sysctl`：在 `/etc/sysctl.d/` 下新建 `k8s.conf`，输入：

    ```
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    
    # 也可使用以下命令
    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    EOF
    ```

    然后使用 `sysctl --system` 使配置生效

    - 网桥，参考：https://segmentfault.com/a/1190000009491002
    - 参数说明：https://feisky.gitbooks.io/sdn/content/linux/params.html#bridge-nf

- 安装 container runtime （Docker）

  - 容器运行时包括 Docker, containerd，CRI-O 等，本次搭建选用 Docker

  - 安装过程参见：https://docs.docker.com/engine/install/centos/

    ```shell
    yum install -y yum-utils
    yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
    yum install -y docker-ce docker-ce-cli containerd.io
    systemctl start docker
    ```

- 最后还要禁用swap（kubeadm要求）

  - `swapoff -a` 关闭 swap 分区
  - 编辑 `/etc/fstab` 注释掉含有 `swap` 的行
  - 

## 安装 kubeadm, kubelet 和 kubectl

- 你需要在每台机器上安装以下的软件包：
  - `kubeadm`：用来初始化集群的指令。	
  - `kubelet`：在集群中的每个节点上用来启动 Pod 和容器等。
  - `kubectl`：用来与集群通信的命令行工具。
- 使用以下命令安装：

```shell
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# 将 SELinux 设置为 permissive 模式（相当于将其禁用）
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

sudo systemctl enable --now kubelet
```



## 创建集群

- `kubeadm init` 进行初始化

  - 初始化过程中报了两个warning:

    ```
    [WARNING Firewalld]: firewalld is active, please ensure ports [6443 10250] are open or your cluster may not function correctly
    [WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd". Please follow the guide at https://kubernetes.io/docs/setup/cri/
    ```

    - 对第一个warning，直接关闭firewalld（图方便）：`systemctl stop firewalld & systemctl disable firewalld`

    - 对第二个warning，使用如下命令：https://kubernetes.io/docs/setup/cri/ 

      ```shell
      cat <<EOF | sudo tee /etc/docker/daemon.json
      {
        "exec-opts": ["native.cgroupdriver=systemd"],
        "log-driver": "json-file",
        "log-opts": {
          "max-size": "100m"
        },
        "storage-driver": "overlay2"
      }
      EOF
      
      systemctl daemon-reload
      systemctl restart docker
      ```

    - 重新 `kubeadm init`，会开始拉取以下镜像：

      ```
      k8s.gcr.io/kube-apiserver:v1.21.0
      k8s.gcr.io/kube-controller-manager:v1.21.0
      k8s.gcr.io/kube-scheduler:v1.21.0
      k8s.gcr.io/kube-proxy:v1.21.0
      k8s.gcr.io/pause:3.4.1
      k8s.gcr.io/etcd:3.4.13-0
      k8s.gcr.io/coredns/coredns:v1.8.0
      ```

      很不幸这个`k8s.gcr.io`国内是不通的..同时发现出口IP拉取镜像次数超限，无法从dockerhub拉取其他镜像

      - 解决方案：登录dockerhub账号，增加次数，通过从其他替代仓库拉取镜像来绕过`k8s.gcr.io`：`kubeadm init --image-repository <repo_name>`
        - 特别注意其中的coredns的地址

- 成功初始化后提示：

  ```
  Your Kubernetes control-plane has initialized successfully!
  
  To start using your cluster, you need to run the following as a regular user:
  
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
  
  Alternatively, if you are the root user, you can run:
  
    export KUBECONFIG=/etc/kubernetes/admin.conf
  
  You should now deploy a pod network to the cluster.
  Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
    https://kubernetes.io/docs/concepts/cluster-administration/addons/
  
  Then you can join any number of worker nodes by running the following on each as root:
  
  kubeadm join 192.168.58.131:6443 --token io24cv.cq7dk5b7yzu7b31u \
  	--discovery-token-ca-cert-hash sha256:42cbd3b0521f1186a6dbcb242df5978191eb864589c244d148480ea0dd10c7cf
  ```

- 安装 calico网络扩展（可以选择其他addon，但这个是k8s推荐的）

  ```shell
  curl https://docs.projectcalico.org/manifests/calico.yaml -O
  kubectl apply -f calico.yaml
  ```

  - 等了一段时间`kubectl get nodes`还是显示notready，排查发现是因为cni的镜像没有拉取成功，还是因为拉取次数限制，让k8s可以使用docker登录信息：

    ```
    cp ~/.docker/config.json /var/lib/kubelet/config.json
    ```

    或者提前拉取镜像：

    ```
    docker pull docker.io/calico/cni:v3.18.1
    docker pull docker.io/calico/pod2daemon-flexvol:v3.18.1
    ```

    等了一会，终于可以了

## 添加节点

- 添加节点前，建议手动拉取镜像，包括kube-proxy和两个cni镜像（或配置docker登录信息 - 但添加节点前/var/lib/kubelet文件夹是未创建的）

- 不需要执行`创建集群`这一节的操作（**仍要关闭防火墙和修改docker的cgroup driver**)，装好Kubeadm后运行上一节中初始化后提示信息中的命令

  ```shell
  kubeadm join 192.168.58.131:6443 --token io24cv.cq7dk5b7yzu7b31u \
  	--discovery-token-ca-cert-hash sha256:42cbd3b0521f1186a6dbcb242df5978191eb864589c244d148480ea0dd10c7cf
  ```
  - token每24小时失效，需要在主节点上重新创建：`kubeadm token create`

  - 如果你没有 `--discovery-token-ca-cert-hash` 的值，则可以通过在控制平面节点上执行以下命令链来获取它：

    ```bash
    openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | \
       openssl dgst -sha256 -hex | sed 's/^.* //'
    ```

- 加入集群后会需要部署 kube-proxy 和 CNI 插件，如果一直notready可以检查是否是镜像拉取失败

# 第一次失败尝试

## 基本环境

- 使用 windows 宿主机上的 vmware 创建虚拟机
- 使用 centos 7
- 创建三台虚拟机：
  - kubernetes-master  (下称master)
  - kubernetes-worker1 (下称 worker1)
  - kubernetes-worker2 （下称worker2）
- 每台虚拟机分配：
  - 100GB 硬盘
  - 2G 内存
  - 2 CPU，每 CPU 分配 1核
  - 使用 NAT 网络



## 虚拟机基本配置过程

- 给每台虚拟机的用户账号开启免密sudo权限（非必须，可直接用root账号）

  - `su` 输入 root 密码登录 root 账号，`chmod +w /etc/sudoers` 开启写权限，编辑 `/etc/sudoers` 文件，添加一行： `<user_name>	ALL:(ALL)	NOPASSWD:ALL`，保存退出后 `chmod -w /etc/sudoers` 关闭写权限

- 为每台虚拟机配置网络

  - vmware 中，选择 `编辑` -> `虚拟网络编辑器`，右下角 `更改设置` 开启编辑权限，选择 `VMnet8`（NAT模式），点击 `NAT设置`，查看子网IP/子网掩码和网关IP

  - 在每台虚拟机中，编辑 `/etc/sysconfig/network-scripts/ifcfg-xxxxx`，根据实际子网IP/子网掩码/网关IP，修改或添加以下项：

    ```
    BOOTPROTO=static
    ONBOOT=yes
    
    IPADDR=192.168.xxx.xxx
    NETMASK=255.255.255.0
    GATEWAY=192.168.xxx.xxx
    
    DNS1=8.8.8.8
    ```

  - 配置的同时记下 HWADDR 项的值，即网卡 MAC 地址，确保每个 MAC 地址不同（kubeadm 的要求，通常不用管）
  - 使用 `systemctl restart network` 重启网络，`curl www.baidu.com` 测试网络连通
  - 回到 vmware 的 `NAT设置` 中，配置端口转发，将每一台的 22 端口转发出来，方便通过 xshell 登录（非必须）
  - 注：由于同属一个子网，且没有进行额外限制，虚拟机之间的网络是互通的

- 使用 `hostnamectl set-hostname <new_hostname>` 命令为每台虚拟机设置不同的主机名（kubeadm要求）分别为：

  - k8s-master
  - k8s-worker1
  - k8s-worker2

- 在 `/etc/hosts` 文件的 127.0.0.1 项最后追加主机名，保证可以通过主机名访问到本机

- 使用 `cat /sys/class/dmi/id/product_uuid` 命令获取每台虚拟机的 product_uuid ，确保每个节点上的该值是唯一的

- 配置 `.bashrc` 和 `.vimrc`，安装 `vim-enhanced`，方便操作（非必须）

- 启用 `br_netfilter`，并允许 iptables 检查桥接流量

  - 根据以下资料，在3.19内核版本以前，`br_netfilter`是一个内建模块，不需要 `mobprobe br_netfilter` 命令来进行加载

    - https://askubuntu.com/questions/677827/br-netfilter-missing-in-ubuntu-14-04
    - https://github.com/moby/moby/issues/13969
    - https://github.com/moby/moby/pull/13981

  - 设置 `sysctl`：在 `/etc/sysctl.d/` 下新建 `k8s.conf`，输入：

    ```
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    
    # 也可使用以下命令
    cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
    net.bridge.bridge-nf-call-ip6tables = 1
    net.bridge.bridge-nf-call-iptables = 1
    EOF
    ```

    然后使用 `sysctl --system` 使配置生效

    - 网桥，参考：https://segmentfault.com/a/1190000009491002
    - 参数说明：https://feisky.gitbooks.io/sdn/content/linux/params.html#bridge-nf

- 安装 container runtime （Docker）

  - 容器运行时包括 Docker, containerd，CRI-O 等，本次搭建选用 Docker

  - 安装过程参见：https://docs.docker.com/engine/install/centos/

    ```shell
    yum install -y yum-utils
    yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo
    yum install docker-ce docker-ce-cli containerd.io
    ```

    

  - 安装后 `systemctl start docker` 启动服务

  - 第一次安装完成后失败，查资料发现是内核版本不支持 overlay2 导致的

    - 见https://docs.docker.com/storage/storagedriver/overlayfs-driver/：在 centos 上，要使用 `overlayFS` ，内核版本至少为`3.10.0-514`，而我使用的镜像的内核版本是`3.10.0-123`

    - 首先按照安装教程中的指南卸载docker（其实删除 `/var/lib/docker` 好像就可以）

    - 升级内核

      ```shell
      rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
      # 执行这一步时报错 curl: (35) Peer reports incompatible or unsupported protocol version.；
      # 升级 curl 后解决：yum update curl -y
      
      rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
      yum --enablerepo=elrepo-kernel install -y kernel-ml
      
      # 编辑 /etc/default/grub ，设置 GRUB_DEFAULT=0
      # 运行 grub2-mkconfig -o /boot/grub2/grub.cfg 重新创建内核配置
      # reboot 重启
      ```

    - 重新安装docker
    - 启动服务仍然报错，查看报错日志，是由于firewalld导致的
      
  - 关闭firewalld：`systemctl stop firewalld`
      
    - 其中有一台成功启动 `systemctl start docker` 后 `docker ps` 还是不行，但用 `dockerd` 启动守护进程就可以，不知道为啥，重装了一遍可以了

- 最后还要禁用swap（kubeadm要求）
  - `swapoff -a` 关闭 swap 分区
  - 编辑 `/etc/fstab` 注释掉含有 `swap` 的行
  - 

## 安装 kubeadm, kubelet 和 kubectl

- 你需要在每台机器上安装以下的软件包：
  - `kubeadm`：用来初始化集群的指令。	
  - `kubelet`：在集群中的每个节点上用来启动 Pod 和容器等。
  - `kubectl`：用来与集群通信的命令行工具。
- 使用以下命令安装：

```shell
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

# 将 SELinux 设置为 permissive 模式（相当于将其禁用）
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

sudo yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes

sudo systemctl enable --now kubelet
```



## 创建集群

- `kubeadm init` 进行初始化
  - 报错：[ERROR SystemVerification]: unsupported graph driver: fuse-overlayfs
  - 通过`docker info` 发现 docker 的文件系统是 `fuse-overlayfs`, 不是 overlay2，原因是 xfs 文件系统 的 d_type 项 为 0（被禁用），要修改需要重装系统