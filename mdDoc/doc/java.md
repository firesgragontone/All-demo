[TOC]

# Closeable用法

try(){}catch{}  closeable接口

Closeable用法
1.在1.7之前，我们通过try{} finally{} 在finally中释放资源。

2.对于实现AutoCloseable接口的类的实例，将其放到try后面（我们称之为：带资源的try语句），在try结束的时候，会自动将这些资源关闭（调用close方法）。

test1方法是最常规的try{}catch{}finally{}

test2是使用closeable自动释放资源

```java
package com.canal.demo;
 
import java.io.Closeable;
import java.io.IOException;
 
public class CloseableTest implements Closeable {
    public static void test1() {
        try {
            System.out.println("test1方法 处理逻辑");
        } catch (Exception e) {
            System.out.println("test1方法 异常处理");
        } finally {
            System.out.println("test1方法 释放资源");
        }
    }
    public static void test2() {
        try (CloseableTest c = new CloseableTest()) {
            System.out.println("test2方法 处理逻辑");
        } catch (Exception e) {
            System.out.println("test2方法 处理异常");
        }
    }
    @Override
    public void close() throws IOException {
        System.out.println("test2方法这里自动释放资源");
    }
 
    public static void main(String[] args) {
        test1();
        test2();
    }
}
```

# Lambda表达式过滤

```java
Lambda表达式通过不同的过滤器过滤不同的书籍

public` `static` `List<Book> filter(Predicate<Book> where) {        
 ``List<Book> books = Catalogue.books();                 
 ``return` `books.stream().filter(where).collect(Collectors.toList());   
}

List<Book> javaBook = filter(book -> book.getCategory().equals(JAVA));               
List<Book> joshuaBlochBook = filter(book -> book.getAuthor().equals("Joshua Bloch"));

//排序功能
public List<RegionalRankingVO> regionalRankingListSortPage(List<RegionalRankingVO> vos, QueryRegionalRankingForm form) {
        List<RegionalRankingVO> ret = new ArrayList<>();
        if (ObjectUtil.isEmpty(vos)) {
            return ret;
        }
        Comparator<RegionalRankingVO> comparator = Comparator.comparing(RegionalRankingVO::getId).reversed();
        switch (form.getOrderField()) {
            //地区风险评分  upperlevelgovScoreFir: "5.3833"

            //排名  rankFir: "96/2062"
            case "rankFir":
                comparator = Comparator.comparing(o -> {
                    return o.getRankFir().split("/")[0];
                });
                comparator = comparator.reversed();
                break;
            // 地方可变现上市国企股权（亿元） iniscoreFir: "5.0744"
            case "iniscoreFir":
                //区域口径一排名
                comparator = Comparator.comparing(RegionalRankingVO::getIniscoreFir).reversed();
                break;
        }
        if (Objects.equals(SortedEnum.ASC.getValue(), form.getOrderFlag())) {
            comparator = comparator.reversed();
        }
        Integer queryFlag = form.getQueryFlag();
        if (ObjectUtil.equal(queryFlag.intValue(), RegionalRankingEnum.PROVINCE.getValue().intValue())) {
            int skipNum = form.getLimit() * (form.getPage() - 1);
            ret = vos.stream().sorted(comparator).skip(skipNum).limit(form.getLimit()).collect(Collectors.toList());
        } else if (ObjectUtil.equal(queryFlag.intValue(), RegionalRankingEnum.CITY.getValue().intValue())) {
            // 传省市：判断三级为空
            // 只传省：判断二级不为空，三级为空
            ret = vos.stream().sorted(comparator).limit(form.getLimit()).collect(Collectors.toList());
        } else if (ObjectUtil.equal(queryFlag.intValue(), RegionalRankingEnum.AREA.getValue().intValue())) {
            // 只传省市：判断三级不为空
            ret = vos.stream().sorted(comparator).limit(form.getLimit()).collect(Collectors.toList());
        }
        return ret;
    }
```

# java流分页

```java
  //分页
resultVO.setTotal((long) collect.size());
int skipnum = form.getLimit() * (form.getPage() - 1);
List<CtRqrEntityInfoVO> resultData = collect.stream().skip(skipnum).limit(form.getLimit()).collect(Collectors.toList());
```



# 多线程传入对象需要为不可变类 final

- ### Variable used in lambda expression should be final or effectively final

- lambda延迟加载

- 使用AtomicReference，安全又省心，lambda只是不支持局部变量，因为lambda在另一个线程中执行的，并且是延迟加载的，运行的时候有可能这个线程中的局部变量已经丢了，。加上final即可，加上final其实就是保存了一下这个局部变量的副本。如果非要改变，可以使用AtomicReference。另外，jdk8以后，不加final也不会报错，编译器会默认给你加上final，但是你不能修改这个值。否则编译不通过。

- #### 注意await与wait一字之差

[CountDownLatch](https://so.csdn.net/so/search?q=CountDownLatch&spm=1001.2101.3001.7020).await()方法手误写成CountDownLatch.wait()



# 直接丢弃拒绝策略导致线程池bug

我前阵子找到一个 jdk bug JDK-8286463。

大意是：任何使用直接丢弃作为拒绝策略的线程池，会导致任何 future 的 get 方法永久阻塞。

当然，可能很多人会说，是不是得到 future 以后使用超时 get 就可以规避这个问题？可惜的是，Java 里有些方法隐式地依赖 future.get，而你拿不到那个导致阻塞的 future，比如 invokeAll。

也有人说，是不是我不用直接丢弃作为拒绝策略就行？是的，Java 类库的作者认为，这个策略是现实世界中很少有用，可以说是个无用的策略。但，有很多中国的程序员在自己设计线程池的时候喜欢自作聪明地实现自己的拒绝策略，只要它等价于直接丢弃，一样会导致这个 bug。

这个问题的实质是，可以进入 dangling state 而又有可能无法被 cancel 的 task 就不应该这样设计出来，这是一种设计理念的缺陷。今天是 invokeAll 出问题，明天可能是别的 API 出问题。



```java
json 转 object
CustomerInfo customer = JSON.parseObject(jsonObject.toJSONString(),CustomerInfo.class);

Arrays.asList("L", "M", "H")
```

```java
#分页
int skipNum = form.getLimit() * (form.getPage() - 1);
list.stream().skip(skipNum).limit(form.getLimit()).collect(Collectors.toList())
    
#分组    
Map<String, List<CreditBalanceVO>> creditBalanceMap = creditBalanceList.stream().collect(Collectors.groupingBy(CreditBalanceVO::getSecondProjectTypeDict));    
    
```

```
EL表达式
java的注解解析采用了el表达式

一、EL表达式简介
EL表达式全称：Expression Language，即表达式语言
EL表达式作用：代替JSP页面中表达式脚本进行数据的输出(只能获取数据，不能设置数据)
EL表达式的格式是：${表达式} ，注：EL表达式写在jsp页面中，表达式一般是域对象的key
二、EL表达式搜索域数据的顺序

EL表达式主要是输出域对象中的数据，当四个域对象都有同一个key的值时，EL表达式会按照四个域对象的范围从小到大进行搜索，找到就输出，与四个域对象声明的先后顺序无关

四、EL表达式的运算

语法：${运算表达式}，EL表达式支持以下运算符：

1. 关系运算

2. 逻辑运算

3. 算数运算

4. empty运算

empty运算可以判断一个数据是否为空，若为空，输出true，不为空，输出false
以下几种情况为空(在原本的key之前加empty关键字)：

值为null、空串
值为Object类型的数组且长度为0 (注：其他类型的长度为0的数组值为非空)
List、Map集合元素个数为0

5. 三元运算

表达式 1？表达式 2：表达式 3
表达式1为真返回表达式2的值，表达式1为假返回表达式3的值


6. “.”点运算和“[ ]”中括号运算
   点运算可以输出某个对象的某个属性的值(getXxx或isXxx方法返回的值)
   中括号运算可以输出有序集合中某个元素的值
   注：中括号运算可以输出Map集合中key里含有特殊字符的key的值

五、EL表达式的11个隐含对象
EL表达式中的11个隐含对象是EL表达式自己定义的，可以直接使用

————————————————
版权声明：本文为CSDN博主「early_day」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/early_day/article/details/124883641
```

```
Lambda表达式
{"projectId":"53969","dateRange":"2","tag":["news","announce"]}
```



### 函数式接口用途

它们主要用在Lambda表达式和方法引用（实际上也可认为是Lambda表达式）上。

如定义了一个函数式接口如下：

```java
   @FunctionalInterface
	public interface Person {
			void sayHello(String msg);
	}
```

那么就可以使用Lambda表达式来表示该接口的一个实现(注：JAVA 8 之前一般是用匿名类实现的)：

```java
Person  personSay = message -> System.out.println("Hello " + message);
```

### serialVersionUID

serialVersionUID是Java原生序列化时候的一个关键属性，但是在不使用Java原生序列化的时候，这个属性是没有被用到的，比如基于hessian协议实现的序列化方式中没有用到这个属性。

# volatile全网超详细 

https://huaweicloud.csdn.net/63a57103b878a54545947542.html?spm=1001.2101.3001.6650.6&utm_medium=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~activity-6-124541419-blog-125493673.pc_relevant_3mothn_strategy_recovery&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2~default~BlogCommendFromBaidu~activity-6-124541419-blog-125493673.pc_relevant_3mothn_strategy_recovery&utm_relevant_index=7#1volatile_11?login=from_csdn



# java特殊关键字

![](D:\csci\工作笔记\image\java特殊关键字.png)

# java 双花表达式

new ArrayList<> () {{}} 

```java
匿名内部类`加一个`构造代码块
new ArrayList<String>(){
    //构造代码块
    { 
        add("小明");
        add("小红");
    }
	//重写父类方法
    @Override 
    public boolean add(String s) {
        return super.add(s);
    }
    //自己的方法
    public void sayHello(){
        System.out.println("hello");
    }
};

```



# 流式编程

**什么是流式编程**：流式编程通常是对集合处理，让集合中的对象像水流一样流动，分别进行去重、过滤、映射等操作，就和批量化生产线一样。利用流，我们无需迭代集合中的元素，就可以提取和操作它们，这些操作通常被组合在一起，在流上形成一条操作管道。

**流式编程的优点**：编程的逻辑分明，按照顺序依次执行，同时代码短小。
