

## Shiro认证流程

用户认证时携带身份和凭证信息（一般是用户名和密码），Shiro会将我们提供的信息打包成一个Token令牌，然后将Token给Shiro中的Security Manager去进行校验。校验具体流程是：Security Manager调用Authenticator，Authenticator调用Pluggable Realms获取原始数据，然后将原始数据和用户提供的信息相匹配，如果一致，则认证成功。



**shiro类图**

## 

## ![缺失](https://img-blog.csdnimg.cn/20190612220222596.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L2xkazk5Xw==,size_16,color_FFFFFF,t_70)



# Spring+shiro session与线程池的坑

在java web编程中，经常使用shiro来管理session，也确实好用，但有时候会踩坑。

#### shiro来获取session的方式导致了复用线程时复用上个用户的session

SecurityUtils.*getSubject*().getSession()

其中SecurityUtils的getSubject代码如下

```java
/**
     * Returns the currently accessible {@code Subject} available to the calling code depending on
     * runtime environment.
     * <p/>
     * This method is provided as a way of obtaining a {@code Subject} without having to resort to
     * implementation-specific methods.  It also allows the Shiro team to change the underlying implementation of
     * this method in the future depending on requirements/updates without affecting your code that uses it.
     *
     * @return the currently accessible {@code Subject} accessible to the calling code.
     * @throws IllegalStateException if no {@link Subject Subject} instance or
     *                               {@link SecurityManager SecurityManager} instance is available with which to obtain
     *                               a {@code Subject}, which which is considered an invalid application configuration
     *                               - a Subject should <em>always</em> be available to the caller.
     */
    public static Subject getSubject() {
        Subject subject = ThreadContext.getSubject();
        if (subject == null) {
            subject = (new Subject.Builder()).buildSubject();
            ThreadContext.bind(subject);
        }
        return subject;
    }
　　
```

获取进程上下文，这个存在了问题，如果在使用线程池，获取的就是线程池里面的session，如果线程池为配置过期时间，那么线程池里面的线程一直不变，就会出现在线程池里面getsession就会是上一次的session，导致获取session失败。

#### 结论总结

也就是说，子线程的session一直都是他的创建者的session，假如第一个用户A使用线程池，创建出10个线程，后续用户B、C、D，如果直接复用线程，拿到的都是用户A的session。

#### 解决方法

从父线程获取用户信息 Subject subject = ThreadContext.getSubject();
在子线程设置用户信息 ThreadContext.bind(subject);

#### 定时任务线程中设置管理员权限

```
DefaultWebSecurityManager manager = new DefaultWebSecurityManager();
ThreadContext.bind(manager);
```