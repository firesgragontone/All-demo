1.Redisson使用

```java
RLock lock = redisson.getLock("aa");

try {
            //他人有锁，本线程直接退出(waitTime = 0)，自己有锁不解锁（leaseTime = 30）
            if (lock.tryLock(WAIT_TIME, LEASE_TIME, TimeUnit.SECONDS)) {
                //只要拿到锁了，则先清空token，防止其他无效token的请求进入队列
                setCurrSession(businessKey, null);

                //如果短时间内有多个线程（客户端）同时调用登录，只允许一个成功，其他的都放弃
                AppAuthorization appAuthorization = appAuthorizationService.getOneByBusinessKey(businessKey);
                if (ObjectUtils.isEmpty(appAuthorization)) {
                    throw new BusinessException(BusinessExceptionEnum.NO_FOUND_BUSINESS_KEY);
                }

                //登录采用异步，避免排队排不进
                String token = loginClient.login(appAuthorization.getZhongdengUserName(), appAuthorization.getZhongdengUserPassword());
                setCurrSession(businessKey, appAuthorization, token);
            }
        } catch (InterruptedException e) {
            log.error("登录获取锁失败：{}", e);
        }
    }finally{
        lock.unlock();
    }



```

2.LUA脚本的使用



3.redis集群客户端

Redis Cluster 采用数据分片机制，定义了 16384个 Slot槽位，集群中的每个Redis 实例负责维护一部分槽以及槽所映射的键值数据。

**客户端可以连接集群中任意一个Redis 实例，发送读写命令，如果当前Redis 实例收到不是自己负责的Slot的请求时，会将该slot所在的正确的Redis 实例地址返回给客户端。**

**客户端收到后，自动将原请求重新发到这个新地址，自动操作，外部透明。**





4.Redis Cluster中使用Lua脚本

不过Redis留下了一个小的逻辑口：如果在key中存在 {} ，则会使用第一个 {} 中的值进行CRC运算。那么在key命名时，如果第一个 {} 中的值相同，那么这些key就会被分配进同一个哈希槽中。
参考文章：https://blog.csdn.net/damanchen/article/details/100584171

所以如果想要使用包含多个key的Lua表达式，所有的Key必须有一个标准的命名方式：
修改个key分别为 {wlc}:test:fixqueue 和 {wlc}:test:incrkey

{wlc}:test:fixqueue为固定长度list，当前hash槽3866
————————————————
版权声明：本文为CSDN博主「Nicolimitine」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/qq_20128967/article/details/108611161



水平触发-边缘触发

```
在非阻塞IO中，通过Selector选出准备好的fd进行操作。有两种模式，一是水平触发（LT），二是边缘触发（ET）。

在LT模式下，只要某个fd还有数据没读完，那么下次轮询还会被选出。而在ET模式下，只有fd状态发生改变后，该fd才会被再次选出。ET模式的特殊性，使在ET模式下的一次轮询必须处理完本次轮询出的fd的所有数据，否则该fd将不会在下次轮询中被选出。
在Netty中，NioChannel体系是水平触发，EpollChannel体系是边缘触发。

总结：
Netty为了使每次轮询负载均衡，限制了每次从fd中读取数据的最大值，造成一次读事件处理并不会读完fd中的所有数据。在NioServerSocketChannel中，由于其工作在LT模式下，所以不需要做特殊处理，在处理完一个事件后直接从SelectionKey中移除该事件即可，如果有未读完的数据，下次轮询仍会获得该事件。而在EpollServerSocketChannel中，由于其工作在ET模式下，如果一次事件处理不把数据读完，需要手动地触发一次事件作为补偿，否则下次轮询将不会有触发的事件。
```



![在这里插入图片描述](https://img-blog.csdnimg.cn/20200214215415435.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzIwMzc2OTgz,size_16,color_FFFFFF,t_70)

```shell
keys OA_WARNING_MSG_CACHE_KEY*

hget 获取hash类型的值

hget 键名称 键
1
hmget 获取多个hash的值

hmget 键名称 键 键 键 ...
1
hgetall 获取hash中的所有数据(键和值)

hgetall 键名称
1
php代码

$redis->hgetall('hash键')
————————————————
版权声明：本文为CSDN博主「普通网友」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/m0_54866636/article/details/124018075
```

# redis key命名规范

1.建议全部大写

2.key不能太长也不能太短,键名越长越占资源，太短可读性太差

3.key 单词与单词之间以 ： 分开

 4.redis使用的时候注意命名空间，一个项目一个命名空间，项目内业务不同命名空间也不同。

一般情况下：

 \1) 第一段放置项目名或缩写 如 project

 \1) 第二段把表名转换为key前缀 如, user:

 \2) 第三段放置用于区分区key的字段,对应mysql中的主键的列名,如userid

 \3) 第四段放置主键值,如18,16

结合起来 PRO:USER:UID:18 是不是很清晰



常见的设置登录token

key： PRO:USER:LOGINNAME:373166324  

value：12kd-dsj5ce-d4445-h4sd472



# **Redis容量预估计算（扩容、申请）**

新业务场景需要使用redis时，一般会需要申请redis资源，如2G/4G/8G...申请redis容量，跟业务有关，如用户数、用户资产数、商品数量、活动数量，此外对于每一个缓存item，其缓存的key和value的长度也会影响，二者是乘积的关系；

这里给一个公式做一个快速容量预估参考：

（key的长度 + value的长度）X 数量 X 1.2

以上是一种快速计算的公式，如果想根据redis数据结构来作精确计算，可以参考下述的帖子，针对每种数据结构，结构中的变量及类型，精确算出某种结构的缓存大小，如String类型：

1个dictEntry结构，24字节，负责保存具体的键值对; 向上取整为32；

1个redisObject结构，16字节，用作val对象; 向上取整为16；

1个SDS结构，(key长度 + 9)字节，用作key字符串; 向上取整16/32/...

1个SDS结构，(val长度 + 9)字节，用作val字符串;向上取整16/32/...

当key个数逐渐增多，redis还会以rehash的方式扩展哈希表节点数组，即增大哈希表的bucket个数，每个bucket元素都是个指针(dictEntry*)，占8字节，bucket个数是超过key个数向上求整的2的n次方，如2000个key，1024<2000<2048，因此bucket个数为2048；

加上向上2的n次方取值，计算公式为：

( 32 + 16 + (keyLength+9)取整 + (valLength+9)取整 )*数量 + (数量)向上取整*8(指针大小)；

如：key长度为 13（13+9->32），value长度为15（15+9->32），key个数为2000（2000->2048）

根据上面总结的容量评估模型，容量预估值为2000 ×(32 + 16 + 32 + 32) + 2048× 8 = 240384
————————————————
版权声明：本文为CSDN博主「七海健人」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/minghao0508/article/details/124129910
