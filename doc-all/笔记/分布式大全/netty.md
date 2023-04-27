[TOC]

# netty框架总结

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200214215415435.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzIwMzc2OTgz,size_16,color_FFFFFF,t_70)

# 水平触发-边缘触发

```
  在非阻塞IO中，通过Selector选出准备好的fd进行操作。有两种模式，一是水平触发（LT），二是边缘触发（ET）。
  在LT模式下，只要某个fd还有数据没读完，那么下次轮询还会被选出。而在ET模式下，只有fd状态发生改变后，该fd才会被再次选出。ET模式的特殊性，使在ET模式下的一次轮询必须处理完本次轮询出的fd的所有数据，否则该fd将不会在下次轮询中被选出。

epoll中有两种触发模式，分别为
1、水平触发
水平触发为Level Triggered，简称LT。
水平触发关心的是缓冲区的状态，当缓冲区可读的时候，就会发出通知，也就是当缓冲区中只要有数据就会发出通知。

2、边缘触发
边缘触发为Edge Triggered，简称ET。
边缘触发关心的是缓冲区状态的变化，当缓冲区状态发生变化的时候才会发出通知，比如缓冲区中来了新的数据。

从上述表述可能不太看得出他们之间的区别，我们设想这样一个场景，当一次read()读取没有读取完缓冲区中的数据时，LT和ET的区别：
1、LT，此时缓冲区中还有数据，会继续发通知

2、ET，此时缓冲区状态并没有发生变化，并没有来新的数据，就不会发通知，在新数据到来之前，之前剩余的数据就无法取出。
所以在ET模式下，当读取数据的时候，一定要循环读取数据，直到缓冲区中的数据全部读取完成，一次性将数据取出。


总结：
Netty为了使每次轮询负载均衡，限制了每次从fd中读取数据的最大值，造成一次读事件处理并不会读完fd中的所有数据。在NioServerSocketChannel中，由于其工作在LT模式下，所以不需要做特殊处理，在处理完一个事件后直接从SelectionKey中移除该事件即可，如果有未读完的数据，下次轮询仍会获得该事件。而在EpollServerSocketChannel中，由于其工作在ET模式下，如果一次事件处理不把数据读完，需要手动地触发一次事件作为补偿，否则下次轮询将不会有触发的事件。
在Netty中，NioChannel体系是水平触发，EpollChannel体系是边缘触发。
```



netty线程模型

![img](https://img2018.cnblogs.com/i-beta/1279407/201911/1279407-20191125000324759-1038304912.png)

Netty抽象出两组线程池 BossGroup 专门负责接收客户端的连接, WorkerGroup 专门负责网络的读写

BossGroup 和 WorkerGroup 类型都是 NioEventLoopGroup

NioEventLoopGroup 相当于一个事件循环组, 这个组中含有多个事件循环 ，每一个事件循环是 NioEventLoop

NioEventLoop 表示一个不断循环的执行处理任务的线程， 每个NioEventLoop 都有一个selector , 用于监听绑定在该通道上的socket的网络通讯

NioEventLoopGroup 可以有多个线程, 即可以含有多个NioEventLoop

每个Boss NioEventLoop 循环执行的步骤有3步

轮询accept 事件

处理accept 事件 , 与client端建立连接 , 生成NioScocketChannel , 并将其注册到某个worker NIOEventLoop 上的 selector 上

处理任务队列的任务 ， 即 runAllTasks

每个 Worker NIOEventLoop 循环执行的步骤

轮询read, write 事件

处理i/o事件， 即read , write 事件，在对应NioScocketChannel 处理

处理任务队列的任务 ， 即 runAllTasks

每个Worker NIOEventLoop  处理业务时，会使用pipeline(管道), pipeline 中包含了boss group上NioEventLoop注册到worker 的selector 的channel , 即通过pipeline 可以获取到对应通道, 管道中维护了很多的处理器



![netty4核心源码分析第一篇一前置篇_网络](https://s2.51cto.com/images/blog/202212/19135841_639ffd912c6aa28593.png?x-oss-process=image/watermark,size_16,text_QDUxQ1RP5Y2a5a6i,color_FFFFFF,t_30,g_se,x_10,y_10,shadow_20,type_ZmFuZ3poZW5naGVpdGk=/format,webp/resize,m_fixed,w_1184)

epoll模型原理图
调用epoll_create()建立一个epoll对象(在epoll文件系统中为这个句柄对象分配资源)
调用epoll_ctl向event_epoll对象的红黑树添加相关节点,并指明对哪些事件感兴趣[比如netty层面的accept事件,读写事件等]
红黑树中的每个节点会与网卡建立回调机制,当网卡发生相应感兴趣事件,则将相关事件对应的节点加入下图的list_head双向链表中

调用epoll_wait获取双向链表中[事件集合][netty层面的selector,select]
-----------------------------------
©著作权归作者所有：来自51CTO博客作者ren5201313的原创作品，请联系作者获取转载授权，否则将追究法律责任
netty4核心源码分析第一篇一前置篇
https://blog.51cto.com/u_11108174/5952320
