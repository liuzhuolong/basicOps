# Git 指南

## 1. 基础命令

`git init`: 新建版本库

`git add <file>`: 添加改动至 `index`：

`git commit -m <message>`: 提交改动至本地仓库

`git push origin <branch>`: 提交改动至远程仓库



## 2. Git配置

### 2.1 基础配置

让Git显示颜色

```shell
git config --global color.ui true
```



### 2.2 配置别名

```bash
git config --global alias.<alias> <command>|'<command> <-optional>'
```

常用别名：

```shell
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.cm 'commit -m'
git config --global alias.br branch
git config --global alias.last 'log -1'
```

特别好用的 `log` 别名:

```shell
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```



### 2.3 .gitignore 语法

- 空行或是以`#`开头的行即注释行将被忽略。

- 可以在前面添加正斜杠`/`来避免递归,下面的例子中可以很明白的看出来与下一条的区别。

- 可以在后面添加正斜杠`/`来忽略文件夹，例如`build/`即忽略build文件夹。

- 可以使用`!`来否定忽略，即比如在前面用了`*.apk`，然后使用`!a.apk`，则这个a.apk不会被忽略。

- `*`用来匹配零个或多个字符，如`*.[oa]`忽略所有以".o"或".a"结尾，`*~`忽略所有以`~`结尾的文件（这种文件通常被许多编辑器标记为临时文件）；`[]`用来匹配括号内的任一字符，如`[abc]`，也可以在括号内加连接符，如`[0-9]`匹配0至9的数；`?`用来匹配单个字符。



## 3. 其他

- 每个仓库的Git配置文件在`./git/config`中
- 当前用户的配置文件在`~/.gitconfig`中



