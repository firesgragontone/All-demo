# maven



     <mirrorOf>*</mirrorOf> 
    
            匹配所有远程仓库。 
    
     <mirrorOf>repo1,repo2</mirrorOf> 
    
            匹配仓库repo1和repo2，使用逗号分隔多个远程仓库。 
    
     <mirrorOf>*,!repo1</miiroOf> 
    
            匹配所有远程仓库，repo1除外，使用感叹号将仓库从匹配中排除。
## 分发构件至远程仓库

distributionManagement的作用是"分发构件至远程仓库":

       mvn install 会将项目生成的构件安装到本地Maven仓库，mvn deploy 用来将项目生成的构件分发到远程Maven仓库。本地Maven仓库的构件只能供当前用户使用，在分发到远程Maven仓库之后，所有能访问该仓库的用户都能使用你的构件。

我们需要配置POM的distributionManagement来指定Maven分发构件的位置。



## maven 环境配置

spring:
  profiles:
    active: @spring.profiles.active@
  devtools:
    restart:
      enabled: false
      additional-paths: src/main/java
