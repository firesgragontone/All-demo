

[TOC]



## Dubbo基本用法

本章节主要讲述如何配置dubbo，按照配置方式上分，可以分为：XML配置，properties方式配置，注解方式配置，API调用方式配置。
按照功能角度进行划分，可以分为Dubbo Provider和Dubbo Consumer。接下来章节中，分别对dubbo provider和Dubbo consumer进行讲解。

### Dubbo Provider配置

#### Provider 配置详解

配置Dubbo Provider有4种方式：XML配置，properties方式配置，API调用方式配置，注解方式配置。



@Activate称为自动激活扩展点注解，主要使用在有多个扩展点实现、需要同时根据不同条件被激活的场景中，如Filter需要多个同时激活，因为每个Filter实现的是不同的功能。

@Activate的参数

参数名	效果
String[] group()	URL中的分组如果匹配则激活
String[] value()	URL中如果包含该key值，则会激活
String[] before()	填写扩展点列表，表示哪些扩展点要在本扩展点之前激活
String[] after()	表示哪些扩展点需要在本扩展点之后激活
int order()	排序信息





​     dubbo-go架构

![在这里插入图片描述](https://img-blog.csdnimg.cn/1ae1ad0cbfe84d3ca624416caaaf4ec8.png)