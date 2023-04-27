1.rocketmq消费者

增加RocketMQMessageListener注解，实现onMessage方法

```java


/**
 * 预警中心数据消费者
 *
 * 设置消息监听
 * 1.监听组(consumerGroup)：监听topic(topic)：监听tag(selectorExpression)(默认监听topic下所有)
 * 2.监听消费模式(messageModel):默认负载均衡：CLUSTERING（每一个消息只发给一个消费者）、广播模式：BROADCASTING（发送给所有消费者）
 * 3.设置顺序消息处理模式(consumeMode)（默认是所有线程可以处理同一个消息队列（ConsumeMode.CONCURRENTLY）,
 *   当前消息没有线程在执行时其他线程才能够执行（ConsumeMode.ORDERLY）。
 *   ps:一个线程顺序执行一个队列表时消息监听必须使用负载均衡messageModel = MessageModel.BROADCASTING）
 *
 * @author 张易筑
 * @date 2021-09-09 10:22:26
 */
@RocketMQMessageListener(consumerGroup = "${rocketmq.consumer.group}"
        , topic = "${rocketmq.consumer.topic}"
        , selectorExpression = "${rocketmq.consumer.tags}"
        , messageModel = MessageModel.BROADCASTING)
@Slf4j
@Component
public class WarningConsumer implements RocketMQListener<String>  {

    @Autowired
    private ICompanyWarningService companyWarningService;

    @Override
    public void onMessage(String message) {
        if (ObjectUtil.isNotEmpty(message)) {
            CompanyWarning companyWarning = JSON.parseObject(JSON.toJSONString(message), CompanyWarning.class);
            if (ObjectUtil.isNotNull(companyWarning)) {
                LambdaQueryWrapper<CompanyWarning> wrapper = WrapperUtil.<CompanyWarning>lqw()
                        .eq(CompanyWarning::getPrimaryId, companyWarning.getPrimaryId())
                        .eq(CompanyWarning::getLogId, companyWarning.getLogId());
                List<CompanyWarning> companyWarnings = companyWarningService.list(wrapper);
                if (ObjectUtil.isEmpty(companyWarnings)) {
                    companyWarningService.save(companyWarning);
                }
            }
        }
    }
}
```

```text
mkdir -p E://dockerrocketmq/rmqserver01/logs
mkdir -p E://dockerrocketmq/rmqserver01/store
mkdir -p E://dockerrocketmq/rmqbroker01/logs
mkdir -p E://dockerrocketmq/rmqbroker01/store
mkdir -p E:\/dockerrocketmq\rmqbroker01\conf


docker create -p 9876:9876 --name rmqserver01 -e "JAVA_OPT_EXT=-server -Xms128m -Xmx128m -Xmn128m" -e "JAVA_OPTS=-Duser.home=/opt" -v E://dockerrocketmq/rmqserver01/logs:/opt/logs -v /usr/dockerrocketmq/rmqserver01/store:/opt/store foxiswho/rocketmq:server-4.3.2

docker run -it -d --net host --name rmqbroker01 -e "JAVA_OPT_EXT=-server -Xms128m -Xmx128m -Xmn128m" -e "JAVA_OPTS=-Duser.home=/opt" -v E://dockerrocketmq/rmqbroker01/conf/broker.conf:/etc/rocketmq/broker.conf -v E://dockerrocketmq/rmqbroker01/logs:/opt/logs -v E://dockerrocketmq/rmqbroker01/store:/opt/store --privileged=true foxiswho/rocketmq:broker-4.3.2


docker run -e "JAVA_OPTS=-Drocketmq.namesrv.addr=127.0.0.1:9876;192.168.130.128:9877 -Dcom.rocketmq.sendMessageWithVIPChannel=false" -p 8082:8080 -t styletang/rocketmq-console-ng:1.0.0




docker run -d --name rmqconsole "JAVA_OPTS=-Drocketmq.namesrv.addr=127.0.0.1:9876;Dcom.rocketmq.sendMessageWithVIPChannel=false" -p 8082:8080 -t styletang/rocketmq-console-ng:1.0.0


docker run -d --name rmqconsole -p 8180:8080 --link rmqserver:namesrv\
 -e "JAVA_OPTS=-Drocketmq.namesrv.addr=namesrv:9876\
 -Dcom.rocketmq.sendMessageWithVIPChannel=false"\
 -t styletang/rocketmq-console-ng


docker run -d -p 9876:9876 --name rmqserver  foxiswho/rocketmq:server-4.3.2

docker run -d -p 10911:10911 -p 10909:10909\
 --name rmqbroker --link rmqserver:namesrv\
 -e "NAMESRV_ADDR=namesrv:9876" -e "JAVA_OPTS=-Duser.home=/opt"\
 -e "JAVA_OPT_EXT=-server -Xms128m -Xmx128m"\
foxiswho/rocketmq:broker-4.3.2


docker run -d -p 10911:10911 -p 10909:10909  --name rmqbroker --link rmqserver:namesrv  -e "NAMESRV_ADDR=namesrv:9876" -e "JAVA_OPTS=-Duser.home=/opt" -e "JAVA_OPT_EXT=-server -Xms128m -Xmx128m" -v E://dockerrocketmq/rmqbroker01/conf/broker.conf:/etc/rocketmq/broker.conf -v E://dockerrocketmq/rmqbroker01/logs:/opt/logs -v E://dockerrocketmq/rmqbroker01/store:/opt/store --privileged=true foxiswho/rocketmq:broker-4.3.2


顺序写 随机读
consume queue可以理解为消息的索引，它里面没有消息，当然这样的存储理念也不是十全十美，对于commitlog来说，写的时候虽然是顺序写，但是读的时候却变成了完全的随机读；读一条消息先会读consume queue，再读commit log，这样增加了开销。


作者：小杰博士
链接：https://juejin.cn/post/6944894142652612638
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。





《RocketMQ实战与原理解析》——杨开元
当Consumer的处理速度跟不上消息的产生速度，会造成越来越多的消息积压，这个时候首先查看消费逻辑本身有没有优化空间，除此之外还有三种方法可以提高Consumer的处理能力。
（1）提高消费并行度
在同一个ConsumerGroup下（Clustering方式），可以通过增加Consumer实例的数量来提高并行度，通过加机器，或者在已有机器中启动多个Consumer进程都可以增加Consumer实例数。注意总的Consumer数量不要超过Topic下Read Queue数量，超过的Consumer实例接收不到消息。此外，通过提高单个Consumer实例中的并行处理的线程数，可以在同一个Consumer内增加并行度来提高吞吐量（设置方法是修改consumeThreadMin和consumeThreadMax）。
（2）以批量方式进行消费
某些业务场景下，多条消息同时处理的时间会大大小于逐个处理的时间总和，比如消费消息中涉及update某个数据库，一次update10条的时间会大大小于十次update1条数据的时间。这时可以通过批量方式消费来提高消费的吞吐量。实现方法是设置Consumer的consumeMessageBatchMaxSize这个参数，默认是1，如果设置为N，在消息多的时候每次收到的是个长度为N的消息链表。
（3）检测延时情况，跳过非重要消息
Consumer在消费的过程中，如果发现由于某种原因发生严重的消息堆积，短时间无法消除堆积，这个时候可以选择丢弃不重要的消息，使Consumer尽快追上Producer的进度

作者：loinue
链接：https://www.jianshu.com/p/9dd9369b0b38
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。






```

### 一、[RocketMq](https://so.csdn.net/so/search?q=RocketMq&spm=1001.2101.3001.7020)**优点？**

1)支持顺序性，可以做到局部有序，在单线程内使用该生产者发送的消息按照发送的顺序到达服务器并存储，并按照相同顺序被消费，但前提是这些消息发往同一服务器的同一个分区

2)采取长[轮询](https://so.csdn.net/so/search?q=轮询&spm=1001.2101.3001.7020)+PULL消费消息，配合合理的参数设置来获得更高的响应时间，实时性不低于PUSH方式

3)提供了丰富的拉取模式

4)支持10亿级别的消息堆积，不会因为堆积导致性能下降

5)高效的订阅者水平扩展机制

### 二、RocketMq如何保证高可用的？

1)master和slave 配合，master 支持读、写，slave 只读，producer 只能和 master 连接写入消息，consumer 可以连接 master 和 slave。

2)当 master 不可用或者繁忙时，consumer 会被自动切换到 slave 读。即使 master 出现故障，consumer 仍然可以从 slave 读消息，不受影响。

3)创建 topic 时，把 message queue 创建在多个 broker 组上(brokerName 一样，brokerId 不同)，当一个 broker 组的 master 不可用后，其他组的 master 仍然可以用，producer 可以继续发消息。

### **三、**RocketMq**消费者消费模式有几种？**

\1. 集群消费

一条消息只会投递到一个 Consumer Group 下面的一个实例。

\2. 广播消费

消息将对一个Consumer Group 下的各个 Consumer 实例都投递一遍。即使这些 Consumer 属于同一个Consumer Group ，消息也会被 Consumer Group 中的每个 Consumer 都消费一次。

### 四、RocketMq的消息是有序的吗？

一个topic下有多个queue，为了保证发送有序，rocketmq提供了MessageQueueSelector队列选择机制

1)可使用hash取模法,让同一个订单发送到同一个queue中，再使用同步发送，只有消息A发送成功，再发送消息B

2)rocketmq的topic内的队列机制，可以保证存储满足FIFO，剩下的只需要消费者顺序消费即可

3)rocketmq仅保证顺序发送，顺序消费由消费者业务保证

### 五、RocketMq事务消息的实现机制？

RocketMQ第一阶段发送Prepared消息时，会拿到消息的地址

RocketMQ第二阶段执行本地事物，第三阶段通过第一阶段拿到的地址去访问消息，并修改消息的状态。

RocketMQ会定期扫描消息集群中的事物消息，如果发现了Prepared消息，它会向消息发送端(生产者)确认，RocketMQ会根据发送端设置的策略来决定是回滚还是继续发送确认消息。这样就保证了消息发送与本地事务同时成功或同时失败。

### 六、RocketMq会有重复消费的问题吗？如何解决？

在网络中断的情况下可能出现，需要保证消费端处理消息的业务逻辑保持幂等性

### 七、RocketMq延迟消息？如何实现的？

RocketMQ 支持定时消息，但是不支持任意时间精度，仅支持特定的 level，例如定时 5s， 10s， 1m 等。其中，level=0 级表示不延时，level=1 表示 1 级延时，level=2 表示 2 级延时。默认的配置是messageDelayLevel=1s 5s 10s 30s 1m 2m 3m 4m 5m 6m 7m 8m 9m 10m 20m 30m 1h 2h。

Message msg = new Message(topic, tags, keys, body);

msg.setDelayTimeLevel(3);

### 八、RocketMq是推模型还是拉模型？

rocketmq不管是推模式还是拉模式底层都是拉模式，推模式也是在拉模式上做了一层封装.

消息存储在broker中，通过topic和tags区分消息队列。producer在发送消息时不关心consumer对应的topic和tags，只将消息发送到对应broker的对应topic和tags中。

推模式中broker则需要知道哪些consumer拥有哪些topic和tags，但在consumer重启或更换topic时，broker无法及时获取信息，可能将消息推送到旧的consumer中。对应consumer主动获取topic，这样确保每次主动获取时他对应的topic信息都是最新的。

### 九、RocketMq的负载均衡？

1)生产者负载均衡

从MessageQueue列表中随机选择一个(默认策略)，通过自增随机数对列表大小取余获取位置信息，但获得的MessageQueue所在的集群不能是上次的失败集群。

集群超时容忍策略，先随机选择一个MessageQueue，如果因为超时等异常发送失败，会优先选择该broker集群下其他的messeagequeue进行发送。如果没有找到则从之前发送失败broker集群中选择一个MessageQueue进行发送，如果还没有找到则使用默认策略。

2)消费者负载均衡

1)平均分配策略(默认)(AllocateMessageQueueAveragely)2)环形分配策略(AllocateMessageQueueAveragelyByCircle)3)手动配置分配策略(AllocateMessageQueueByConfig)4)机房分配策略(AllocateMessageQueueByMachineRoom)5)一致性哈希分配策略(AllocateMessageQueueConsistentHash)6)靠近机房策略(AllocateMachineRoomNearby)

### 十、RocketMq消息积压

1)提高消费并行读 同一个Consumer Group下，通过增加Consumer实例的数量来提高并行度，超过订阅队列数的Consumer实例无效。

提高单个Consumer的消费并行线程，通过修改Consumer的consumerThreadMin和consumerThreadMax来设置线程数

2)批量方式消费

通过设置Consumer的consumerMessageBathMaxSize这个参数，默认是1，一次只消费一条消息，例如设置N，那么每次消费的消息条数小于等于N

3)丢弃非重要消息

当消息发生堆积时，如果消费速度跟不上消费速度，可以选择丢弃一些不重要的消息

4)优化消息消费的过程

对于消费消息的过程一般包括业务处理以及跟数据库的交互，可以试着通过一些其他的方法优化消费的逻辑。

临时解决方案：

新建一个topic，写一个临时的分发数据的consumer程序，这个程序部署上去消费积压的数据，消费之后不做耗时的处理，直接均匀轮询写入临时建立好的queue中。临时用一部分机器来部署consumer，每一批consumer消费一个临时queue的数据。等快速消费完积压数据之后，得恢复原先部署架构，重新用原先的consumer机器来消费消息



# 十一、RocketMq消息积压

MessageListenerOrderly的加锁机制：

消费者在进行某个队列的消息拉取时首先向Broker服务器申请队列锁，如果申请到琐，则拉取消息，否则放弃消息拉取，等到下一个队列负载周期(20s)再试。这一个锁使得一个MessageQueue同一个时刻只能被一个消费客户端消费，防止因为队列负载均衡导致消息重复消费。
假设消费者对messageQueue的加锁已经成功，那么会开始拉取消息，拉取到消息后同样会提交到消费端的线程池进行消费。但在本地消费之前，会先获取该messageQueue对应的锁对象，每一个messageQueue对应一个锁对象，获取到锁对象后，使用synchronized阻塞式的申请线程级独占锁。这一个锁使得来自同一个messageQueue的消息在本地的同一个时刻只能被一个消费客户端中的一个线程顺序的消费。
在本地加synchronized锁成功之后，还会判断如果是广播模式，则直接进行消费，如果是集群模式，则判断如果messagequeue没有锁住或者锁过期(默认30000ms)，那么延迟100ms后再次尝试向Broker 申请锁定messageQueue，锁定成功后重新提交消费请求。
————————————————
版权声明：本文为CSDN博主「刘Java」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_43767015/article/details/121028059

## 问题1.为什么RocketMQ不使用Zookeeper作为注册中心呢？

答：基于性能的考虑，NameServer本身的实现非常轻量，而且可以通过增加机器的方式水平扩展，增加集群的抗压能力，而zookeeper的写是不可扩展的，而zookeeper要解决这个问题只能通过划分领域，划分多个zookeeper集群来解决，首先操作起来太复杂，其次这样还是又违反了CAP中的A的设计，导致服务之间是不连通的。

持久化的机制来带的问题，ZooKeeper 的 ZAB 协议对每一个写请求，会在每个 ZooKeeper 节点上保持写一个事务日志，同时再加上定期的将内存数据镜像（Snapshot）到磁盘来保证数据的一致性和持久性，而对于一个简单的服务发现的场景来说，这其实没有太大的必要，这个实现方案太重了。而且本身存储的数据应该是高度定制化的。

消息发送应该弱依赖注册中心，而RocketMQ的设计理念也正是基于此，生产者在第一次发送消息的时候从NameServer获取到Broker地址后缓存到本地，如果NameServer整个集群不可用，短时间内对于生产者和消费者并不会产生太大影响。

## 问题2.为什么rocketmq不保证消息的Exactly Only Once？

(1). 发送消息阶段，不允许发送重复的消息。
(2). 消费消息阶段，不允许消费重复的消息。
只有以上两个条件都满足情况下，才能认为消息是“Exactly Only Once”，而要实现以上两点，在分布式系统环
境下，不可避免要产生巨大的开销。所以 RocketMQ 为了追求高性能，并不保证此特性，要求在业务上进行去重，
也就是说消费消息要做到幂等性。RocketMQ 虽然不能严格保证不重复，但是正常情况下很少会出现重复发送、消
费情况，只有网络异常，Consumer 启停等异常情况下会出现消息重复。

## 问题3.Broker 的 Buffer 满了怎么办？

答：Broker 的 Buffer 通常指的是 Broker 中一个队列的内存 Buffer 大小，这类 Buffer 通常大小有限，如果 Buffer 满
了以后怎么办？
下面是 CORBA Notification 规范中处理方式：
(1). RejectNewEvents
拒绝新来的消息，向 Producer 返回 RejectNewEvents 错误码。
(2). 按照特定策略丢弃已有消息
a) AnyOrder - Any event may be discarded on overflow. This is the default setting for this
property.
b) FifoOrder - The first event received will be the first discarded.
c) LifoOrder - The last event received will be the first discarded.
d) PriorityOrder - Events should be discarded in priority order, such that lower priority
events will be discarded before higher priority events.
e) DeadlineOrder - Events should be discarded in the order of shortest expiry deadline first.
RocketMQ 没有内存 Buffer 概念，RocketMQ 的队列都是持久化磁盘，数据定期清除。
对于此问题的解决思路，RocketMQ 同其他 MQ 有非常显著的区别，RocketMQ 的内存 Buffer 抽象成一个无限
长度的队列，不管有多少数据进来都能装得下，这个无限是有前提的，Broker 会定期删除过期的数据，例如
Broker 只保存 3 天的消息，那么这个 Buffer 虽然长度无限，但是 3 天前的数据会被从队尾删除。
