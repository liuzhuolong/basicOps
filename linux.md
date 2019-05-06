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

colorscheme elflord
```

## .bashrc 配置

```shell
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='\[\e[0;33m[\]${debian_chroot:+($debian_chroot)}\u@\h \W]\[\e[m\] \$ '
else
    PS1='[${debian_chroot:+($debian_chroot)}\u@\h \w] \$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

```



