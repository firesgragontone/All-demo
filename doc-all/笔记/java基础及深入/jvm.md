

[TOC]

# JVM内存和栈

-Xss：规定了每个线程虚拟机栈及堆栈的大小，一般情况下，256k是足够的，此配置将会影响此进程中并发线程数的大小。

-Xms：表示初始化JAVA堆的大小及该进程刚创建出来的时候，他的专属JAVA堆的大小，一旦对象容量超过了JAVA堆的初始容量，JAVA堆将会自动扩容到-Xmx大小。

-Xmx：表示java堆可以扩展到的最大值，在很多情况下，通常将-Xms和-Xmx设置成一样的，因为当堆不够用而发生扩容时，会发生内存抖动影响程序运行时的稳定性。

看了这个以后，你是否对JVM调参有了更多更深入的了解，有什么疑问就留在下方吧。



```text
获取堆内存  进程快照文件
jmap -dump:format=b,file=user.dump 1246

OOM是生成dump文件到指定位置

-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=D:\tmp

查看java进程及
jps -l


```

# [BTrace : Java 线上问题排查神器 ](https://www.cnblogs.com/fengzheng/p/7416942.html)



# 查看JVM的GC日志



jps -l

![image-20220909102715160](C:\Users\Administrator.DESKTOP-80KRDB4\AppData\Roaming\Typora\typora-user-images\image-20220909102715160.png)





1.2 thread dump日志文件的获取
       我们一般使用JVM自带的jps和jstack工具来获取thread dump文件。先用jps命令获取到应用程序的PID，获取PID之后在通过jstack命令来导出对应的thread dump日志文件。

jps -l 获取PID(Linux系统下你也可以使用 ps –ef | grep java)。
jstack -l <PID> | tee -a 文件名字
1
2
       我用一个简单的例子来说明下，比如我要获取我电脑里面basic-ioserver-websocket-server.jar程序对应的thread dump日志文件信息。

jps -l 找到basic-ioserver-websocket-server.jar对应的PID 51164
————————————————
原文链接：https://blog.csdn.net/wuyuxing24/article/details/105172184