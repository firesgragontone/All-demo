[TOC]

#  分页插件

```
// 分页插件
PaginationInnerInterceptor paginationInterceptor = new PaginationInnerInterceptor();
paginationInterceptor.setOverflow(true);
interceptor.addInnerInterceptor(paginationInterceptor);

interceptor.addInnerInterceptor(new BlockAttackInnerInterceptor());

//interceptor.addInnerInterceptor(new IllegalSQLInnerInterceptor());

return interceptor;


小于号   &lt;
```

#  配置xml文件扫

```xml
配置xml文件扫
mybatis-plus.mapper-locations=classpath*:mybatis/mysql/*PlusMapper.xml


mybaits打印sql,输出日志
mybatis-plus:
  configuration:
    log-impl: org.apache.ibatis.logging.stdout.StdOutImpl
```

# Xml标签

```xml

@NumberFormat("#.####")


//引用内容使用refid
<include refid="Base_Column_List"/>


 //在启动类上加入该参数，进行修改
System.setProperty("fastjson.serializer_buffer_threshold","1024*64");

//mybatis 动态sql ''只能用来判空

乐观锁注解
@version
注册乐观锁拦截器
@Bean
public OptimisticLockerInterceptor optimisticLockerInterceptor(){
return new OptimisticLockerInterceptor();
}

mysql去重功能 group by去重
select city from table group by city order by max(date) desc


<choose>
    <when test="condition.messageType != null and condition.messageType != ''">
        AND a.message_type = #{condition.messageType}
    </when>
    <otherwise>
        AND a.message_type IN
        <foreach collection="condition.messageTypes" item="businessType" open="(" separator="," close=")">
            #{businessType}
        </foreach>
    </otherwise>
</choose>

mysql时间比较
<if test="condition.startDate != null">
    AND date_format(a.create_time, '%Y-%m-%d') &gt;= #{condition.startDate}
</if>


DecimalFormat df = new DecimalFormat("###,##0.00");
df.format(new BigDecimal());

//json转换
<result column="agency_ids" property="agencyIds" typeHandler="com.baomidou.mybatisplus.extension.handlers.JacksonTypeHandler"/>


```

1、遍历 List

```xml
select
<foreach  collection="colnameList" item="colname" separator=",">
          ${colname}
</foreach>
from table1
```



2、遍历 Map

```xml
<foreach collection="map.entrySet()" item="value" index="key">
          ${key} = #{value}
</foreach>
```


3、遍历 List ，把遍历结果放在 sql in 条件中

```xml
select *
from table1
where id in
<foreach collection="idList" item="id" open="(" close=")" separator=",">
		#{id}
</foreach>
```

2、where 标签
可以自动删掉首个 and 或者 or，使用where标签就不用再写 一句 1=1 进行sql 连接了

```xml
select *
from table1
<where>
	and id=1
<where>

```

# mybatis 架构分层

![在这里插入图片描述](https://img-blog.csdnimg.cn/20201216151608310.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80MzkzNTkyNw==,size_16,color_FFFFFF,t_70#pic_center)



# myBatis架构流程图

![img](https://img-blog.csdnimg.cn/2020020518531177.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3FxXzIwMzc2OTgz,size_16,color_FFFFFF,t_70)

# myBatisplus扩展功能

功能扩展：

逻辑删除

枚举转换

字段类型处理器

自动填充功能

SQL注入器

SQL分析打印

数据安全保护（配置安全，字段加密解密，字段脱敏）

多数据源（纯粹多库 读写分离 一主多从）

————————————————
原文链接：https://blog.csdn.net/wwyy2018/article/details/122498276

## 特殊字符需要转义

平时在mybatis的映射文件写sql时，很多时候都需要写一些特殊的字符。例如："<" 字符 “>” 字符 “>=” 字符 “<=” 字符，但是在xml文件中并不能直接写上述列举的字符，否则就会报错。

需要被转义的字符包括如下：

| 需要转移的字符 | 转义后的字符 |
| -------------- | ------------ |
| &              | &amp;amp;    |
| <              |              |
| >              |              |
| ＂             |              |
| ＇             |              |


　　但是严格来说，在XML中只有”<”和”&”是非法的，其它三个都是可以合法存在的，但是，把它们都进行转义是一个好的习惯。

因为在解析xml文件时候，我们如果书写了特殊字符，在没有特殊处理的情况下。这些字符会被转义，但我们并不希望它被转义，所以我们要使用<![CDATA[ ]]>来解决。
那为什么要这样书写呢？<![CDATA[ ]]> ，不言而喻：这是XML语法。在CDATA内部的所有内容都会被解析器忽略。
所以，当我们在xml文本中包含了很多的"<" 字符 “<=” 和 “&” 字符—就像程序代码一样，那么最好把他们都放到CDATA部件中。

```xml
 SELECT * FROM (SELECT t.*, rownum FROM bst_busi_msg t
    <where>
        <if test="targetId != null">
            and (t.busi_sys_order = #{targetId,jdbcType=VARCHAR}
            or t.busi_intf_seq = #{targetId,jdbcType=VARCHAR}
            )
        </if>
        <if test="targetId == null and shardingTotal > 0">
            and (t.task_status = '0'
            OR (t.task_status = '3'
            AND t.task_count <![CDATA[ < ]]> ${@com.asiainfo.bst.common.Constant@max_handle_count()}
            )
            )
            and MOD(t.msg_id,#{shardingTotal,jdbcType=NUMERIC}) = #{shardingIndex,jdbcType=NUMERIC}
        </if>
    </where>
	ORDER BY t.msg_id ASC
) WHERE rownum <![CDATA[ <= ]]> #{rownum,jdbcType=NUMERIC}

```

————————————————
原文链接：https://blog.csdn.net/xiaoleilei666/article/details/109695510

# 百万数据处理

[查询百万级的数据的时候，还可以使用游标方式进行数据查询处理，不仅可以节省内存的消耗，而且还不需要一次性取出所有数据，可以进行逐条处理或逐条取出部分批量处理。一次查询指定 `fetchSize` 的数据，直到把数据全部处理完。](http://mp.weixin.qq.com/s?__biz=MzI3ODcxMzQzMw==&mid=2247565405&idx=2&sn=5a410918a4bbf827cd309071ef7d3272&chksm=eb51456bdc26cc7d1684d22b9cad96098e8229681505e4dd7eec807616562b0d53a5e9fbca05&scene=21#wechat_redirect)

Mybatis 的处理加了两个注解：`@Options` 和 `@ResultType`

```
@Mapper
public interface BigDataSearchMapper extends BaseMapper<BigDataSearchEntity> {
 
    // 方式一 多次获取，一次多行
    @Select("SELECT bds.* FROM big_data_search bds ${ew.customSqlSegment} ")
    @Options(resultSetType = ResultSetType.FORWARD_ONLY, fetchSize = 1000000)
    Page<BigDataSearchEntity> pageList(@Param("page") Page<BigDataSearchEntity> page, @Param(Constants.WRAPPER) QueryWrapper<BigDataSearchEntity> queryWrapper);
 
    // 方式二 一次获取，一次一行
    @Select("SELECT bds.* FROM big_data_search bds ${ew.customSqlSegment} ")
    @Options(resultSetType = ResultSetType.FORWARD_ONLY, fetchSize = 100000)
    @ResultType(BigDataSearchEntity.class)
    void listData(@Param(Constants.WRAPPER) QueryWrapper<BigDataSearchEntity> queryWrapper, ResultHandler<BigDataSearchEntity> handler);
 
}
```

