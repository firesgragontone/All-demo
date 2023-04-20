

spring:
  profiles:
    active: @spring.profiles.active@
  devtools:
    restart:
      enabled: false
      additional-paths: src/main/java
  # spring为开发者提供了一个名为spring-boot-devtools的模块来使Spring Boot应用支持热部署，提高开发者的开发效率，无需手动重启Spring Boot应用。
  
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
  http:
    encoding:
      force-response: true
      
  # HTTP encoding (HttpEncodingProperties)
  # spring.http.encoding.charset=UTF-8 # Charset of HTTP requests and responses. Added to the "Content-Type" header if not set explicitly.
spring.http.encoding.enabled=true # Whether to enable http encoding support.
spring.http.encoding.force= # Whether to force the encoding to the configured charset on HTTP requests and responses.
spring.http.encoding.force-request= # Whether to force the encoding to the configured charset on HTTP requests. Defaults to true when "force" has not been specified.
spring.http.encoding.force-response= # Whether to force the encoding to the configured charset on HTTP responses.
spring.http.encoding.mapping= # Locale in which to encode mapping.

      
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
      max-request-size: 20MB
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
