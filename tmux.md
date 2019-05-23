## 修改 ~/.tmux.conf 配置

修改 `Ctrl-b` 为 `Ctrl-a` 或添加第二个指令前缀 `'`

```shell
set -g prefix C-a #
unbind C-b # C-b即Ctrl+b键，unbind意味着解除绑定
bind C-a send-prefix # 绑定Ctrl+a为新的指令前缀

# 从tmux v1.6版起，支持设置第二个指令前缀
set-option -g prefix2 ` # 设置一个不常用的`键作为指令前缀，按键更快些
```

修改的`~/.tmux.conf`配置文件有如下两种方式可以令其生效：

- restart tmux。
- 在tmux窗口中，先按下`Ctrl+b`指令前缀，然后按下系统指令`:`，进入到命令模式后输入`source-file ~/.tmux.conf`，回车后生效。

既然快捷指令如此方便，更为优雅的做法是新增一个加载配置文件的快捷指令 ，这样就可以随时随地load新的配置了，如下所示。

```shell
# 绑定快捷键为r
bind r source-file ~/.tmux.conf \; display-message "Config reloaded.."
```







