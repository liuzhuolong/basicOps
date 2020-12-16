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

### 解压缩

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

### 配置源

#### 源站

- 清华大学开源软件镜像站：https://mirror.tuna.tsinghua.edu.cn/help/ubuntu/

#### 常用配置

- Ubuntu 源 ：`/etc/apt/sources.list`

  - 16.04 LTS，清华源
  
  ```shell
  deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial main restricted universe multiverse
  deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-updates main restricted universe multiverse
  deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-backports main restricted universe multiverse
  deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ xenial-security main restricted universe multiverse
  ```
- PYPI源：`~/.pip/pip.conf`

  - 清华源

  ```shell
  [global]
  index-url = https://pypi.tuna.tsinghua.edu.cn/simple
  ```

  - 阿里源

    ```shell
    [global]
    trusted-host =  mirrors.aliyun.com
    index-url = https://mirrors.aliyun.com/pypi/simple
    ```

- conda源

  - 清华源

  ```shell
  conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
  conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
  conda config --set show_channel_urls yes
  ```

  

### 网络配置

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



## .bashrc 配置

```shell
# set shell prompt
PS1='\[\e[0;33m\][\u@\h \W]\[\e[m\] \$ '
# PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# some aliases
alias ls='ls --color'
alias la='ls --color -Alh --file-type'
alias l='ls --color'
alias dk='docker'
alias di='docker images'
alias dsh='du -sh'
alias vi='vim'
alias hg='history | grep'
```



## VIM

### 配置 .vimrc

- 除自带配色方案外，可从[这里](http://www.easycolor.cc/vim/list.html)下载配色方案后放到`/usr/share/vim/vim74/colors/`下，然后配置 `colorscheme`
- 使用 Vundle 配置

```shell
" Vundle Configure
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'vim-scripts/indentpython.vim' " indent for Python
Plugin 'scrooloose/nerdtree' " file tree
" Plugin 'moby/moby', {'rtp': '/contrib/syntax/vim'} " highlight for dockerfile
" Plugin 'Valloric/YouCompleteMe' " auto-complete

call vundle#end()            " required
filetype plugin indent on    " required

" configures for above plugins

" NERDTree
" map F2 to open NERDTree
map <F2> :NERDTreeToggle<CR>
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Followings are non-Plugin stuffs
syn on "enable highlight
set nu "show line number
set laststatus=2 "show status bar

set autoindent "auto indent
set expandtab "use space replace tab
set tabstop=4 "4 space one tab
set softtabstop=4 "delete 4 space one backspace
set shiftwidth=4 "4 space for auto indent
set colorcolumn=121 " show a vertical line

set backspace=indent,eol,start #user-friendly backspace

" color scheme config
set t_Co=256 "enable 256 colors
colorscheme monokai

"other settings
set viminfo='20,\"5000
set tags=tags;/

set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
```

- 简易配置

```shell
syn on "enable highlight
set nu "show line number
set laststatus=2 "show status bar

set autoindent "auto indent
set expandtab "use space replace tab
set tabstop=4 "4 space one tab
set softtabstop=4 "delete 4 space one backspace
set shiftwidth=4 "4 space for auto indent
set colorcolumn=121 " show a vertical line

set backspace=indent,eol,start " user-friendly backspace

set t_Co=256 "enable 256 colors
colorscheme elflord

set viminfo='20,\"5000
set tags=tags;/

set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
```

- monokai: https://github.com/crusoexia/vim-monokai

### Vundle

主页：https://github.com/VundleVim/Vundle.vim

- Install

  ```
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  ```

## YouCompleteMe (YCM) 安装

- YCM 是VIM上最好用的自动补全之一


## gcc
- 临时启用gcc7
- see `https://www.centos.bz/2018/07/centos-7-%E7%9B%B4%E6%8E%A5%E5%AE%89%E8%A3%85-gcc-7/`
```shell
sudo yum install centos-release-scl
sudo yum install devtoolset-7-gcc*
scl enable devtoolset-7 bash
which gcc
gcc --version
```

## 其他

- make 指令可以通过 -j<num_threads> 来指定并行编译
