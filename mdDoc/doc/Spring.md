[TOC]

**1.排序接口Ordered**

Spring中提供了一个Ordered接口。从单词意思就知道Ordered接口的作用就是用来排序的。

**2.InitializingBean接口**

InitializingBean接口为bean提供了初始化方法的方式，它只包括afterPropertiesSet方法，凡是继承该接口的类，在初始化bean的时候都会执行该方法。

3.springboot的事务

Spring Boot 使用事务非常简单，首先使用注解 @EnableTransactionManagement 开启事务支持后，然后在访问数据库的Service方法上添加注解 @Transactional 便可。



不同标记注解的应用范围：

| 注解        | 含义                                         |
| ----------- | -------------------------------------------- |
| @Component  | 最普通的组件，可以被注入到spring容器进行管理 |
| @Repository | 作用于持久层                                 |
| @Service    | 作用于业务逻辑层                             |
| @Controller | 作用于表现层（spring-mvc的注解）             |



```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
测试
```

# **SpringBoot常用连接器**

**[来源](https://so.csdn.net/so/search?q=拦截器&spm=1001.2101.3001.7020)（HandlerInterceptor，ClientHttpRequestInterceptor，RequestInterceptor）**

> HandlerInterceptor—>spring-webmvc项目，org.springframework.web.servlet.HandlerInterceptor
>
> ClientHttpRequestInterceptor—>spring-web项目，org.springframework.http.client.ClientHttpRequestInterceptor
>
> RequestInterceptor—>feign-core项目，feign.RequestInterceptor
>
> 一目了然，从项目名称和包路径可以看出，3个拦截器分别属于3个不同的项目，所以他们之前的作用也有区别，在这里我大概讲一下3个拦截器的基本应用和区别：
>
> 3个拦截器的共同点，都是对http请求进行拦截，但是http请求的来源不同
>
> HandlerInterceptor是最常规的，其拦截的http请求是来自于客户端浏览器之类的，是最常见的http请求拦截器；
> ClientHttpRequestInterceptor是对RestTemplate的请求进行拦截的，在项目中直接使用restTemplate.getForObject的时候，会对这种请求进行拦截，经常被称为：RestTempalte拦截器或者Ribbon拦截器；
> RequestInterceptor常被称为是Feign拦截器，由于Feign调用底层实际上还是http调用，因此也是一个http拦截器，在项目中使用Feign调用的时候，可以使用此拦截器；
> ————————————————
> 版权声明：本文为CSDN博主「岸河」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
> 原文链接：https://blog.csdn.net/qq_42145871/article/details/108824056

## spring boot过滤器FilterRegistrationBean

- ServletRegistrationBean，
- FilterRegistrationBean，
- ServletListenerRegistrationBean，
- DelegatingFilterProxyRegistrationBean
- ![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/cb62825111fd4bc2a691051b8968cdb6~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp?)



#### 拦截器与过滤器的区别

- 1.拦截器是基于java反射机制的，而过滤器是基于函数回调的。
- 2.过滤器基于servlet实现，过滤器的主要应用场景是对字符编码、跨域等问题进行过滤。 Servlet的工作原理是拦截配置好的客户端请求，然后对Request和Response进行处理。Filter过滤器随着web应用的启动而启动，只初始化一次。
- 3.拦截器只对action起作用，而过滤器几乎可以对所有请求起作用。
- 4.拦截器可以访问action上下文、值栈里的对象，而过滤器不能。
- 5.在action的生命周期里，拦截器可以多起调用，而过滤器只能在容器初始化时调用一次。

作者：gzw
链接：https://juejin.cn/post/7094957142641213470
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

## 你一定不知道的有关HttpServletResponse和HttpServletRequest取值的两个坑

Request的 getInputStream()、getReader()、getParameter()方法互斥，也就是使用了其中一个，再使用另外的两，是获取不到数据的。除了互斥外，getInputStream()和getReader()都只能使用一次，getParameter单线程上可重复使用。

```
ClientHttpRequestInterceptor
```

## spring条件生成Bean

```
条件依赖
@ConditionalOnClass：应用中有某个类时，对应的配置才生效
@ConditionalOnMissingClass：应用中没有某个类时，对应的配置才生效
@ConditionalOnBean：Spring 容器中存在指定类的实例对象时，对应的配置才生效
@ConditionalOnMissingBean：Spring 容器中不存在指定类的实例对象时，对应的配置才生效
@ConditionalOnProperty：指定参数的值符合要求时。对应的配置才生效
@ConditionalOnResource：指定文件资源存在时，对应的配置才生效
@ConditionalOnWebApplication：当前处理 Web 环境时（WebApplicationContext），对应的配置才生效
@ConditionalOnNotWebApplication：当前为非 Web 环境时，对应的配置才生效
@ConditionalOnExpression：指定参数的值符合要求时。对应的配置才生效，此处支持 SpringEL 的表达式。
先后顺序
@AutoConfigureAfter：在指定的 Configuration 之后加载
@AutoConfigureBefore：在指定的 Configuration 之前加载
@AutoConfigureOrder：指定该 configuration 的加载顺序，默认为 0
```



## @Import注解是用来导入配置类或者一些需要前置加载的类.

在平时看源码或者很多配置类上面都会出现@Import注解,功能就是和Spring XML 里面 的 一样. @Import注解是用来导入配置类或者一些需要前置加载的类.



![在这里插入图片描述](https://img-blog.csdnimg.cn/20200604093231544.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21hbWFtYWx1bHVsdTAwMDAwMDAw,size_16,color_FFFFFF,t_70)

在分析这个方法之前，我们先看一下 getImports 方法，这个方法就是获取所有的@import 里面的类
这里是获取 @import 里面的类，大致流程如下：
1. 定义一个 visited 的集合，用作 是否已经 判断过的标志
2. 这里就是获取sourceClass 上面的 所有的 annotation，并挨个判断， 如果不是 @import ,那就 进一步递归 调用 对应的 annotation,直到全部结束
3. 加载sourceClass 里面 的@Import annotation 里面对应的类名 ,最后返回

  private Set<SourceClass> getImports(SourceClass sourceClass) throws IOException {
  	Set<SourceClass> imports = new LinkedHashSet<>();
  	Set<SourceClass> visited = new LinkedHashSet<>();
  	collectImports(sourceClass, imports, visited);
  	return imports;
  }
  // 这里就是获取sourceClass 上面的 所有的 annotation， 如果不是 @import ,那就 进一步递归 调用 对应的 annotation,直到全部结束

  ```java
  private void collectImports(SourceClass sourceClass, Set<SourceClass> imports, Set<SourceClass> visited)
  		throws IOException {
  if (visited.add(sourceClass)) {
  	for (SourceClass annotation : sourceClass.getAnnotations()) {
  		String annName = annotation.getMetadata().getClassName();
  		if (!annName.equals(Import.class.getName())) {
  			collectImports(annotation, imports, visited);
  		}
  	}
  	imports.addAll(sourceClass.getAnnotationAttributes(Import.class.getName(), "value"));
  }
  ```
  }
  ————————————————
  版权声明：本文为CSDN博主「一直打铁」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
  原文链接：https://blog.csdn.net/mamamalululu00000000/article/details/86711079

### @Import导入Bean的流程图

![在这里插入图片描述](https://img-blog.csdnimg.cn/20200604105229956.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L21hbWFtYWx1bHVsdTAwMDAwMDAw,size_16,color_FFFFFF,t_70)

大致的流程如下:

1. 判断 importCandidates 是否为空，为空 退出

   判断isChainedImportOnStack ，如果为true ,加入 problemReporter 里面的error ，并退出

   把当前的 configClass 加入到 ImportStack里面，ImportStack 是继承了 ArrayDeque // TODO 和实现了 ImportRegistry// TODO

   对 getImports 里面获取到的 需要import 的类 进行遍历 处理

2. 如果是 ImportSelector 类型，首先实例一个 ImportSelector 对象，然后 对其进行 Aware 扩展(如果 实现了 Aware 接口)

3. 进一步判断 是否 是 DeferredImportSelector 类型，如果是 ，加入到 deferredImportSelectors 里面，最后处理 ，这里可以看一下 方法parse(Set configCandidates)， 里面最后一行才调用,这也就是 有的时候，如果想最后注入，就可以定义为deferredImportSelectors 类型

4. 如果 不是 DeferredImportSelector 类型 ，那就 调用 selectImports 方法，获取到所有的需要 注入的类，这时 再次调用 processImports 方法，这里调用processImports 方法，其实 是把 这些需要注入的类当成普通的 @Configuration 处理

5. 如果是 ImportBeanDefinitionRegistrar 类型，这里也是 先实例一个对象，然后加入到 importBeanDefinitionRegistrars 里面，后续 会在 ConfigurationClassBeanDefinitionReader 这个类里面 的 loadBeanDefinitionsFromRegistrars 方法处理的

6. 如果上面两种类型都不是，那就是当初普通的 带有@Configuration 的类进行处理了
   ————————————————
   版权声明：本文为CSDN博主「一直打铁」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
   原文链接：https://blog.csdn.net/mamamalululu00000000/article/details/86711079



```java

    @ApiOperation("生成跟踪报告")#
    @ResponseBody  #bean转json
    @PostMapping(value = "/generate-track-report", produces = "application/json;charset=UTF-8")
    public CommonResultVO generateTrackReport(@RequestBody @Validated IntegrationTrackReportForm form, HttpServletResponse response) {
        tradeRivalService.generateTrackReport(form, response);
        return CommonResultVO.successResult();
    }

BeanUtil.beanToMap(tradeRivalService.integrationTrackReport(form))
```

## **@Transactional不生效的场景**

**1、用在非public方法**

@Transactional是基于动态代理的，Spring的代理工厂在启动时会扫描所有的类和方法，并检查方法的修饰符是否为public，非public时不会获取@Transactional的属性信息，这时@Transactional的动态代理对象为空。

**2、同一个类中，非@Transactional方法调用@Transactional方法**

还是动态代理的原因，类内部方法的调用是通过this调用的，不会使用动态代理对象，事务不会回滚。

**3、异常被“吃了”**

Spring是根据抛出的异常来回滚的，如果异常被捕获了没有抛出的话，事务就不会回滚。

**4、rollbackFor属性设置不对**

Spring默认抛出unchecked异常或Error时才会回滚事务，要想其他类型异常也回滚则需要设置rollbackFor属性的值。

**5、数据库引擎不支持事务**

作者：程序员Mark_Chou
链接：https://juejin.cn/post/6844904120801820685
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。



## springboot之SpringBootServletInitializer生成war包

   对于Spring Boot应用，我们一般会打成jar包使用内置[容器](https://cloud.tencent.com/product/tke?from=10680)运行，但是有时候我们想要像使用传统springweb项目一样，将Spring Boot应用打成WAR包，然后部署到外部容器运行，那么我们传统的使用Main类启动的方式稍显蹩脚，因为外部容器无法识别到应用启动类，需要在应用中继承SpringBootServletInitializer类，然后重写config方法，将其指向应用启动类。

​    在本篇文章中，我们将介绍SpringBootServletInitializer的原理和使用。它是WebApplicationInitializer的扩展，从部署在Web容器上的传统WAR文件运行SpringApplication。 此类将Servlet，Filter和ServletContextInitializer bean从应用程序上下文绑定到[服务器](https://cloud.tencent.com/product/cvm?from=10680)。

​    扩展SpringBootServletInitializer类还允许我们通过覆盖configure()方法来配置servlet容器运行时的应用程序。

 引用：

【1】https://cloud.tencent.com/developer/article/1749644

### 找不到文件类路径

![image-20230103172349285](C:\Users\Administrator.DESKTOP-80KRDB4\AppData\Roaming\Typora\typora-user-images\image-20230103172349285.png)



# AOP使用

1.自定义注解

2.通过切面表达式，通过注解判定进入切面方法

3.切面方法有before ,afer,throwing等，能够对目标方法进行增强

4.切面方法的通过逻辑判定能够处理业务

 a.关联redis查询session信息，

 b.关联mysql查询客户信息

```java
java的配合
@Around("pointCut()")
public Object errorHandler(ProceedingJoinPoint point) throws Throwable {
    try {
        return point.proceed();
    } catch (Throwable e) {
        return handleZdLoginException(point, e);
    }
}

切点表达式
@Pointcut("@within(com.csci.china.zhongdeng.common.annotation.ZdRetry) || @annotation(com.csci.china.zhongdeng.common.annotation.ZdRetry)")
    private void pointCut() {
}
```

