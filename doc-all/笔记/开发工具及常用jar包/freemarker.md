## **命名不规范导致错误**

注意：其实错误原因就是实体类的属性命名不规范
private String M_Name; //歌名
private String M_Singer; //歌手
private String M_Time; //时长
private String M_Publish_Time; //发布时间
private String M_Album; //专辑
属性名字不符合javabean的规范！也就改 实体类 和 flt模板 ，把首字母改为小写！M–>m
————————————————
版权声明：本文为CSDN博主「诺言2018」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/nuoyan2018/article/details/85274873



**字符默认值设置**

1、${(age)?c}  将千分位转换成正常格式，只针对数字类型处理，字符串处理会报错

2、${(age)!    后台返回null，页面展示空白

3、${(createDate?number_to_date)!  [时间戳](https://so.csdn.net/so/search?q=时间戳&spm=1001.2101.3001.7020)转成yyyy-mm-dd格式

<td>${(item.fb_rev_transferincom_x?string("#,###.##"))!'-'}</td>

${(item.year?c)!'-'}

​                     <td>${(i.inventory?string(",##0.00"))!'-'}</td>

i.inventory