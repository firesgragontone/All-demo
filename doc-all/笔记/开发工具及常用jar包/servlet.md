## servlet生命周期流程

![img](https://img.jbzj.com/file_images/article/202202/2022022216595946.jpg)

其实从依赖注入的字面意思就可以知道，要将对象p注入到对象a，那么首先就必须得生成对象a和对象p，才能执行注入。所以，如果一个类A中有个成员变量p被@Autowried注解，那么@Autowired注入是发生在A的构造方法执行完之后的。

如果想在生成对象时完成某些初始化操作，而偏偏这些初始化操作又依赖于依赖注入，那么久无法在构造函数中实现。为此，可以使用@PostConstruct注解一个方法来完成初始化，@PostConstruct注解的方法将会在依赖注入完成后被自动调用。

> Constructor >> @Autowired >> @PostConstruct



## servlet与tomcat的运行流程

我们在创建Servlet时会覆盖service()方法，或doGet()/doPost(),这些方法都有两个参数，一个为代表请求的request和代表响应response。

service方法中的response的类型是ServletResponse ，HttpServletResponse是ServletResponse的子接口，功能和方法更加强大。

二 、 response的运行流程
————————————————
版权声明：本文为CSDN博主「Dream 」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_43705313/article/details/101191471







![img](https://img-blog.csdnimg.cn/20190923082426647.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzcwNTMxMw==,size_16,color_FFFFFF,t_70)



![img](https://img-blog.csdnimg.cn/20190923082459223.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzcwNTMxMw==,size_16,color_FFFFFF,t_70)