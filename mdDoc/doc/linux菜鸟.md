

[TOC]

# 命令概览

![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/37fd24842de04cc09c450c73889fd995~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

# 接下来，我们大体看一下linux上的默认目录，对其有一个基本的感觉。

| 第1层 | 第二层 | 介绍                                                         |
| ----- | ------ | ------------------------------------------------------------ |
| /bin  |        | 目录/usr/bin的软链接                                         |
| /sbin |        | 目录/usr/sbin的软链接                                        |
| /lib  |        | 目录/usr/lib的软链接                                         |
| /usr  | /bin   | 存放一些常用的命令                                           |
| /usr  | /sbin  | 存放一些管理员常用的命令                                     |
| /usr  | /lib   | 用来存放动态库和一些模块文件                                 |
| /sys  |        | 内核中的数据结构的可视化接口                                 |
| /proc |        | 内存映像                                                     |
| /run  |        | 内存映像                                                     |
| /boot |        | 存放引导程序，内核相关文件                                   |
| /dev  |        | 存放一些设备文件，比如光盘                                   |
| /etc  |        | 用于存储一些全局的、应用的配置文件                           |
| /var  |        | 与/var/run一样，存放的是系统运行时需要的文件，比如mysql的pid等 |
| /tmp  |        | 非常特殊的临时文件夹，断电丢失                               |
| /home | /**    | 用户目录，比如我的目录是/home/xjjdog                         |
| /root |        | root用户的home目录                                           |
|       |        |                                                              |

- `home` 平常，我们打交道最多的目录，就集中在自己的用户目录，我们可以在里面做任何操作，比如我们现在root用户的`/root`目录。一些自己的资料，比如视频、音频、下载的文件，或者做测试用的一些数据资料，就可以自行在这些目录下规划。root用户比较特殊，普通用户的私人目录都是在/home下的。
- `/etc` etc目录是经常要打交道的目录，存放了一些全局的系统配置文件和应用配置文件。比如你安装了php，或者nginx，它们的配置文件就躺在/etc目录下的某个文件夹里。
- `/var` var目录存放一些运行中的数据，有必须的，也有非必须的。一些黑客入侵之后，会在这里面的某些文件中留下痕迹，他们会着重进行清理。var目录还是一些应用程序的默认数据存放之地，比如mysql的数据文件。
- `/tmp` 目录是一个特殊的临时目录，文件在断电以后就消失了。但这个目录，所有的用户，都有写入权限，通常用来做文件交换用。
- `/proc`和`/sys`目录，是两个神奇的目录。它们两个是一种伪文件系统，可以通过修改其中一些文件的状态和内容，来控制程序的行为（修改后会直接刷到内存上，太酷了）。刚开始的时候，只有proc目录，由于里面内容有多又乱，后面又规划出sys目录，用来控制内核的一些行为。如果你在调优一些系统参数，和这些文件打交道的时间比较多。
- 还有几个空的目录，我们没有列在上面的表格上。比如`/srv`目录，通常会把一些web服务的资料，比如nginx的，放在这里面。但是，这并不是强制要求的，所以我见过的`/srv`目录，通常会一直是空的。同样的，`/opt`目录也是这样一个存在，你就当它不存在就行。这都属于使用者规划的范畴，自定义性非常强。
- 在使用Linux系统的时候，也可以创建自己的目录。比如，我就喜欢自己创建一个叫做`/data`的目录，用来存放一些数据库相关的内容。举个例子，`/data/mysql`存放mariadb的数据，而`/data/es/`存放elasticsearch的索引内容。

linux上的文件类型有很多，它们大部分都分门别类的存放在相应的目录中，比如/dev目录下，就是一些设备文件；/bin文件下，是一些可以执行命令。通常都好记的很。



## 1.1 目录操作

### 1.1.1 基本操作

```shell
#创建目录和父目录
mkdir -p a/b/c/d
#拷贝目录
cp -rvf a/ /tmp/
#移动目录
mv -vf a /tmp/p
#删除机器上所有文件
rm -rvf /
#新建文件
touch a.txt

# 带上 -l参数，可以查看一些更加详细的信息。
ls /

# 带上 -l参数，可以查看一些更加详细的信息。
ls -l  #列出文件的详细信息
ls -a  #列出所有文件，包括隐藏文件
ls -t  #根据修改时间排序显示
ls -c  #根据ctime排序显示
ls -color #显示彩色
cd . #当前目录
cd .. #上层目录
cd ../ #指的是上层目录
cd ../../ #指的是上两层目录
cd ./ #指的是当前目录
cd ~ #指的是当前的用户目录，这是一个缩写符号
cd - #使用它，可以在最近两次的目录中来回切换

#10到20的数字，每一个数字单独一行，写入一个叫做spring的文件。
seq 1 10 > spring   # > 表示重定向
seq 10 20 >> spring # >> 表示追加
cat spring          #打印文件

#生成 一千万行记录  
seq 10000000 > spring
#查看大小
du -h spring
#滚动翻页
less spring
        #滚动翻页
        #空格 向下滚屏翻页
        #b 向上滚屏翻页
        #/ 进入查找模式，比如/1111将查找1111字样
        #q 退出less#
        #g 到开头
        #G 去结尾
        #j 向下滚动
        #k 向上滚动，这两个按键和vim的作用非常像
#head可以显示文件头，tail可以显示文件尾。它们都可以通过参数-n，来指定相应的行数。
head -n 3 spring
tail -n 3 spring

tail 滚动查看日志
tail -f /var/log/messages
tail -f /var/log/messages|grep info

查找文件
find / -name de.py -type f  -perm x -mtime 1 -user cjy -group saas
time find / -name de.py -type f 

# 删除当前目录中的所有class文件
find .|grep .class$ | xargs rm -rvf
# 找到/root下一天前访问的文件
find /root -atime 1 -type f
#找到归属于root用户的文件
find /root -user root
#找到大于 1MB的文件，进行清理
find /root -size +1024k -type f| xargs rm -f

#数据来源
stat spring
[root@localhost ~]# stat spring
  File: ‘spring’
  Size: 78888897  	Blocks: 154080     IO Block: 4096   regular file
Device: fd00h/64768d	Inode: 8409203     Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Context: unconfined_u:object_r:admin_home_t:s0
Access: 2019-11-04 18:01:46.698635718 -0500
Modify: 2019-11-04 17:59:38.823458157 -0500
Change: 2019-11-04 17:59:38.823458157 -0500
 Birth: -

stat spring | tail -n 3 | head -n 1
stat spring | head -n 7 | tail -n 1
stat spring | grep Modify
stat spring | sed -n '7p'
stat spring | awk 'NR==7'

grep -rn --color POST access.log

# A after 内容后n行
# B before 内容前n行#
# C 内容前后n行
#查看Exception 关键字的前2行和后10行
grep -rn --color Exception -A10 -B2 error.log
grep -rn --color Exception -A10 -B2 error.log
#查找/usr/下所有import关键字，一级
grep -rn --color import /usr/

#输出69
seq 20 100 | head -n 50 | tail -n 1

cat aaa >b
cat aa > b 2>&1

cat > sort.txt << EOF

#根据第一列倒序排序
cat sort.txt | sort -n -k1 -r
# 统计每一行出现的次数，并根据出现次数倒序排序
cat sort.txt | sort | uniq -c | sort -n -k1 -r

#找到系统中所有的grub.cfg文件，并输出它的行数。
find /| grep grub.cfg | xargs wc -l

mkdir a;
```



ls参数 ![img](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/ea4b7bd321264630a5241aa21982fab0~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

 rm参数

![img](https://p9-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/dcf54e5e55e348909001dc4ebc292989~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

cp 参数

![img](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/95da008cb1154a50ac17c6b6a268cbf2~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

less参数

![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/aac69ffdfb704db38934a28d62080397~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

find 参数

![img](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/55d4e7c52f8649d3bcbe5d0f7a42f19e~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

grep参数

![img](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/0e1fbad331af40b8b56068b0e3552c28~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

![img](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/7cc493aa143b4aa696797db74c0d54e3~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

特殊文件类型

- `-` 表示普通文件
- `d` 表示目录文件
- `l` 表示链接文件，比如快捷方式
- `s` 套接字文件
- `c` 字符设备文件，比如`/dev/`中的很多文件
- `b` 表示块设备文件，比如一些磁盘
- `p` 管道文件
- Linux上的文件可以没有后缀，而且可以创建一些违背直觉的文件。比如后缀是png，但它却是一个压缩文件（通常不会这么做）。大学时，就有聪明的同学这样藏小电影，效果很好。



1.1.2漫游

```shell
ls   查看当前目录所有内容
pwd  看到当前终端所在的目录
cd   
find
where
echo "hello world","fuck 996"
whereis echo

#创建文件 输入命令 执行命令文件
touch jdsjf
echo "echo 'Hello World'" > jdsjf
./jdsjf


#添加文件权限
chmod u+x jdsjf

```

1.2 文本处理

![img](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/508e2a74206b49ee8276b17f060f1f78~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

“最常用的vim、sed、awk技巧系列”。

1.2.1查看文件

```shell
#查看文件大小
du -h file
#查看文件内容
cat file
#
less
#查看nginx的滚动日志
tail -f access.log
tail -n100 aceess.log
head -n100 access.log

```

1.2.2统计

sort和uniq经常配对使用。 sort可以使用`-t`指定分隔符，使用`-k`指定要排序的列。

下面这个命令输出nginx日志的ip和每个ip的pv，pv最高的前10

```shell
# 2019-06-26T10:01:57+08:00|nginx001.server.ops.pro.dc|100.116.222.80|10.31.150.232:41021|0.014|0.011|0.000|200|200|273|-|/visit|sign=91CD1988CE8B313B8A0454A4BBE930DF|-|-|http|POST|112.4.238.213

awk -F"|" '{print $3}' access.log | sort | uniq -c | sort -nk1 -r | head -n10

```

1.2.3

**grep**
grep用来对内容进行过滤，带上`--color`参数，可以在支持的终端可以打印彩色，参数`n`则输出具体的行数，用来快速定位。
比如：查看nginx日志中的POST请求。

```shell
grep -rn --color POST access.log
```

如果我想要看某个异常前后相关的内容，就可以使用ABC参数。它们是几个单词的缩写，经常被使用。 **A** after 内容后n行 **B** before 内容前n行 **C** count? 内容前后n行
就像是这样：

```
grep -rn --color Exception -A10 -B2   error.log
```

**diff**

diff命令用来比较两个文件是否的差异。当然，在ide中都提供了这个功能，diff只是命令行下的原始折衷。对了，diff和patch还是一些平台源码的打补丁方式，你要是不用，就pass吧。

#### 解压压缩

```
#创建压缩文件
tar cvfz ar.tar.gz dir/
#解压
tar xvfz ar.tar.gz
```

1.4 日常运维

开机是按一下启动按钮，关机总不至于是长按启动按钮吧。对了，是shutdown命令，不过一般也没权限-.-!。passwd命令可以用来修改密码，这个权限还是可以有的。

![img](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/85095729249a45b4be393b6251238d1f~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

**mount**
mount命令可以挂在一些外接设备，比如u盘，比如iso，比如刚申请的ssd。可以放心的看小电影了。

```
mount /dev/sdb1 /xdy
```

**chown**
`chown` 用来改变文件的所属用户和所属组。
`chmod` 用来改变文件的访问权限。

这两个命令，都和linux的文件权限777有关。

```
#毁灭性的命令
chmod 000 -R /
#修改a目录的用户和组为 xjj
chown -R xjj:xjj a
#给a.sh文件增加执行权限
chmod a+x a.sh
```

包管理工具

```
yum install wget -y
```

后台服务管理

**systemctl**
当然，centos管理后台服务也有一些套路。`service`命令就是。`systemctl`兼容了`service`命令，我们看一下怎么重启mysql服务。 推荐用下面这个。

```
service mysql restart
systemctl restart mysqld
```

进程控制命令

```
kill -9
kill -15
kill -3
```

用户切换 切换用户

su用来切换用户。比如你现在是root，想要用xjj用户做一些勾当，就可以使用su切换。

```
su xjj
su - xjj
```

1.5系统状态概览

![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/3137474a174b482cae0078b94391e2df~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

登陆一台linux机器，有些命令能够帮助你快速找到问题。这些命令涵盖内存、cpu、网络、io、磁盘等。

**uname** uname命令可以输出当前的内核信息，让你了解到用的是什么机器。

**top** 系统状态一览，主要查看。cpu load负载、cpu占用率。使用内存或者cpu最高的一些进程。下面这个命令可以查看某个进程中的线程状态。

**free**
top也能看内存，但不友好，free是专门用来查看内存的。包括物理内存和虚拟内存swap。

**df**
df命令用来查看系统中磁盘的使用量，用来查看磁盘是否已经到达上限。参数`h`可以以友好的方式进行展示。

**ifconfig**
 查看ip地址，不啰嗦，替代品是`ip addr`命令。

**ping**
 至于网络通不通，可以使用ping来探测。（不包括那些禁ping的网站）

**netstat** 虽然ss命令可以替代netstat了，但现实中netstat仍然用的更广泛一些。比如，查看当前的所有tcp连接。





```
#看及其
uname -a
#找到java进程
ps -ef|grep java
#系统一览
top -H -p pid
free
df -h
ipconfig = ip addr
ping
netstat
net stat -ant

```

1.6 日常工作使用

![img](https://p3-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/1434da6946454553bf772976a45e7242~tplv-k3u1fbpfcp-zoom-in-crop-mark:1304:0:0:0.awebp)

**export**
很多安装了jdk的同学找不到java命令，`export`就可以帮你办到它。export用来设定一些环境变量，env命令能看到当前系统中所有的环境变量。比如，下面设置的就是jdk的。

```
export PATH=$PATH:/home/xjj/jdk/bin
whereis

```

**crontab**
这就是linux本地的job工具。不是分布式的，你要不是运维，就不要用了。比如，每10分钟提醒喝茶上厕所。

```
*/10 * * * * /home/xjj/wc10min
```

**date** date命令用来输出当前的系统时间，可以使用-s参数指定输出格式。但设置时间涉及到设置硬件，所以有另外一个命令叫做`hwclock`。

**xargs** xargs读取输入源，然后逐行处理。这个命令非常有用。举个栗子，删除目录中的所有class文件。

```
find . | grep .class$|xargs rm -rvf

ls *.rmvb|xargs -n1 -i cp {} /mount/xdy
```

## 1.7 网络

linux是一个多作业的网络操作系统，所以网络命令有很多很多。工作中，最常和这些打交道。

**ssh**
这个，就不啰嗦了。你一定希望了解`ssh隧道`是什么。你要是想要详细的输出过程，记得加参数`-v`。

**scp**
scp用来进行文件传输。也可以用来传输目录。也有更高级的`sftp`命令。

```
scp a.txt 192.168.0.12:/tmp/a.txt
scp -r a_dir 192.l68.0.12:/tmp/
```

**wget**
你想要在服务器上安装jdk，不会先在本地下载下来，然后使用scp传到服务器上吧（有时候不得不这样）。wget命令可以让你直接使用命令行下载文件，并支持断点续传。

```
wget -c http://oracle.fuck/jdk2019.bin
```

**mysql**
mysql应用广泛，并不是每个人都有条件用上`navicat`的。你需要了解mysql的连接方式和基本的操作，在异常情况下才能游刃有余。

mysql -u root -p -h 192.168.1.2 

## 2.2版本选择

要我个人做个推荐的话：
1、个人用户（技术），桌面版用`ubuntu`=>`archlinux`。
2、企业用户，服务器，使用`centos`。

2.3 发展起源

这么多Linux版本，其实有两条主线。`debian`系列和`redhat`系列。

**bash** 代表的是我们所使用的`shell`，shell可以认为是一个解释器，将我们的输入解释成一系列可执行的指令。

 cat /proc/version



//查看服务器端是否包涵某个类

jar -vtf rbms-business.jar | grep 'com.csci.china.rbms.business.task.WarningInfoChangedRemindTask'





## 快速定位日志

1、定位错误关键字所在行数

cat -n test.log |[grep](https://so.csdn.net/so/search?q=grep&spm=1001.2101.3001.7020) “查找的错误关键字”

2、得到错误关键字所在行号（假设为第500行），查询错误关键字前后100行数据

cat -n test.log |tail -n +400|head -n 200

（表示从第400行开始往后查询200行数据）

3、 用less和grep的组合来找打错误在第几行

```快速定位日志
#参数-n就是就是在输出结果中显示行号。-i是忽略大小写我觉的还是有必要加上这个参数的。
less clickhouse-server.log | grep -in 'Memory limit' 
```



## linux查看系统时间

- [1. date](https://blog.csdn.net/wq_0708/article/details/123383915#1_date_2)
- [2. uptime](https://blog.csdn.net/wq_0708/article/details/123383915#2_uptime_11)
- [3. who](https://blog.csdn.net/wq_0708/article/details/123383915#3_who_20)
- [4. w](https://blog.csdn.net/wq_0708/article/details/123383915#4_w_29)
- [5. top](https://blog.csdn.net/wq_0708/article/details/123383915#5_top_51)
- [6. las](https://blog.csdn.net/wq_0708/article/details/123383915#6_last_71)

