# Configurations

- `spark-env.sh` 中的环境变量在 yarn 的 cluster 模式下不对 driver 生效，需要在 `spark-defaults.property` 中配置 `spark.yarn.appMasterEnv.[EnvironmentVariableName]`
  - See https://spark.apache.org/docs/3.3.2/configuration.html#environment-variables
