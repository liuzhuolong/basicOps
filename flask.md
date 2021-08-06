## flask

## gunicorn
- 使用 `--log-config` 来指定日志配置，和`logging`模块使用同样配置文档
- 部署：
  ```shell
  gunicorn -w 4 --bind 0.0.0.0:8000 --log-config logging.conf serving:app
  ```
### about --preload
- 使用 `--preload` 参数，gunicorn 会在其主进程内加载 python 代码，全局变量会被加载进 master 进程内，若在 app.route() 内修改全局变量，其外的函数（例如多进程操作）会无法同步该修改，导致问题
