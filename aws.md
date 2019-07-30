# AWS 使用手册

## aws cli

- 安装

  ```shell
  pip install awscli
  ```

- 配置 `aws configure`

  ```shell
  mkdir ~/.aws
  touch ~/.aws/credentials
  # 写入以下信息
  [default]
  aws_access_key_id = <key_id>
  aws_secret_access_key = <secret_key>
  ```

## ECR 推送/拉取镜像

- 检索登录命令，对 Docker 客户端进行身份验证，以允许其访问您的注册表。

```shell
$(aws ecr get-login --no-include-email --region ap-northeast-1)
```

- 按照 ECR 中指引推送/拉取镜像（操作与正常镜像仓库类似）

## 算法与训练任务

- 在 sagemaker 中创建算法
- 建立训练任务，使用创建的算法或默认算法
- 算法建立后将按照预设指令运行（?)

## 使用 s3 存储

- s3下载到当前目录

  ```
  aws s3 cp s3://<s3_path> <local_path>
  ```

- 上传到s3，目录要以 / 结尾

  ```
  aws s3 cp t10k-labels-idx1-ubyte s3://sagemaker-ap-northeast-1-506907239453/wjm-mnist/
  ```