# Structed Streaming

## Kafka

- Spark 不支持提交 offset 至 Kafka，详见：
  - https://spark.apache.org/docs/3.3.2/structured-streaming-kafka-integration.html#kafka-specific-configurations 中对 `enable.auto.commit` 的描述，以及；
  - https://stackoverflow.com/questions/50844449/how-to-manually-set-group-id-and-commit-kafka-offsets-in-spark-structured-stream 这篇回答。

# Configurations

- `spark-env.sh` 中的环境变量在 yarn 的 cluster 模式下不对 driver 生效，需要在 `spark-defaults.property` 中配置 `spark.yarn.appMasterEnv.[EnvironmentVariableName]`
  - See https://spark.apache.org/docs/3.3.2/configuration.html#environment-variables
