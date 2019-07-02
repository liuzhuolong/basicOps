## 创建环境
```shell
conda create -n <env_name> python=<X.X>
```

## 激活环境

```shell
# Linux
source activate <env_name>

# Windows
conda activate <env_name>
```

## 删除环境

```shell
conda remove -n <env_name> --all
```

## 配置conda源

```shell
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --append channels conda-forge
conda config --set show_channel_urls yes
```

