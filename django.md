# 修改mysql默认路径

- 停止Mysql

  ```shell
  sudo /etc/init.d/mysql stop
  ```

- 创建新的数据库路径

  ```shell
  mkdir -p /path/to/new/mysql
  ```

- 复制原有数据

  ```shell
  sudo cp -r -p /var/lib/mysql/* /path/to/new/mysql
  sudo chown -R mysql.mysql /path/to/new/mysql
  chmod -R 700 /path/to/new/mysql
  ```

- 修改配置文件

  ```shell
  sudo cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.bak
  sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
  修改第38行为datadir         = /path/to/new/mysql
  ```

- 修改启动文件

  ```shell
  sudo vi /etc/apparmor.d/usr.sbin.mysqld
  # 在 # Allow data dir access 下 新增两行
  /path/to/new/mysql r,
  /path/to/new/mysql/** rwk,
  ```

- 配置AppArmor访问控制规则

  ```shell
  sudo vi /etc/apparmor.d/tunables/alias
  # 在最后添加别名
  alias /var/lib/mysql/ -> /path/to/new/mysql
  ```

- 重启服务

  ```shell
  sudo systemctl restart apparmor
  sudo /etc/init.d/mysql restart
  ```

  

## 使用 nginx + uWSGI部署

- 见 https://uwsgi-docs.readthedocs.io/en/latest/tutorials/Django_and_nginx.html
- 二见  https://docs.djangoproject.com/en/3.0/howto/deployment/wsgi/uwsgi/



## 配置文件

### uwsgi.ini

```
[uwsgi]

# Django-related settings
# the base directory (full path)
chdir           = /path/to/mysite/
# Django's wsgi file
module          = mysite.wsgi
# the virtualenv (full path)
# home            = /path/to/virtualenv

# process-related settings
# master
master          = true
# maximum number of worker processes
processes       = 10
# the socket (use the full path to be safe
socket          = /path/to/mysite/viperl.sock
# ... with appropriate permissions - may be needed
chmod-socket    = 666
# clear environment on exit
vacuum          = true

pidfile         = /tmp/project-master.pid
max-requests    = 5000
daemonize       = /tmp/log/mysite.log    # backend & log
harakiri        = 20
uid             = www-data
gid             = www-data
touch-reload    = /path/to/mysite/mysite/settings.py
```

