

![img](https://p1-jj.byteimg.com/tos-cn-i-t2oaga2asx/gold-user-assets/2019/3/6/1694eb0f1d672339~tplv-t2oaga2asx-zoom-in-crop-mark:3024:0:0:0.awebp)





```
配置List注入
@Value("#{'${data.risk-level:H}'.split(',')}")
private List<String> riskLevels;
```



# [SpringBoot | @ComponentScan()注解默认扫描包范围分析 ](https://www.cnblogs.com/martin-1/p/16174602.html)

## 现象

xxx

## 默认扫描范围

在SpringBoot中使用`@ComponentScan()`注解进行组件扫描加载类时，**默认的扫描范围**是启动类(`[ProjectName]Application`)所在包(直接父包)的子包。也即需要被扫描的包下的类要位于启动类所在路径下。







# 深入源码解读SpringBoot热加载工具DevTools-类加载机制和基本流程

![深入源码解读SpringBoot热加载工具DevTools-类加载机制和基本流程](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/bcde1014ab7f4b05b7a9e108f39d3067~tplv-k3u1fbpfcp-zoom-crop-mark:3024:3024:3024:1702.awebp?)

![img](https://img-blog.csdnimg.cn/20200822171431364.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MjYyMjc2OQ==,size_16,color_FFFFFF,t_70#pic_center)

springApplication->new SpringApplication()->SpringApplication.run()->启动结束





initialize初始化模块  

配置source  配置是否为web环境  创建初始化构造器  创建应用监听器  配置应用的主方法所在的类

创建初始化构造器  

得到所需工厂集合的实例  获取传入的工厂类名、通过类加载器。获取指定的spring.factories文件

获取文件中工厂类的全路径  通过类路径反射得到工厂的class对象、构造方法 生成工厂类实例返回





# TransactionalEventListener使用场景以及实现原理，最后要躲个大坑

如果你遇到这样的业务，操作B需要在操作A事务提交后去执行，那么TransactionalEventListener是一个很好地选择。这里需要特别注意的一个点就是：当B操作有数据改动并持久化时，并希望在A操作的AFTER_COMMIT阶段执行，那么你需要将B事务声明为PROPAGATION_REQUIRES_NEW。这是因为A操作的事务提交后，事务资源可能仍然处于激活状态，如果B操作使用默认的PROPAGATION_REQUIRED的话，会直接加入到操作A的事务中，但是这时候事务A是不会再提交，结果就是程序写了修改和保存逻辑，但是数据库数据却没有发生变化，解决方案就是要明确的将操作B的事务设为PROPAGATION_REQUIRES_NEW。

————————————————
版权声明：本文为CSDN博主「Noodles Mars」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_43922449/article/details/120435157