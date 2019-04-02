# GIT 指南

`git init`: 新建版本库

`git add <file>`: 添加改动至 `index`：

`git commit -m <message>`: 提交改动至本地仓库

`git push origin <branch>`: 提交改动至远程仓库



### 配置别名

```bash
git config --global alias.<alias> <command>|'<command>'
```

常用别名：

```shell
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.br branch
git config --global alias.last 'log -1'
```

特别好用的 `log` 别名:

```shell
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```







