```
启动MySQL
## 前面的是容器内部的文件，复制到后面主机上。这里是文件夹的复制
docker cp mysql:/var/lib/mysql F:/config/mysql/var/lib
docker cp mysql:/etc/mysql     F:/config/mysql/etc
docker cp mysql:/var/log/mysql F:/config/mysql/var/log

docker cp mysql-ser:/var/lib/mysql F:/config/mysql/var/lib/mysql
docker cp mysql-ser:/etc/mysql     F:/config/mysql/etc/mysql
docker cp mysql-ser:/var/log/mysql F:/config/mysql/var/log/mysql


docker run -d --restart=always --name mysql5.7 -``v` `F:/config/mysql/var/lib``:``/var/lib/mysql` ` -``v` ` F:/config/mysql/etc``:``/etc/mysql` ` -``v` `F:/config/mysql/var/log``:``/var/log/mysql` ` -p 3306:3306 
-e TZ=Asia``/Shanghai` ` -e MYSQL_ROOT_PASSWORD=123456 mysql:v1.0 \
--character-``set``-server=utf8mb4 \
--collation-server=utf8mb4_general_ci


docker run -d  --name mysql-server -v F:/config/mysql/var/lib:/var/lib/mysql -v F:/config/mysql/etc:/etc/mysql -v F:/config/mysql/var/log:/var/log/mysql -p 3308:3306 -e TZ=Asia/Shanghai -e MYSQL_ROOT_PASSWORD=123456 mysql --character-set-server=utf8mb4 --collation-server=utf8mb4_general_ci

docker run -d  --name mysql-server -v F:/config/mysql/var/lib:/var/lib/mysql -v F:/config/mysql/etc:/etc/mysql -v F:/config/mysql/var/log:/var/log/mysql -p 3308:3306 -e TZ=Asia/Shanghai -e MYSQL_ROOT_PASSWORD=123456 mysql --character-set-server=utf8mb4 --collation-server=utf8mb4_general_ci



docker run -d --name mysql5.7 -p 3306:3306 -e TZ=Asia/Shanghai -e MYSQL_ROOT_PASSWORD=123456 mysql:5.7

docker run -d --name mysql-ser -p 3309:3306 -e TZ=Asia/Shanghai -e MYSQL_ROOT_PASSWORD=123456 mysql



--restart=always 重启
-v /itwxe/dockerData/mysql/data:/var/lib/mysql：将数据文件夹挂载到主机
-v /itwxe/dockerData/mysql/conf:/etc/mysql：将配置文件夹挂在到主机，可以在宿主机放一份自定义 my.cnf文件，那么容器就会按自定义配置启动
-v /itwxe/dockerData/mysql/log:/var/log/mysql：将日志文件夹挂载到主机
-p 3306:3306：将容器的3306端口映射到主机的3306端口
-e MYSQL_ROOT_PASSWORD=123456：初始化123456用户的密码
--character-set-server=utf8mb4：设置字符集
--collation-server=utf8mb4_general_ci：排序方式


docker run mysql-ser -v F:/config/mysql/etc mysql:/etc/:rw 










docker run -it -v F:\config\nginx:/usr/share/nginx --name=nginx nginx

docker run -it -v F:\config\centos\pip_source:/data/pip_source --name=piptest centos:7


docker run -it --name mysql-server -v F:/config/mysql/var/lib:/var/lib/mysql -v F:/config/mysql/etc:/etc/mysql -v F:/config/mysql/var/log:/var/log/mysql -p 3308:3306 -e TZ=Asia/Shanghai -e MYSQL_ROOT_PASSWORD=123456 mysql --character-set-server=utf8mb4 --collation-server=utf8mb4_general_ci



-e D:\docker\volumes\**:/home/admin/canal-server/conf/canal.properties
应该写成
-v //d/docker/volumes/canal/1.1.5/conf/canal.properties:/home/admin/canal-server/conf/canal.properties
————————————————
版权声明：本文为CSDN博主「zpeng1921」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_23975117/article/details/120062192




iptables -t nat -A  DOCKER -p tcp --dport 8080 -j DNAT --to-destination 172.25.6.69:80



git clone https://github.com/deviantony/docker-elk.git docker-elk


docker inspect 'nginx' | grep IPAddress


docker pull canal/canal-server:v1.1.4


docker run --name canal -d canal/canal-server:v1.1.4




docker pull docker.elastic.co/elasticsearch/elasticsearch:7.10.2


docker run --name=elastic770 -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" docker.elastic.co/elasticsearch/elasticsearch:7.10.2
http://localhost:9200/

docker exec -it elastic770 /bin/bash ./bin/elasticsearch-plugin install https://github.com/medcl/elasticsearch-analysis-ik/releases/download/v7.7.0/elasticsearch-analysis-ik-7.7.0.zip


#运行kibana 注意IP一定不要写错
docker run --name kibana -e ELASTICSEARCH_HOSTS=http://127.0.0.1:9200 -p 5601:5601 -d kibana:7.17.2
http://localhost:5601/
--network elasticsearch_net
docker run -d --name kibana  -e ELASTICSEARCH_URL=http://172.25.0.1:9200 -p 5601:5601 kibana:7.17.2
```

# [已解决] 使用nolsp.exe 解决wsl、docker desktop无法启动问题

拿到nolsp.exe后，放C盘，右键开始菜单打开powershell（管理员）执行命令：

cd C:\Drivers\docker

.\nolsp.exe C:\WINDOWS\system32\wsl.exe

或者cmd（管理员）

 nolsp.exe C:\WINDOWS\system32\wsl.exe

出现success提示

————————————————
版权声明：本文为CSDN博主「licheng_god」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_28421553/article/details/119915116



# [[docker\]解决：docker桌面版报错error during connect: This error may indicate that the docker daemon is not running](https://www.cnblogs.com/taoshihan/p/14920005.html)

安装完docker桌面版后，docker version会有报错

 执行下面俩命令就可以了

cd "C:\Program Files\Docker\Docker"

DockerCli.exe -SwitchDaemon





```shell
docker run -d --name nginx -p 80:80 nginx
```



docker logs -f -t --tail 100 rmqbroker 
