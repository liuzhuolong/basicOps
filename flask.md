## flask

### gunicorn
- 使用 `--log-config` 来指定日志配置，和`logging`模块使用同样配置文档
- 部署：
  ```shell
  gunicorn -w 4 --bind 0.0.0.0:8000 --log-config logging.conf serving:app
  ```
