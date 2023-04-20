

```
配置环境包括：yml demo,dev,pro,test,uat

spring:
  profiles:
    active: @spring.profiles.active@
  devtools:
    restart:
      enabled: false
      additional-paths: src/main/java
  # spring为开发者提供了一个名为spring-boot-devtools的模块来使Spring Boot应用支持热部署，提高开发者的   # 开发效率，无需手动重启Spring Boot应用。
  
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
  http:
    encoding:
      force-response: true
      
  HTTP encoding (HttpEncodingProperties)
  # spring.http.encoding.charset=UTF-8 # Charset of HTTP requests and responses. Added to   # the "Content-Type" header if not set explicitly.
  # spring.http.encoding.enabled=true # Whether to enable http encoding support.
  # spring.http.encoding.force= # Whether to force the encoding to the configured charset   # on HTTP requests and responses.
  # spring.http.encoding.force-request= # Whether to force the encoding to the configured   # charset on HTTP requests. Defaults to true when "force" has not been specified.
  # spring.http.encoding.force-response= # Whether to force the encoding to the   #   #    #configured charset on HTTP responses.
  # spring.http.encoding.mapping= # Locale in which to encode mapping.    
      
  activiti:
    db-history-used: true  #使用历史表，如果不配置，则工程启动后可以检查数据库，只建立了17张表，历史表没有建立
    history-level: full    #记录全部历史操作
    database-schema-update: false    #自动建表
    #    flase： 默认值。activiti在启动时，会对比数据库表中保存的版本，如果没有表或者版本不匹配，将抛出异常。
    #    true： activiti会对数据库中所有表进行更新操作。如果表不存在，则自动创建。
    #    create_drop： 在activiti启动时创建表，在关闭时删除表（必须手动关闭引擎，才能删除表）。
    #    drop-create： 在activiti启动时删除原来的旧表，然后在创建新表（不需要手动关闭引擎
    check-process-definitions: false # 自动部署验证设置:true-开启（默认）、false-关闭  在resource目录下添加processes文件夹，并且文件夹不能为空
    #    main:
    #      allow-bean-definition-overriding: true #当遇到同样名字的时候，是否允许覆盖注册
    database-schema: atc  #置建表策略，如果没有表，自动创建表  修改这个地方为大写

  quartz:
    properties:
      org:
        quartz:
          scheduler:
            instanceName: clusteredScheduler
            instanceId: AUTO   # ID设置为自动获取,每一个必须不同(所有调度器实例中是唯一的)是否为守护线程
            makeSchedulerThreadDaemon: true # 指定调度程序线程
          jobStore:
            class: org.quartz.impl.jdbcjobstore.JobStoreTX
            driverDelegateClass: org.quartz.impl.jdbcjobstore.StdJDBCDelegate
            tablePrefix: QRTZ_
            isClustered: true
            clusterCheckinInterval: 10000
            misfireThreshold: 30000 # 允许的最大作业延长时间
          threadPool:
            class: org.quartz.simpl.SimpleThreadPool
            threadCount: 20
            threadPriority: 5
            threadsInheritContextClassLoaderOfInitializingThread: true
            makeThreadsDaemons: true
    #数据库方式
    job-store-type: jdbc
  servlet:
    multipart: 
      max-request-size: 20MB  #文件大小
      max-file-size: 20MB


cscipms:
  admin:
    # 应用名称
    application-name: 风险业务综合管理SaaS平台-业务管理
    # 业务接口扫描包，多个用;隔开
    swagger-package: com.csci.china.activiti.controller;com.csci.china.rbms.business.controller
    # 需要验证码校验的接口路径 支持通配符 自动过滤拦截校验
    captcha-url:
      - /login # 登录接口
    # 多租户开关
    tenant-switch: false
    p6spy:
      - dev
      - test
    wechatWorkSwitch: false

prop:
  upload-folder: ./files


mybatis-plus:
  mapper-locations: classpath*:**/*Mapper.xml
  
  
  
  
  
  
  test配置
server:
  port: 8080  #服务器开发端口
  max-http-header-size: 65546  #最大http请求头参数
  

spring:
  datasource:
    url: jdbc:mysql://172.17.6.189/tf_test?characterEncoding=UTF-8&useUnicode=true&useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Shanghai
    username: root
    password: 123456
  redis:
    host: 172.17.8.114
    port: 6379
    timeout: 300
  mail:
    host: smtp.exmail.qq.com
    username: cscicloud@chinacsci.com
    password: NDp0T1gi3U
    properties.mail.smtp.port: 465
    properties.mail.smtp.starttls.enable: true
    properties.mail.smtp.starttls.required: true
    properties.mail.smtp.ssl.enable: true
    default-encoding: utf-8
log:
  path: /data/rbms-logs


fdfs:
  so-timeout: 1501
  connect-timeout: 2000
  thumb-image:
    width: 150
    height: 150
  tracker-list: 172.17.6.191:22122

cscipms:
  elasticsearch:
    host: 172.16.212.11:9200
  openapi:
    open-api-url: http://172.17.6.175:8080
    client-id: tf_admin
    client-secret: tfdinEhs&*2021
    client-sign-private-key: MIICdQIBADANBgkqhkiG9w0BAQEFAASCAl8wggJbAgEAAoGBAIqe8fpNWVfWFC2S9RhRuvb9EsTG7M++zjTbdfksjN6MXnd0yIrxk0uXfc3LdqKt3lFAHo7rXzkRJMK1vif5w0a7v/s3QwP8D+2NMaBirSg1EZlk35xlKswlGwNgT4Zdh/6d9K4XN69613T02iHc6WSDr89wAkRN4qmhldpvXa9XAgMBAAECgYBwHAphv+rQ8g+RqDfW+kq2dIiYYrWlcpB9CTzJT/GCD45bGDUUwjm5OgUBylrhSLLzjWLpfYyer7HGU4w98m6t84fSgRcrWn+EBAFl1yNMDb5tHazXGFGFBRFkKPq3qodu8/MXUrgshFGJj6Pu4yR9j1FRrRu+ZJktbv9y9Tj5+QJBANhmAj6R3xZPoSWs4sra9qMcG5Z+Da2wAtbBuRG+7WGK4HZZm+UmVxpLE5RV15Y1etu/o/b8lyUEGDQkrKeLX+UCQQCj/Sfos6JcZ0uNQeolfJUcE+V8EeOe+/JBjWdpAR8xJrD98Bc77ZQcdLlaYp0JUoiNLlcr9/ANZONLMZkZGEaLAkBPo6MZ0edvN5kP24OPsmvodXS1uuhfzpIM5TiuDj0gk9Kt26ai+6w8sfqfscPotP/lFa9LO4SIi+w4bHLaKlH9AkACwUUDXskyfjXBuMLDQHWM1DS9wdsuF5N5UHPVSsSIYdsFWRw60IH1fGyEvTVgK7fJj2a9gVvSDcjXwYyN5F+DAkAveirqFXcUUt2Jxjgkuth3uJC5bQb/JLxPdCWLYku4AtAoUTKjIy4p+NMPd+4mk7/9aQJ4Egqx3QLCsdbhArBC

cts.openapi.url: http://172.17.6.183
cts.openapi.url.prefix: /api

# 数据订阅平台
data.data-uri: http://data-tst.chinacsci.com/api
data.secret-key: 6c3be577bdjajjh2828e416631edadh11
data.app-id: 10000003
#data.group-id: 127302
data.group-id: 127309

warning:
  equity_changed_event_ids: 10000060,10000080
  shareholder_changed_event_ids: 10000059,10000096
  entity_rating_changed_event_ids: 10000046,10000082

mybatis-plus:
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl

# daas接口配置测试环境
daas:
  data:
    url: http://172.17.6.162/api
    secretKey: 07a49cd5-eabb-4576-9fbd-0c926f37ec0b
    accessKey: 609e1877-7f73-4f52-9167-80d4f74799fb

# 分保业务
reinsure:
  client-id: tf_admin
  org: 天府信用增进股份有限公司
  org-id: 59234580

cscipms.admin.wechatWorkSwitch: true
cscipms.admin.wechatRedirectUrl: https://tf-test.chinacsci.com/mobile

  
  
  
  
  
  /**
 * openApi配置
 *
 * @author wudan
 * @date 2021-04-23 14:59
 **/
@Configuration
@Data
@Component
@ConfigurationProperties(prefix = "cscipms.openapi")
//@PropertySource("classpath:cscipms-openapi.properties")
public class OpenApiProperties {
    /**
     * 调用方ID
     */
    private String clientId;
    /**
     * 调用方密钥
     */
    private String clientSecret;
    /**
     * token私钥
     */
    private String tokenPrivateKey;
    /**
     * toke公钥
     */
    private String tokenPublicKey;
    private String csciSignPublicKey;
    private String csciSignPrivateKey;
    /**
     * client方式调用加签私钥
     */
    private String clientSignPrivateKey;
    /**
     * 不校验token的服务
     */
    private List<String> tokenExcludeServices = new ArrayList<>();
    private List<String> signatureExcludeServices = new ArrayList<>();
    /**
     * token有效时间
     * 单位分
     */
    private int tokenAliveTime = 30;
    /**
     * token请求地址
     */
    private String openApiUrl;
}
  
  
  
  
  
  
  
  
  
  
  
```