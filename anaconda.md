## 创建环境
```
conda create -n <env_name> python=<X.X>
```

## 激活环境
```
# Linux
source activate <env_name>

# Windows
conda activate <env_name>
```

## 配置conda源
```
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
conda config --append channels conda-forge
conda config --set show_channel_urls yes
```

