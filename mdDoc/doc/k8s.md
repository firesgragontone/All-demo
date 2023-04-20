 

[TOC]



## 获取所有的上下文。

 kubectl config get-contexts



## 指定当前的上下文

1.进入k8s工作目录

cd C:\Users\Administrator.DESKTOP-80KRDB4\k8s-for-docker-desktop

2.设置执行策略

Set-ExecutionPolicy RemoteSigned

3.k8s token

eyJhbGciOiJSUzI1NiIsImtpZCI6IjdQZ3p4SVhFMnpoT2RJVWY1c1IyYkZSY3dod2V2akhsS2tUOXV5QldDb0UifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJrdWJlLXN5c3RlbSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VjcmV0Lm5hbWUiOiJ2cG5raXQtY29udHJvbGxlci10b2tlbi1wYm56OSIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50Lm5hbWUiOiJ2cG5raXQtY29udHJvbGxlciIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6IjFiYTdiYmFmLTQ1NWUtNGY4NS1iNTBkLWJmMWZiYjIwM2NjZiIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDprdWJlLXN5c3RlbTp2cG5raXQtY29udHJvbGxlciJ9.Dake5iIB2_kr6nNyMa8eQhKYO_GqaAXWeWg6hNIidPHeU6COtkPuIUSckZuVhyZ6uJ8zGWsJSR_mNLn4UjQ_HYy405C2nRsa8dJyiS3eU_tRlsGAn0UW3cVOjnjQst0z0UjMq4QFmi_ZclbSzCtjtsiBJvzRLuMwJLFHN0nKW-NjXR8YeOvzIobtKxPn_Y_qK0sqLnqE8WCLGUUSYk-EYYwbJmZ7tMHWOJTyNxTUJblaDoQw14Su5flcOt9VaK48QuJv_UvrChSbeItEVf03s47ORSk03HU0jZPQ6-zPk8U62a9hmBb2ZYWppEE1y4Df6W_2yhreFDJZz22gUzjGvQ

## 开启API Server访问代理

kubectl proxy



# 当 K8s 集群达到万级规模，阿里巴巴如何解决系统各组件性能问题？

## 1.1、应用部署方式演变

在部署应用程序的方式上，主要经历了三个时代：

**传统部署**：互联网早期，会直接将应用程序部署在物理机上

优点：简单，不需要其它技术的参与

缺点：不能为应用程序定义资源使用边界，很难合理地分配计算资源，而且程序之间容易产生影响

**虚拟化部署**：可以在一台物理机上运行多个虚拟机，每个虚拟机都是独立的一个环境

优点：程序环境不会相互产生影响，提供了一定程度的安全性

缺点：增加了操作系统，浪费了部分资源

**容器化部署**：与虚拟化类似，但是共享了操作系统

优点：

可以保证每个容器拥有自己的文件系统、CPU、内存、进程空间等

运行应用程序所需要的资源都被容器包装，并和底层基础架构解耦

容器化的应用程序可以跨云服务商、跨Linux操作系统发行版进行部署

![在这里插入图片描述](https://img-blog.csdnimg.cn/281e9da12eee4e499a0df2f3e57b2762.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5rij5rij6IuP,size_20,color_FFFFFF,t_70,g_se,x_16)————————————————
版权声明：本文为CSDN博主「渣渣苏」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/su2231595742/article/details/124182312



## 1.1.2**容器编排**问题

​	为了解决这些容器编排问题，就产生了一些容器编排的软件：

- **Swarm**：Docker自己的容器编排工具
- **Mesos**：Apache的一个资源统一管控的工具，需要和Marathon结合使用
- **Kubernetes**：Google开源的的容器编排工具

### 1.2、kubernetes简介

kubernetes，是一个全新的基于容器技术的分布式架构领先方案，是谷歌严格保密十几年的秘密武器----Borg系统的一个开源版本，于2014年9月发布第一个版本，2015年7月发布第一个正式版本。

kubernetes的本质是一组服务器集群，它可以在集群的每个节点上运行特定的程序，来对节点中的容器进行管理。目的是实现资源管理的自动化，主要提供了如下的主要功能：

**自我修复**：一旦某一个容器崩溃，能够在1秒中左右迅速启动新的容器
**弹性伸缩**：可以根据需要，自动对集群中正在运行的容器数量进行调整
**服务发现**：服务可以通过自动发现的形式找到它所依赖的服务
**负载均衡**：如果一个服务起动了多个容器，能够自动实现请求的负载均衡
**版本回退**：如果发现新发布的程序版本有问题，可以立即回退到原来的版本
**存储编排**：可以根据容器自身的需求自动创建存储卷
————————————————
版权声明：本文为CSDN博主「渣渣苏」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/su2231595742/article/details/124182312

### 1.3、kubernetes组件

一个kubernetes集群主要是由**控制节点(master)**、**工作节点(node)**构成，每个节点上都会安装不同的组件。

![在这里插入图片描述](https://img-blog.csdnimg.cn/0eaa6f53df134eeeb909c1aa42f029e6.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5rij5rij6IuP,size_20,color_FFFFFF,t_70,g_se,x_16)

master：集群的控制平面，负责集群的决策 ( 管理 )

- ApiServer : 资源操作的唯一入口，接收用户输入的命令，提供认证、授权、API注册和发现等机制

- Scheduler : 负责集群资源调度，按照预定的调度策略将Pod调度到相应的node节点上

- ControllerManager : 负责维护集群的状态，比如程序部署安排、故障检测、自动扩展、滚动更新等


- Etcd ：负责存储集群中各种资源对象的信息


node：集群的数据平面，负责为容器提供运行环境 ( 干活 )

- Kubelet : 负责维护容器的生命周期，即通过控制docker，来创建、更新、销毁容器

- KubeProxy : 负责提供集群内部的服务发现和负载均衡


- Docker : 负责节点上容器的各种操作

下面，以部署一个nginx服务来说明kubernetes系统各个组件调用关系：

1. 首先要明确，一旦kubernetes环境启动之后，master和node都会将自身的信息存储到etcd数据库中

2. 一个nginx服务的安装请求会首先被发送到master节点的apiServer组件

3. apiServer组件会调用scheduler组件来决定到底应该把这个服务安装到哪个node节点上

4. 在此时，它会从etcd中读取各个node节点的信息，然后按照一定的算法进行选择，并将结果告知apiServer

5. apiServer调用controller-manager去调度Node节点安装nginx服务

6. kubelet接收到指令后，会通知docker，然后由docker来启动一个nginx的pod

7. pod是kubernetes的最小操作单元，容器必须跑在pod中至此，

8. 一个nginx服务就运行了，如果需要访问nginx，就需要通过kube-proxy来对pod产生访问的代理
9. ![k8s调度](C:\Users\Administrator.DESKTOP-80KRDB4\Desktop\test\k8s调度.svg)

版权声明：本文为CSDN博主「渣渣苏」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/su2231595742/article/details/124182312

# 1.4、kubernetes概念

Master：集群控制节点，每个集群需要至少一个master节点负责集群的管控

Node：工作负载节点，由master分配容器到这些node工作节点上，然后node节点上的docker负责容器的运行

Pod：kubernetes的最小控制单元，容器都是运行在pod中的，一个pod中可以有1个或者多个容器

Controller：控制器，通过它来实现对pod的管理，比如启动pod、停止pod、伸缩pod的数量等等

Service：pod对外服务的统一入口，下面可以维护者同一类的多个pod

Label：标签，用于对pod进行分类，同一类pod会拥有相同的标签

NameSpace：命名空间，用来隔离pod的运行环境

————————————————
版权声明：本文为CSDN博主「渣渣苏」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/su2231595742/article/details/124182312

# 二、集群环境搭建

## 2.1、环境规划

### 2.1.1、集群类型

kubernetes集群大体上分为两类：一主多从和多住多从

一主多从：一台master节点和多台node节点，搭建简单，但是有单机故障风险，适用于测试环境
多主多从：多台master节点和多台node节点，搭建麻烦，安全性高，适用于生产环境

![img](https://img-blog.csdnimg.cn/81bc6592386644aca53636d41b2d8370.png?x-oss-process=image/watermark,type_d3F5LXplbmhlaQ,shadow_50,text_Q1NETiBA5rij5rij6IuP,size_20,color_FFFFFF,t_70,g_se,x_16)

### 2.1.2、安装方式

kubernets有多种部署方式，目前主流的方式有kubeadm、minikube、二进制包

minikube：一个用于快速搭建单节点kubernetes的工具
kubeadm：一个用于快速搭建kubernetes集群的工具
https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm/
二进制包：从官网下载每个组件的二进制包，依次去安装，此方式对于理解kubernetes组件更加有效
https://github.com/kubernetes/kubernetes
————————————————

2.1.3、主机规划
角色	IP地址	组件
master	192.168.109.100	docker，kubectl，kubeadm，kubelet
node01	192.168.109.101	docker，kubectl，kubeadm，kubelet
node02	192.168.109.102	docker，kubectl，kubeadm，kubelet
————————————————

安装虚拟机过程中注意下面选项的设置:

操作系统环境:CPU (2C)内存(2G)硬盘(50G)

语言选择:中文简体

软件选择:基础设施服务器

分区选择:自动分区

网络配置:按照下面配置网路地址信息

网络地址:192.168.109.108(每台主机都不一样惇分别为100、101、102)
子网掩码:255.255.255.0
默认网关：192.168.109.2
DNS：223.5.5.5
主机名设置：按照下面信息设置主机名

master节点：master
node节点：node1
node节点：node2

##### 5.1.2、Pod定义

下面是Pod的资源清单

```yaml
apiVersion: v1     #必选，版本号，例如v1
kind: Pod       　 #必选，资源类型，例如 Pod
metadata:       　 #必选，元数据
  name: string     #必选，Pod名称
  namespace: string  #Pod所属的命名空间,默认为"default"
  labels:       　　  #自定义标签列表
    - name: string      　          
spec:  #必选，Pod中容器的详细定义
  containers:  #必选，Pod中容器列表
  - name: string   #必选，容器名称
    image: string  #必选，容器的镜像名称
    imagePullPolicy: [ Always|Never|IfNotPresent ]  #获取镜像的策略 
    command: [string]   #容器的启动命令列表，如不指定，使用打包时使用的启动命令
    args: [string]      #容器的启动命令参数列表
    workingDir: string  #容器的工作目录
    volumeMounts:       #挂载到容器内部的存储卷配置
    - name: string      #引用pod定义的共享存储卷的名称，需用volumes[]部分定义的的卷名
      mountPath: string #存储卷在容器内mount的绝对路径，应少于512字符
      readOnly: boolean #是否为只读模式
    ports: #需要暴露的端口库号列表
    - name: string        #端口的名称
      containerPort: int  #容器需要监听的端口号
      hostPort: int       #容器所在主机需要监听的端口号，默认与Container相同
      protocol: string    #端口协议，支持TCP和UDP，默认TCP
    env:   #容器运行前需设置的环境变量列表
    - name: string  #环境变量名称
      value: string #环境变量的值
    resources: #资源限制和请求的设置
      limits:  #资源限制的设置
        cpu: string     #Cpu的限制，单位为core数，将用于docker run --cpu-shares参数
        memory: string  #内存限制，单位可以为Mib/Gib，将用于docker run --memory参数
      requests: #资源请求的设置
        cpu: string    #Cpu请求，容器启动的初始可用数量
        memory: string #内存请求,容器启动的初始可用数量
    lifecycle: #生命周期钩子
        postStart: #容器启动后立即执行此钩子,如果执行失败,会根据重启策略进行重启
        preStop: #容器终止前执行此钩子,无论结果如何,容器都会终止
    livenessProbe:  #对Pod内各容器健康检查的设置，当探测无响应几次后将自动重启该容器
      exec:       　 #对Pod容器内检查方式设置为exec方式
        command: [string]  #exec方式需要制定的命令或脚本
      httpGet:       #对Pod内个容器健康检查方法设置为HttpGet，需要制定Path、port
        path: string
        port: number
        host: string
        scheme: string
        HttpHeaders:
        - name: string
          value: string
      tcpSocket:     #对Pod内个容器健康检查方式设置为tcpSocket方式
         port: number
       initialDelaySeconds: 0       #容器启动完成后首次探测的时间，单位为秒
       timeoutSeconds: 0    　　    #对容器健康检查探测等待响应的超时时间，单位秒，默认1秒
       periodSeconds: 0     　　    #对容器监控检查的定期探测时间设置，单位秒，默认10秒一次
       successThreshold: 0
       failureThreshold: 0
       securityContext:
         privileged: false
  restartPolicy: [Always | Never | OnFailure]  #Pod的重启策略
  nodeName: <string> #设置NodeName表示将该Pod调度到指定到名称的node节点上
  nodeSelector: obeject #设置NodeSelector表示将该Pod调度到包含这个label的node上
  imagePullSecrets: #Pull镜像时使用的secret名称，以key：secretkey格式指定
  - name: string
  hostNetwork: false   #是否使用主机网络模式，默认为false，如果设置为true，表示使用宿主机网络
  volumes:   #在该pod上定义共享存储卷列表
  - name: string    #共享存储卷名称 （volumes类型有很多种）
    emptyDir: {}       #类型为emtyDir的存储卷，与Pod同生命周期的一个临时目录。为空值
    hostPath: string   #类型为hostPath的存储卷，表示挂载Pod所在宿主机的目录
      path: string      　　        #Pod所在宿主机的目录，将被用于同期中mount的目录
    secret:       　　　#类型为secret的存储卷，挂载集群与定义的secret对象到容器内部
      scretname: string  
      items:     
      - key: string
        path: string
    configMap:         #类型为configMap的存储卷，挂载预定义的configMap对象到容器内部
      name: string
      items:
      - key: string
        path: string

```

