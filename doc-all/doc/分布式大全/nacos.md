# [docker安装nacos](https://www.cnblogs.com/jeecg158/p/14029453.html)

## docker安装nacos

1、搜索nacos镜像

```
docker search nacos
```

![img](data:image/gif;base64,R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw==)![点击并拖拽以移动](data:image/gif;base64,R0lGODlhAQABAPABAP///wAAACH5BAEKAAAALAAAAAABAAEAAAICRAEAOw==)

2、下载镜像

```
docker pull nacos/nacos-server
```

3、查看本地镜像，看看拉到本地没有

```
docker images
```

4、启动镜像

[nacos官方文档](https://nacos.io/zh-cn/docs/quick-start-docker.html)

```
docker run -d -p 8848:8848 --env MODE=standalone  --name nacos  nacos/nacos-server
docker run --env MODE=standalone --name nacos2 -d -p 8849:8848 nacos/nacos-server

docker run -d -p 8848:8848 --env MODE=standalone  --name nacos  nacos/nacos-server:1.1.3

docker run -d --name nacos -p 8848:8848 --env MODE=standalone --env NACOS_SERVER_IP= 127.0.0.1 nacos/nacos-server

docker run -d -p 8848:8848 --name nacos --env MODE=standalone --env SPRING_DATASOURCE_PLATFORM=mysql --env MYSQL_SERVICE_HOST=172.0.0.1 --env MYSQL_SERVICE_PORT=3306 --env MYSQL_SERVICE_DB_NAME=nacos_devtest_prod --env MYSQL_SERVICE_USER=root --env MYSQL_SERVICE_PASSWORD=root -v F:/gitcode/config/nacos/conf:/home/nacos/conf -v F:/gitcode/config/nacos/logs:/home/nacos/logs -v F:/gitcode/config/nacos/data:/home/nacos/data nacos/nacos-server


docker run -d -p 28999:8848 --name nacos --ip 172.0.0.1 --env MODE=standalone --env SPRING_DATASOURCE_PLATFORM=mysql --env MYSQL_SERVICE_HOST=172.0.0.1 --env MYSQL_SERVICE_PORT=3306 --env MYSQL_SERVICE_DB_NAME=nacos --env MYSQL_SERVICE_USER=nacos --env MYSQL_SERVICE_PASSWORD=nacos -v F:/gitcode/config/nacos/conf:/home/nacos/conf -v F:/gitcode/config/nacos/logs:/home/nacos/logs -v F:/gitcode/config.nacos/data:/home/nacos/data nacos/nacos-server

docker run -d --name nacos-mysql-standalone --net=127.0.0.1 -v F:/gitcode/config/nacos/logs:/home/nacos/logs -e MODE=standalone -e MYSQL_DATABASE_NUM=1 -e SPRING_DATASOURCE_PLATFORM=mysql -e MYSQL_MASTER_SERVICE_HOST=127.0.0.1 -e MYSQL_MASTER_SERVICE_PORT=3306 -e MYSQL_MASTER_SERVICE_USER=root -e MYSQL_MASTER_SERVICE_PASSWORD=123456 -e MYSQL_MASTER_SERVICE_DB_NAME=nacos -p 8848:8848 nacos/nacos-server







```

5、验证是否成功

http://localhost:8848/nacos
默认用户名密码都是： **nacos**