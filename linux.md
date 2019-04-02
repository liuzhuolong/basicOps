# 通用

用sudo执行命令是以root身份执行，~/.bashrc不起作用

全局环境变量：
1. 写在 /etc/bashrc下
2. 在/etc/profile.d/下创建一个sh脚本，在里面添加PATH，这个文件夹下的所有脚本会在每次启动时执行一次