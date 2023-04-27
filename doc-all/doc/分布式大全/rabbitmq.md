[TOC]

# RabbitMQ工作模型

由于RabbitMQ实现了AMQP协议，所以RabbitMQ的工作模型也是基于AMQP的。
![rabbitMQ工作模型](https://img-blog.csdnimg.cn/9989a16956cb469489602714c1a3c798.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5Y-z6ICz5ZCs6aOO,size_20,color_FFFFFF,t_70,g_se,x_16)





# **Rabbitmq 集群**

集群目的就是为了实现[rabbitmq](https://so.csdn.net/so/search?q=rabbitmq&spm=1001.2101.3001.7020)的高可用性，集群分为2种

- 普通集群：主备架构，只是实现主备方案，不至于主节点宕机导致整个服务无法使用
- 镜像集群：同步结构，基于普通集群实现的队列同步

**普通集群（默认的集群模式）**

slave节点复制master节点的所有数据和状态，除了队列数据，队列数据只存在master节点，但是Rabbitmq slave节点可以实现队列的转发，也就是说消息消费者可以连接到slave节点，但是slave需要连接到master节点转发队列，由此说明只能保证了服务可以用，无法达到高可用

![img](https://img-blog.csdnimg.cn/20210226112254817.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3lhbmdzaGlodXo=,size_16,color_FFFFFF,t_70)

## 远程模式



## 双活模式



**镜像集群**
基于普通集群实现队列的集群主从，消息会在集群中同步（至少三个节点）

![在这里插入图片描述](https://img-blog.csdnimg.cn/20210226112836822.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3lhbmdzaGlodXo=,size_16,color_FFFFFF,t_70)

### 系统环境

- 172.16.10.10  计算机名：node1.rabbitmq
- 172.16.10.11  计算机名：node2.rabbitmq
- 172.16.10.12  计算机名：node3.rabbitmq

所有服务器操作系统为：CentOS Linux release 7.3.1611 (Core)

```
172.16.10.10    node1.rabbitmq node1
172.16.10.11    node2.rabbitmq node2
172.16.10.12    node3.rabbitmq node3
```

### 软件环境

- rabbitmq部署方法：yum -y install rabbitmq-server
- rabbitmq安装版本：rabbitmq-server-3.3.5-34.el7.noarch

## **部署集群**

在部署集群开始前我们还需要再次确保服务器和软件环境正确，接下来按下面步骤部署镜像集群。

1. 将node1节点的/var/lib/rabbitmq/.erlang.cookie复制到其它集群节点，因为各集群节点之间通讯必须共享相同的erlang cookie，这就是rabbitmq底层的工作原理。

```
systemctl start rabbitmq-server
scp /var/lib/rabbitmq/.erlang.cookie 172.16.10.11:/var/lib/rabbitmq/
scp /var/lib/rabbitmq/.erlang.cookie 172.16.10.12:/var/lib/rabbitmq/
```

注意：此文件是在rabbitmq-server服务第一次启动是才会生成的，并且些文件的权限为400，属主和属组为rabbitmq。所以我们需要在node1上面启动一次rabbitmq-server服务，再执行复制。

2. 将node2和node3节点启动，分别在node2和node3执行下面的命令。

```
chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
systemctl start rabbitmq-server
```

3. 将node2和node3加入到集群环境，分别在node2和node3执行下面命令。

```
rabbitmqctl stop_app
rabbitmqctl join_cluster rabbit@node1
rabbitmqctl start_app
```

4. 验证集群配置，在集群中任意一个node上面执行下在命令，查看到的结果一样。

```
rabbitmqctl cluster_status
```

![img](https://www.linux-note.cn/wp-content/uploads/2019/06/3-1.png)

\6. 最后在任何一节点执行以下命令。

```
rabbitmqctl set_policy -p nirvana-device ha-all "^\.*" '{"ha-mode":"all"}'
```

配置指定虚拟主机的所有队列为镜像模式，-p指定虚拟主机，不指定默认为 / 这样配置后我们将会有两个镜像节点，只要保障有一台rabbitmq正常工作那么集群就可以提供服务。

## **配置HAProxy+Keepalived**

为了实现我们的RabbitMQ集群高可用，我们需要在前端加一个HAProxy来代理RabbitMQ访问，另外防止HAProxy单节点故障，所以我们使用HAProxy+Keepalived+RabbitMQ的方案来实现整套集群环境。

#### ha-proxy概述

ha-proxy是一款高性能的负载均衡软件。因为其专注于负载均衡这一些事情，因此与nginx比起来在负载均衡这件事情上做的更好，更专业。

#### Keepalived

**1)keepalived是什么**
[keepalived](https://so.csdn.net/so/search?q=keepalived&spm=1001.2101.3001.7020)是集群管理中保证集群高可用的一个服务软件，其功能类似于heartbeat，用来防止单点故障。
**2)keepalived工作原理**
keepalived是以VRRP协议为实现基础的，VRRP全称Virtual Router Redundancy Protocol，即虚拟路由[冗余](https://so.csdn.net/so/search?q=冗余&spm=1001.2101.3001.7020)协议。

虚拟路由冗余协议，可以认为是实现[路由器](https://so.csdn.net/so/search?q=路由器&spm=1001.2101.3001.7020)高可用的协议，即将N台提供相同功能的路由器组成一个路由器组，这个组里面有一个master和多个backup，master上面有一个对外提供服务的vip（该路由器所在局域网内其他机器的默认路由为该vip），master会发组播，当backup收不到vrrp包时就认为master宕掉了，这时就需要根据VRRP的优先级来选举一个backup当master。这样的话就可以保证路由器的高可用了。

keepalived主要有三个模块，分别是core、check和vrrp。core模块为keepalived的核心，负责主进程的启动、维护以及全局配置文件的加载和解析。check负责健康检查，包括常见的各种检查方式。vrrp模块是来实现VRRP协议的。





### **安装HAPoryx和Keepalived**

因测试环境服务器有限，我们将HAProxy和Keepalived部署在node1和node2上面，并使用172.16.10.100为VIP，在node1和node2上面行以下命令安装。

```
yum install haproxy keepalived
```

### **Node1的Keepalived配置**

```
! Configuration File for keepalived
 
global_defs {
   router_id node1
}
 
vrrp_script chk_haproxy {
    script "/etc/keepalived/haproxy_check.sh"
    interval 2
    weight 20
}
 
vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    track_script {
        chk_haproxy
    }
    virtual_ipaddress {
        172.16.10.100/24
    }
}
```

### **Node2的Keepalived配置**

```
! Configuration File for keepalived
 
global_defs {
   router_id node2
}
 
vrrp_script chk_haproxy {
    script "/etc/keepalived/haproxy_check.sh"
    interval 2
    weight 20
}
 
vrrp_instance VI_1 {
    state BACKUP
    interface eth0
    virtual_router_id 51
    priority 90
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    track_script {
        chk_haproxy
    }
    virtual_ipaddress {
        172.16.10.100/24
    }
}
```

### **haproxy_check.sh脚本配置**

```
#!/bin/bash
 
A=`ps -C haproxy --no-header | wc -l`
if [ $A -eq 0 ];then
    haproxy -f /etc/haproxy/haproxy.cfg
    sleep 2
    if [ `ps -C haproxy --no-header | wc -l` -eq 0 ];then
        pkill keepalived
    fi
fi
```

注意：此脚本需要有执行权限。

```
chmod 755 /etc/keepalived/haproxy_check.sh
```

### **HAPorxy配置文件（Node1和Node2相同）**

```
global
     log         127.0.0.1 local2
 
     chroot      /var/lib/haproxy
     pidfile     /var/run/haproxy.pid
     maxconn     4000
     user        haproxy
     group       haproxy
     daemon
 
     stats socket /var/lib/haproxy/stats
 
 defaults
     mode                    http
     log                     global
     option                  httplog
     option                  dontlognull
     option http-server-close
     option forwardfor       except 127.0.0.0/8
     option                  redispatch
     retries                 3
     timeout http-request    10s
     timeout queue           1m
     timeout connect         10s
     timeout client          1m
     timeout server          1m
     timeout http-keep-alive 10s
     timeout check           10s
     maxconn                 4000
 
 listen rabbitmq_cluster
     bind 0.0.0.0:5670
     mode tcp
     option tcplog
     timeout client  3h
     timeout server  3h
     timeout connect 3h
     balance roundrobin
     server node1 172.16.10.10:5672 check inter 5000 rise 2 fall 3  
     server node2 172.16.10.11:5672 check inter 2000 rise 2 fall 3
     server node2 172.16.10.12:5672 check inter 2000 rise 2 fall 3
 
 listen rabbitmq_cluster
     bind 0.0.0.0:15670
     balance roundrobin
     server node1 172.16.10.10:15672 check inter 5000 rise 2 fall 3
     server node2 172.16.10.11:15672 check inter 2000 rise 2 fall 3
     server node2 172.16.10.12:15672 check inter 2000 rise 2 fall 3
```

### **开启****HAProxy****日志****（****Node1****和****Node2****相同）**

\1. 编辑/etc/rsyslog.conf，打开以下四行注释。

```
$ModLoad imudp
$UDPServerRun 514
$ModLoad imtcp
$InputTCPServerRun 514
```

\2. 增加一行配置。

```
local2.*                                                /var/log/haproxy.log
```

\3. 重启syslog服务。

```
systemctl restart rsyslog
```





### 5.然后，通过【1**.***.***.**8:15672/】，就能访问到RabbitMQ的管理后台的界面；

使用（admin，password）去登录；

guest  guest





java的retry对rabbitmq不好用啊。刚查了下原因供老哥参考下：
4.如果消费者设置了手动应答模式，并且设置了重试，出现异常时无论是否捕获了异常，都是不会重试的
5.如果消费者没有设置手动应答模式，并且设置了重试，那么在出现异常时没有捕获异常会进行重试，如果捕获了异常不会重试。



#### 官方文档

https://www.rabbitmq.com/documentation.html



#  死信队列概念

死信队列(Dead Letter Exchange)，死信交换器。**当业务队列中的消息被拒绝或者过期或者超过队列的最大长度**时，消息会被**丢弃**，但若是配置了死信队列，那么消息可以被重新发布到另一个交换器，这个交换器就是DLX，与DLX绑定的队列称为死信队列。

若业务队列想绑定死信队列，那么在声明业务队列时，需要指定DLX（死信Exchange）和DLK（死信RoutingKey）

![img](https://upload-images.jianshu.io/upload_images/16013479-c266bdc73effb3a4.png?imageMogr2/auto-orient/strip|imageView2/2/w/1116/format/webp)



死信消息的header

| 字段名                 | 含义                                                         |
| :--------------------- | :----------------------------------------------------------- |
| x-first-death-exchange | 第一次被抛入的死信交换机的名称                               |
| x-first-death-reason   | 第一次成为死信的原因，`rejected`：消息在重新进入队列时被队列拒绝，由于`default-requeue-rejected`参数被设置为`false`。`expired` ：消息过期。`maxlen`： 队列内消息数量超过队列最大容量 |
| x-first-death-queue    | 第一次成为死信前所在队列名称                                 |
| x-death                | 历次被投入死信交换机的信息列表，同一个消息每次进入一个死信交换机，这个数组的信息就会被更新 |



作者：小胖学编程
链接：https://www.jianshu.com/p/dd942c2f1e87
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

# [RabbitMQ后台管理界面 ](https://www.cnblogs.com/peterYong/p/10845560.html)

## Overview

界面有"概要"、"连接"、"通道"、"分发器"、"队列"、"用户"等几个管理页签。

概要就是RabbitMQ的基本信息

Totals里面有Unacked未确认的消息数

Nodes ：其实就是支撑RabbitMQ运行的一些机器（可以理解为集群的节点），RabbitMQ我只装在了本地，因而只能看到一个节点。

Listening ports：3个端口（5672,25672,15672）;

　　5672对应的是amqp，25672对应的是clustering，15672对应的是http（也就是我们登录RabbitMQ后台管理时用的端口）。

　　25672对应的是集群，15672对应的是后台管理。因为RabbitMQ遵循Ampq协议，所以5672对应的就是RabbitMQ的通信了。

## Connections

　　"连接"就是生产者和消费者的连接情况；

不管生产者还是消费者，其实都是应用程序（主体是计算机，有ip地址即可，物理上可以位于任何地方），都需要和rabbitmq服务器建立连接。

建立连接时，可以指定VirtualHost ：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

```java
package helloworld;
 
import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;
 
import java.io.IOException;
import java.util.concurrent.TimeoutException;
 
/**
 * 描述：发送消息的类：连接到RabbitMQ的服务端，然后发送一条消息，然后退出；
 */
public class Send {
    //我们发送消息时，需要指定要发到哪里去；所以，我们要指定队列的名字；所以，这儿我们定义队列的名字；
    //这个名字可随便取，待会在接收的消息时候，要使用这个队列；
    private final static String QUEUE_NAME = "hello";
 
    public static void main(String[] args) throws IOException, TimeoutException {
        //1.创建连接工厂
        ConnectionFactory connectionFactory = new ConnectionFactory();
        //2.设置RabbitMQ的地址（即RabbitMQ的服务端的地址）
        //这里面填写是RabbitMQ服务端所在服务器的ip地址
        connectionFactory.setHost("1**.***.***.**8");
        //然后，要想连接RabbitMQ的服务端，我么还需要通过一个用户才行；
        // 所以，这儿我们使用【前面我们设置的，能够在其他服务器上访问RabbitMQ所在服务器的，admin用户】
        connectionFactory.setUsername("admin");
        connectionFactory.setPassword("password");
        //PS:记得要放开RabbitMQ部署的服务器的，5672端口；
        //3.建立连接
        Connection connection = connectionFactory.newConnection();
        //4.获得Channel信道（我们大部分的操作，都是在信道上完成的；有了信道后，我们就可以进行操作了）
        Channel channel = connection.createChannel();
        //5.声明队列（有了队列之后，我们就可以发布消息了）
        //参数说明：第一个参数(queue)：队列名；
        // 第二个参数(durable)：这个队列是否需要持久（即，服务重启后，这个队列是否需要还存在；这儿我们根据自己的需求，设为了false；）
        //第三个参数(exclusive)：这个队列是否独有（即，这个队列是不是仅能给这个连接使用；这儿我们设为了false）
        //第四个参数(autoDelete)：这个队列是否需要自动删除（即，在队列没有使用的时候，是否需要自动删除；这儿我们设为了false）
        //第五个参数(arguments)；
        channel.queueDeclare(QUEUE_NAME, false, false, false, null);
        //6.发布消息
        String message = "测试的消息";
        //参数说明：第一个参数（exchange）是交换机，这儿我们暂时不深入了解；
        // 第二个参数（routingKey）是路由键，这儿我们就写成队列的名字；
        //第三个参数（props），消息除了消息体外，还要有props作为它的配置；
        // 第四个参数（body）消息的内容，要求是byte[]类型的，同时，需要指定编码类型
        channel.basicPublish("",QUEUE_NAME,null,message.getBytes("UTF-8"));
        System.out.println("消息发送成功了:" + message);
        //7.关闭连接：先关闭channel信道，然后关闭connection连接；
        channel.close();
        connection.close();
    }
}
      <dependencies>
        <dependency>
            <groupId>com.rabbitmq</groupId>
            <artifactId>amqp-client</artifactId>
            <version>5.8.0</version>
        </dependency>
        <dependency>
            <groupId>org.slf4j</groupId>
            <artifactId>slf4j-nop</artifactId>
            <version>1.7.29</version>
        </dependency>
    </dependencies>
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0);)

【**为什么要用虚拟主机？**

　　RabbitMQ server 可以说就是一个消息队列服务器实体（**Broker**），**Broker**当中可以有多个用户（[增加用户的命令](http://www.cnblogs.com/ericli-ericli/p/5902270.html)），而用户只能在虚拟主机的粒度进行权限控制，所以RabbitMQ中需要多个虚拟主机。每一个RabbitMQ服务器都有一个默认的虚拟主机“/”。】

**RabbitMQ多租户**

咱们装置一个 RabbitMQ 服务器，每一个 RabbitMQ 服务器都能创立出许多虚构的服务器，这些虚构的服务器就是咱们所说的虚拟主机（virtual host），个别简称为 vhost。

实质上，每一个 vhost 都是一个独立的小型 RabbitMQ 服务器，这个 vhost 中会有本人的队列、交换机以及相应的绑定关系等等，并且领有本人独立的权限，不同的 vhost 中的队列和交换机不能相互绑定，这样技能保障运行平安又能防止命名抵触。

咱们并不需要特地的去对待 vhost，他就跟一般的物理 RabbitMQ 一样，不同的 vhost 可能提供逻辑上的拆散，确保不同的利用音讯队列可能平安独立运行。

要我来说，咱们该怎么对待 vhost 和 RabbitMQ 的关系呢？RabbitMQ 相当于一个 Excel 文件，而 vhost 则是 Excel 文件中的一个个 sheet，咱们所有的操作都是在某一个 sheet 上进行操作。

## Channels

　　"通道"是建立在"连接"基础上的，实际开发中"连接"应为全局变量，"通道"为线程级；

![img](https://img2018.cnblogs.com/blog/727485/201905/727485-20190510171014671-1501454033.png)

一个连接(ip) 可以有多个通道，eg，采用多线程。

图中，机器xx.yy.57.132即开了三个通道

 一个连接（Connections）可以创建多个通道【采用多线程】；一个应用或者一个线程 都是一个通道（Channel）；在通道中 创建队列Queue

生产者的通道一般会立马关闭；消费者是一直侦听的，通道几乎是会一直存在。

 Exchange

参考：http://www.ltens.com/article-6.html

​      [RabbitMQ交换器Exchange介绍与实践](https://www.cnblogs.com/vipstone/p/9295625.html)

 

[回到顶部](https://www.cnblogs.com/peterYong/p/10845560.html#_labelTop)

## Queues

![img](https://img2018.cnblogs.com/blog/727485/201905/727485-20190510165635289-488876301.png)

是指 队列中此时含有未被消费的数据条数。

**下方可以查看队列有没有消费者（consumer）**

[回到顶部](https://www.cnblogs.com/peterYong/p/10845560.html#_labelTop)

## Admin

　　"用户管理"就是用户增删改查以及虚拟主机、规则等的配置。

 参考：[后台管理之系统管理员](http://www.ltens.com/article-9.html)

**插件管理**[![返回主页](https://www.cnblogs.com/skins/custom/images/logo.gif)](https://www.cnblogs.com/brady-wang/)

- https://i.cnblogs.com/)

# [rabbitmq之后台管理和用户设置](https://www.cnblogs.com/brady-wang/p/13334664.html)

## 前言

前面介绍了erlang环境的安装和rabbitmq环境安装，接下来介绍rabbitmq的web管理和用户设置。

## 启用后台管理插件

通过后台管理插件我们可以动态监控mq的流量，创建用户，队列等。

- 创建目录

```dos
mkdir /etc/rabbitmq
```

- 启用插件

```bash
/usr/lib/rabbitmq/bin/rabbitmq-plugins enable rabbitmq_management

# 其会在/etc/rabbitmq目录下创建一个enabled_plugins文件，这是后台管理的配置文件。
```

rabbitmq的网页管理的端口是15672，如果你是远程操作服务器，输入http://ip:15672,发现连接不上，因为服务器防火墙不允许这个端口远程访问；

```dockerfile
# 将mq的tcp监听端口和网页管理端口都设置成允许远程访问

firewall-cmd --permanent --add-port=15672/tcp
firewall-cmd --permanent --add-port=5672/tcp
systemctl restart firewalld.service
```

- 管理界面介绍

```makefile
# 输入用户名密码登录后进入主界面
Overview：用来显示流量，端口，节点等信息，以及修改配置文件；
Connections：显示所有的TCP连接；
channels:显示所有的信道连接；
exchanges:显示所有的交换机以及创建删除等；
queues:显示所有的队列以及创建删除等；
admins:显示所有的用户以及用户管理；
```

### 用户设置

- rabbitmq有一个默认的用户名和密码，guest和guest,但为了安全考虑，该用户名和密码只允许本地访问，如果是远程操作的话，需要创建新的用户名和密码；

```cpp
# root权限
rabbitmqctl add_user username passwd  //添加用户，后面两个参数分别是用户名和密码
rabbitmqctl set_permissions -p / username ".*" ".*" ".*"  //添加权限
rabbitmqctl set_user_tags username administrator  //修改用户角色,将用户设为管理员
```

注意：创建的新用户默认角色为空。

#### 用户的角色说明

```less
management:用户可以访问管理插件
policymaker:用户可以访问管理插件，并管理他们有权访问的vhost的策略和参数。
monitoring:用户可以访问管理插件，查看所有连接和通道以及与节点相关的信息。
administrator:用户可以做任何监视可以做的事情，管理用户，vhost和权限，关闭其他用户的连接，并管理所有vhost的政策和参数。
```

使用添加的账户远程访问后台管理站点，将原来的账号guest删除；

#### 用户管理命令汇总

```javascript
新建用户：rabbitmqctl add_user username passwd
删除用户：rabbitmqctl delete_user username
改密码: rabbimqctl change_password {username} {newpassword}
设置用户角色：rabbitmqctl set_user_tags {username} {tag ...}

rabbitmqctl set_permissions -p / username ".*" ".*" ".*"  //添加权限
```

#### 权限说明：

```lua
rabbitmqctl set_permissions [-pvhostpath] {user} {conf} {write} {read}
Vhostpath：虚拟主机，表示该用户可以访问那台虚拟主机；
user：用户名。
Conf：一个正则表达式match哪些配置资源能够被该用户访问。
Write：一个正则表达式match哪些配置资源能够被该用户设置。
Read：一个正则表达式match哪些配置资源能够被该用户访问。
```

- 虚拟主机

默认的用户和队列都是在/虚拟机下。

```shell
# 创建一个虚拟主机
rabbitmqctl add_vhost vhost_name
# 删除一个虚拟主机
rabbitmqctl delete_vhost vhost_name
```

### 常用文件路径

- /usr/local/rabbitmq_server/var/log/rabbitmq/rabbit@tms.log:记录rabbitmq运行日常的日志
- /usr/local/rabbitmq_server/var/log/rabbitmq/rabbit@tms-sasl.log:rabbitmq的崩溃报告
- /usr/local/rabbitmq_server/etc/rabbitmq/rabbitmq.config：rabbitmq的配置文件
- /usr/local/rabbitmq_server/var/lib/rabbitmq/mnesia/rabbit@tms：rabbit消息持久化文件

4中消息收发模式

### 2.2 fanout exchange

***\*fanout类型的exchange会忽略routingKey\****，只要队列与exchange绑定，exchange的消息就会路由到这个队列。
**producer**

```java
//创建exchange
channel.exchangeDeclare(EXCHANGE_NAME, "fanout");
//发送消息
channel.basicPublish(EXCHANGE_NAME, "", null, message.getBytes(StandardCharsets.UTF_8));



//获取队列名称
String queueName = channel.queueDeclare().getQueue();
//绑定队列
channel.queueBind(queueName, EXCHANGE_NAME, "");
```



### 2.3. direct exchange

这种类型，消息通过routingKey路由到对应队列

```java
channel.exchangeDeclare(EXCHANGE_NAME, "direct");
channel.basicPublish(EXCHANGE_NAME, "info", null, (message+" info").getBytes(StandardCharsets.UTF_8));

String queueName = channel.queueDeclare().getQueue();
channel.queueBind(queueName, EXCHANGE_NAME, "info");
```





### 2.4 topic exchange

这种模式通过主题发送，主题其实就是routingKey加了通配符。

* `*`代替一个单词
  `#`代替零个或多个单词
  一个消息的routingKey为"lazy.pink.rabbit"，它会被分发到第二个队列Q2，且只有一次，即使Q2匹配两个绑定关系。

![在这里插入图片描述](https://img-blog.csdnimg.cn/bfc0cafa2a034a6cb9b035537bc70749.png)

```java
channel.exchangeDeclare(EXCHANGE_NAME, "topic");
channel.basicPublish(EXCHANGE_NAME, "quick.orange.rabbit", null, (message+" quick.orange.rabbit").getBytes(StandardCharsets.UTF_8));

String queueName = channel.queueDeclare().getQueue();
channel.queueBind(queueName, EXCHANGE_NAME, "info");


```





2.5 headers exchange
消费者中绑定队列到exchange时，需要传递一组key-value形式的参数，其中有一对参数是"x-match"-">any"，如果这对参数不传的话，默认为"x-match"->“all”。
如果x-match的值为all，消息的header中的值要匹配队列绑定时传递的参数中的全部参数，此时消息会被路由到这个队列。如果值为any，只需要匹配参数中的一对参数即可。



```java
#生产者
    
channel.exchangeDeclare(EXCHANGE_NAME, BuiltinExchangeType.HEADERS);
Map<String, Object> headers = new HashMap<>();
headers.put("format", "pdf");
headers.put("x-match","any")
//headers.put("type", "report");
AMQP.BasicProperties properties= new AMQP.BasicProperties.Builder()
        .headers(headers).build();
String message= "hello world";
channel.basicPublish(EXCHANGE_NAME, "", properties, (message).getBytes());


#消费者
String queueName = channel.queueDeclare().getQueue();
Map<String, Object> arguments = new HashMap<>();
arguments.put("x-match",  "any"); // x-match默认为all
arguments.put("format",  "pdf");
arguments.put("type",  "report");
channel.queueBind(queueName, EXCHANGE_NAME, "",arguments);
```

$$

$$

```java
@Test
public void demo_06_Producer() {
    String routingKey = "hello";
    TestA a = new TestA();
    a.setFieldA("FBI WARNING");
    // 设置 MessageConverter 
    rabbitTemplate.setMessageConverter(new Jackson2JsonMessageConverter());
    rabbitTemplate.convertAndSend(routingKey, a);
    System.out.println("发送成功");
}



@Configuration
public class RabbitMQConfig {
    @Bean
    public RabbitListenerContainerFactory<?> rabbitListenerContainerFactory(ConnectionFactory connectionFactory){
        SimpleRabbitListenerContainerFactory factory = new SimpleRabbitListenerContainerFactory();
        factory.setConnectionFactory(connectionFactory);
        // 临时设置 MessageConverter 为 Jackson2JsonMessageConverter
        factory.setMessageConverter(new Jackson2JsonMessageConverter());
        return factory;
    }
}

```



