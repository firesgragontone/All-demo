[TOC]

**1.mysql不支持full join**

Oracle 支持full join
mysql不支持full join,但可通过左外连接(left join)+union+右外连接(right join)来实现。

ROW_FORMAT = DYNAMIC

```bash
mkdir -p /root/mysql/data /root/mysql/logs /root/mysql/conf
```

```xml
加排他锁
for update;


xml转义
  <![CDATA[
                AND DATE (t2.trade_dt) >= #{condition.startDate}
                ]]>
```



# 数据库优化

1.explian查看优化器执行计划，走不走索引

2.开启优化器跟踪功能


MySql从5.7版本开始默认开启only_full_group_by规则，规则核心原则如下，没有遵循原则的sql会被认为是不合法的sql

\1. order by后面的列必须是在select后面存在的

\2. select、having或order by后面存在的非聚合列必须全部在group by中存在



**一、创建用户和授权**

   在mysql8.0创建用户和授权和之前不太一样了，其实严格上来讲，也不能说是不一样,只能说是更严格,mysql8.0需要先创建用户和设置密码,然后才能授权。

 

```
#先创建一个用户
create user 'test'@'%' identified by '123123';
```

 

```
#再进行授权
grant all privileges on *.* to 'test'@'%' with grant option;
```

3.在 mysql 数据库的 user 表中查看当前 root 用户的相关信息

```sql
select host, user, authentication_string, plugin from user; 
```

4.授权 root 用户的所有权限并设置远程访问

```sql
GRANT ALL ON *.* TO 'root'@'%';
```

- 1

GRANT ALL ON 表示所有权限，% 表示通配所有 host，可以访问远程。

5.刷新权限

所有操作后，应执行

```lua
flush privileges;
```



6.登录mysql

```mysql
mysql -uroot -p123456
```



```bash
mkdir -p F:\gitcode\config//mysql//data F:\gitcode\config//mysql//logs F:\gitcode\config//root//mysql//conf
```

docker run -p 3306:3306 --name mysql5.7 -v F:\gitcode\config\mysql\conf:/etc/mysql/conf.d -v F:\gitcode\config\mysql\logs:/logs -v F:\gitcode\config\mysql\conf/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7



docker run -p 3306:3306 --name mysql5.7  -e MYSQL_ROOT_PASSWORD=root -d mysql:5.7



## 如何将现有的 MyISAM 数据库转换为 InnoDB:


 mysql -u [USER_NAME] -p -e "SHOW TABLES IN [DATABASE_NAME];" | tail -n +2 | xargs -I '{}' echo "ALTER TABLE {} ENGINE=InnoDB;" > alter_table.sql
 perl -p -i -e 's/(search_[a-z_]+ ENGINE=)InnoDB//1MyISAM/g' alter_table.sql
 mysql -u [USER_NAME]    -p [DATABASE_NAME] < alter_table.sql

作者：LQS19815
链接：https://juejin.cn/post/6844903478167339015
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。



## 2.2 数据预热

  默认情况，只有某条数据被读取一次，才会缓存在 innodb_buffer_pool。所以，数据库刚刚启动，需要进行数据预热，将磁盘上的所有数据缓存到内存中。数据预热可以提高读取速度。

\1. 将以下脚本保存为 MakeSelectQueriesToLoad.sql

```mysql
SELECT DISTINCT
 CONCAT('SELECT ',ndxcollist,'    FROM ',db,'.',tb,
 ' ORDER BY ',ndxcollist,';') SelectQueryToLoadCache
 FROM
 (
 SELECT
 engine,table_schema db,table_name tb,
 index_name,GROUP_CONCAT(column_name ORDER BY seq_in_index) ndxcollist
 FROM
 (
 SELECT
 B.engine,A.table_schema,A.table_name,
    A.index_name,A.column_name,A.seq_in_index
 FROM
 information_schema.statistics A INNER JOIN
 (
 SELECT engine,table_schema,table_name
 FROM information_schema.tables WHERE
 engine='InnoDB'
 ) B USING (table_schema,table_name)
    WHERE B.table_schema NOT IN ('information_schema','mysql')
 ORDER BY table_schema,table_name,index_name,seq_in_index
 ) A
 GROUP BY table_schema,table_name,index_name
 ) AA
 ORDER BY db,tb
 ;
```

作者：LQS19815
链接：https://juejin.cn/post/6844903478167339015
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。



\2. 执行

 mysql -uroot    -AN < /root/MakeSelectQueriesToLoad.sql > /root/SelectQueriesToLoad.sql

 \3. 每次重启数据库，或者整库备份前需要预热的时候执行：

 mysql -uroot < /root/SelectQueriesToLoad.sql > /dev/null 2>&1

作者：LQS19815
链接：https://juejin.cn/post/6844903478167339015
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。



1.sql规范检查

2.表结构检查

3.索引检查

4.改写sql

规范性检查->评估执行计划->explain解析执行计划

## 12、新生代垃圾回收器和老年代垃圾回收器都有哪些？有什么区别？

- 新生代回收器：Serial、ParNew、Parallel Scavenge
- 老年代回收器：Serial Old、Parallel Old、CMS
- 整堆回收器：G1

新生代垃圾回收器一般采用的是复制算法，复制算法的优点是效率高，缺点是内存利用率低；老年代回收器一般采用的是标记-整理的算法进行垃圾回收。



### 案例1、最左匹配

### 案例2、隐式转换

### 案例3、大分页

### 案例4、in + order by

### 案例5、范围查询阻断，后续字段不能走索引

### 案例6、不等于、不包含不能用到索引的快速搜索。（可以用到ICP）案例7、优化器选择不使用索引的情况

### 案例7、优化器选择不使用索引的情况

### 案例8、复杂查询

### 案例9、asc和desc混用

### 案例10、大数据



批量插入

```
-- 插入存储过程
delimiter ;;
create procedure idata()
begin
  declare i int;
  set i=1;
  while(i<=100000)do
    insert into t values(i, i, i);
    set i=i+1;
  end while;
end;;
delimiter ;
call idata();

```

```

```

```

```

# （mysql 5.7）Host is not allowed to connect to this MySQL server解决方法

先说说这个错误，其实就是我们的MySQL不允许[远程登录](https://so.csdn.net/so/search?q=远程登录&spm=1001.2101.3001.7020)，所以远程登录失败了，解决方法如下：

1. 在装有MySQL的机器上登录MySQL mysql -u root -p123456

2. 执行`use mysql;`

3. 执行`update user set host = '%' where user = 'root';`这一句执行完可能会报错，不用管它。

4. 执行`FLUSH PRIVILEGES;`

   经过上面4步，就可以解决这个问题了。 
   **注: 第四步是刷新MySQL的权限相关表，一定不要忘了，我第一次的时候没有执行第四步，结果一直不成功，最后才找到这个原因。**、
   
   5. 保存容器
   6. **docker ps**
   7. **docker commit 3bd0eef03413 mysql:v1.0

## 排序(order by)

MySQL支持两种方式的排序filesort和index，

**Using index**是指MySQL扫描索引本身完成排序。index效率高，filesort效率低,我们这个排序针对于filesort

**filesort**:不会按照索引来排序，他会根据条件去扫描整个表,然后加载到内存进行排序

**单路排序：**将查询到的满足条件的整个表数据加载到内存中统一去排序,排完序之后就可以返回结果集了

**双路排序:**将查询到的满足条件的整个表数据的主键和要排序的字段加载到内存中,然后在内存中只针对这几个字段排序好,再根据排好序的主   键去聚集索引页执行回表操作,然后在返回结果集

#### 优缺点

**单路排序**:单路排序占用的内存大,但是排完序之后结果集就可以直接返回了

**双路排序**:双路排序占用的内存小,但是排完序之后还要进行一次回表的操作

### 怎么设置排序规则?

**MySQL 通过比较系统变量 max_length_for_sort_data(默认1024字节) 的大小和需要查询的字段总大小来判断使用哪种排序模式。**

```
如果 表字段的总长度小于max_length_for_sort_data ，那么使用 单路排序模式；
如果 表字段的总长度大于max_length_for_sort_data ，那么使用 双路排序模∙式。
```

作者：Z在掘金100508
链接：https://juejin.cn/post/6879976976916938760
来源：稀土掘金
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

mysql设置默认值

SELECT IFNULL(max(id), 0) from area_config



```mysql
复杂查询
select DAYOFWEEK('1998-02-03'); 
select (case DAYOFWEEK(now())-1 when 6 then "星期六" when 5 then "周中" ELSE "qq" END); 


总增信责任余额
SELECT (select SUM(IFNULL(issue_amount,0)) issue_amount  from pms_issue_info where issue_status = 1 and project_id = 8712) - (SELECT IFNULL(sum(IFNULL(final_repayment_amount,0)),0) invest_repayment_amount  from pms_issue_invest_charge_plan WHERE project_id = 8712 and `charge_plan_status` = 3 and end_date <= now()) - (SELECT IFNULL(sum(IFNULL(final_repayment_amount,0)),0) pms_issue_credit_charge_plan  from pms_issue_invest_charge_plan WHERE project_id = 8712 and `charge_plan_status` = 3 and end_date <= now()) as price


SELECT (select SUM(IFNULL(issue_amount,0)) issue_amount  from pms_issue_info where issue_status = 1 and project_id in (SELECT id from pms_project_info  WHERE project_code = "062113")) - (SELECT IFNULL(sum(IFNULL(final_repayment_amount,0)),0) invest_repayment_amount  from pms_issue_invest_charge_plan WHERE project_id in (SELECT id from pms_project_info  WHERE project_code = "062113") and `charge_plan_status` = 3 and end_date <= now()) - (SELECT IFNULL(sum(IFNULL(final_repayment_amount,0)),0) credit_repayment_amount  from pms_issue_credit_charge_plan WHERE project_id in (SELECT id from pms_project_info  WHERE project_code = "062113") and `charge_plan_status` = 3 and end_date <= now()) as price

SELECT (select SUM(IFNULL(issue_amount,0)) issue_amount  from pms_issue_info where issue_status = 1 and project_id in 
        (select
        a.id as id
        from pms_project_org p INNER JOIN pms_project_org b on p.company_id = b.company_id
        INNER JOIN pms_project_info a on p.project_id = a.id
        WHERE
        b.risk_role_type = 11
				and a.status in (1,4)
				and b.project_id = 10056
				and p.risk_role_type = 11)
) - (SELECT IFNULL(sum(IFNULL(final_repayment_amount,0)),0) invest_repayment_amount  from pms_issue_invest_charge_plan WHERE project_id in 
        (select
        a.id as id
        from pms_project_org p INNER JOIN pms_project_org b on p.company_id = b.company_id
        INNER JOIN pms_project_info a on p.project_id = a.id
        WHERE
        b.risk_role_type = 11
				and a.status in (1,4)
				and b.project_id = 10056
				and p.risk_role_type = 11)
 and `charge_plan_status` = 3 and end_date <= now()) - (SELECT IFNULL(sum(IFNULL(final_repayment_amount,0)),0) credit_repayment_amount  from pms_issue_credit_charge_plan WHERE project_id in 
        (select
        a.id as id
        from pms_project_org p INNER JOIN pms_project_org b on p.company_id = b.company_id
        INNER JOIN pms_project_info a on p.project_id = a.id
        WHERE
        b.risk_role_type = 11
				and a.status in (1,4)
				and b.project_id = 10056
				and p.risk_role_type = 11)
 and `charge_plan_status` = 3 and end_date <= now()) as price


```

```css
docker run -p 3308:3306 --name mysql1 -e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.7
```

```mysql
INSERT INTO `tf_test`.`pms_project_org` (`id`, `project_id`, `project_code`, `company_id`, `company_name`, `credit_code`, `org_type`, `risk_role_type`, `risk_role_type_desc`, `counter_guarantee_type`, `cooperative_org_type`, `bid_date_flag`, `tenant_code`, `update_time`, `create_time`) VALUES (1475, 10091, 'ZX2022088', 10852396, '自贡市城市建设投资开发集团有限公司', '915103005927596186', '1', '11', '核心交易对手，统计报表纳入统计', NULL, NULL, '0', NULL, '2022-06-17 10:06:06', '2022-06-17 10:06:06');


select distinct project_id, id, project_code, affiliation, risk_type, supervise_type, industry_type, conference_batch, conference_time, conference_money,conference_result,conference_condition, conference_confirm, ins_id, tenant_code, create_time, update_time, conference_type
            from pms_conference_info order by create_time DESC;
						
SELECT *
FROM pms_conference_info a
WHERE a.create_time IN (
  SELECT m.createTime
  FROM (
         SELECT DISTINCT (q.project_id),
                         max(q.create_time) createTime
         FROM (
                SELECT *
								
                FROM pms_conference_info
              ) q
         GROUP BY q.project_id
       ) m

	
);					


(select * from pms_conference_info a right join 
(SELECT DISTINCT (b.project_id),max(b.create_time) createTime,id
FROM pms_conference_info b
GROUP BY b.project_id) m on m.id = a.id) ORDER BY create_time desc


select distinct project_id, id, project_code, affiliation, risk_type, supervise_type, industry_type, conference_batch, conference_time, conference_money,conference_result,conference_condition, conference_confirm, ins_id, tenant_code, create_time, update_time, conference_type
            from pms_conference_info order by create_time DESC;					

过会信息列表-自连接
SELECT *
FROM pms_conference_info a
WHERE a.create_time IN (
  SELECT m.createTime
  FROM (
         SELECT DISTINCT (q.project_id),
                         max(q.create_time) createTime
         FROM (
                SELECT *
								
                FROM pms_conference_info
              ) q
         GROUP BY q.project_id
       ) m
);					


(select * from pms_conference_info a right join 
(SELECT DISTINCT (b.project_id),max(b.create_time) createTime,id
FROM pms_conference_info b
GROUP BY b.project_id) m on m.id = a.id) ORDER BY create_time desc

WHERE a.create_time IN (
  SELECT m.createTime
  FROM (
         SELECT DISTINCT (q.project_id),
                         max(q.create_time) createTime
         FROM (
                SELECT *
                FROM pms_conference_info
              ) q
         GROUP BY q.project_id
       ) m

	
);	

```

```mysql

动态更新流程版本
update act_ru_task set proc_def_id_ = 'key_hftb:6:1025015' where proc_def_id_ = 'key_hftb:5:905020';
update act_hi_taskinst set proc_def_id_ = 'key_hftb:6:1025015' where proc_def_id_ = 'key_hftb:5:905020';
update act_hi_procinst set proc_def_id_ = 'key_hftb:6:1025015' where proc_def_id_ = 'key_hftb:5:905020';
update act_hi_actinst set proc_def_id_ = 'key_hftb:6:1025015' where proc_def_id_ = 'key_hftb:5:905020';
update act_ru_execution set proc_def_id_ = 'key_hftb:6:1025015' where proc_def_id_ = 'key_hftb:5:905020';

update act_ru_task set proc_def_id_ = 'warning_info_handle:4:08d061ee-277e-11ed-9675-0050568c1d2d' where proc_def_id_ = 'warning_info_handle:3:08d061ee-277e-11ed-9675-0050568c1d2d';
update act_hi_taskinst  set proc_def_id_ = 'warning_info_handle:4:08d061ee-277e-11ed-9675-0050568c1d2d' where proc_def_id_ = 'warning_info_handle:3:08d061ee-277e-11ed-9675-0050568c1d2d';
update act_hi_procinst set proc_def_id_ = 'warning_info_handle:4:08d061ee-277e-11ed-9675-0050568c1d2d' where proc_def_id_ = 'warning_info_handle:3:08d061ee-277e-11ed-9675-0050568c1d2d';
update act_hi_actinst set proc_def_id_ = 'warning_info_handle:4:08d061ee-277e-11ed-9675-0050568c1d2d' where proc_def_id_ = 'warning_info_handle:3:08d061ee-277e-11ed-9675-0050568c1d2d';
update act_ru_execution set proc_def_id_ = 'warning_info_handle:4:08d061ee-277e-11ed-9675-0050568c1d2d' where proc_def_id_ = 'warning_info_handle:3:08d061ee-277e-11ed-9675-0050568c1d2d';


explain update act_ru_task force INDEX(ACT_FK_TASK_PROCDEF) set proc_def_id_ = 'warning_info_handle:2:0c9d340b-fe8f-11ec-b564-0050568c1f3d' where proc_def_id_ = 'warning_info_handle:1:758fffd0-e25d-11ec-9aee-00163e016231';
-- AND CREATE_TIME_ > DATE_SUB(now(), INTERVAL 2 DAY)  LIMIT 1
update act_hi_taskinst  set proc_def_id_ = 'warning_info_handle:2:0c9d340b-fe8f-11ec-b564-0050568c1f3d' where proc_def_id_ = 'warning_info_handle:1:758fffd0-e25d-11ec-9aee-00163e016231' AND START_TIME_ > DATE_SUB(now(), INTERVAL 5 DAY)  ORDER BY ID_ desc limit 10;

update act_hi_procinst set proc_def_id_ = 'warning_info_handle:2:0c9d340b-fe8f-11ec-b564-0050568c1f3d' where proc_def_id_ = 'warning_info_handle:1:758fffd0-e25d-11ec-9aee-00163e016231' AND START_TIME_ > DATE_SUB(now(), INTERVAL 5 DAY) LIMIT 10;

update act_hi_actinst set proc_def_id_ = 'warning_info_handle:2:0c9d340b-fe8f-11ec-b564-0050568c1f3d' where proc_def_id_ = 'warning_info_handle:1:758fffd0-e25d-11ec-9aee-00163e016231' AND START_TIME_ > DATE_SUB(now(), INTERVAL 2 DAY) LIMIT 10;

update act_ru_execution set proc_def_id_ = 'warning_info_handle:2:0c9d340b-fe8f-11ec-b564-0050568c1f3d' where proc_def_id_ = 'warning_info_handle:1:758fffd0-e25d-11ec-9aee-00163e016231' AND START_TIME_ > DATE_SUB(now(), INTERVAL 5 DAY);


warning_info_handle:1:758fffd0-e25d-11ec-9aee-00163e016231
warning_info_handle:2:0c9d340b-fe8f-11ec-b564-0050568c1f3d


SELECT * from act_ru_task  where proc_def_id_ = 'warning_info_handle:1:758fffd0-e25d-11ec-9aee-00163e016231' AND CREATE_TIME_ > DATE_SUB(now(), INTERVAL 2 DAY) ORDER BY ID_ desc;
act_ru_task
————————————————
版权声明：本文为CSDN博主「csdnGarbage1」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/csdnGarbage1/article/details/114583544

SELECT id,name
 from sys_user WHERE id in (SELECT user_id FROM `pms_project_warning_act_check`);

```

```mysql

insert into sys_client_interface(client_id, interface_uri, interface_name) values('csci_admin', '/chinacsci/api/track-report/query-company-change-record','工商变更');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('ctbl_admin', '/chinacsci/api/track-report/query-company-change-record','工商变更');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('hbrd_admin', '/chinacsci/api/track-report/query-company-change-record','工商变更');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('jxxd_admin', '/chinacsci/api/track-report/query-company-change-record','工商变更');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('tf_admin',   '/chinacsci/api/track-report/query-company-change-record','工商变更');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('zhdb_admin', '/chinacsci/api/track-report/query-company-change-record','工商变更');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('cxdb_admin', '/chinacsci/api/track-report/query-company-change-record','工商变更');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('hzhc_admin', '/chinacsci/api/track-report/query-company-change-record','工商变更');

insert into sys_client_interface(client_id, interface_uri, interface_name) values('csci_admin', '/chinacsci/api/track-report/query-company-executives-change-record','董监高变更');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('ctbl_admin', '/chinacsci/api/track-report/query-company-executives-change-record','董监高变更');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('hbrd_admin', '/chinacsci/api/track-report/query-company-executives-change-record','董监高变更');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('jxxd_admin', '/chinacsci/api/track-report/query-company-executives-change-record','董监高变更');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('tf_admin',   '/chinacsci/api/track-report/query-company-executives-change-record','董监高变更');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('zhdb_admin', '/chinacsci/api/track-report/query-company-executives-change-record','董监高变更');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('cxdb_admin', '/chinacsci/api/track-report/query-company-executives-change-record','董监高变更');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('hzhc_admin', '/chinacsci/api/track-report/query-company-executives-change-record','董监高变更');

insert into sys_client_interface(client_id, interface_uri, interface_name) values('csci_admin', '/chinacsci/api/track-report/get-subsist-bond','获取债券信息');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('ctbl_admin', '/chinacsci/api/track-report/get-subsist-bond','获取债券信息');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('hbrd_admin', '/chinacsci/api/track-report/get-subsist-bond','获取债券信息');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('jxxd_admin', '/chinacsci/api/track-report/get-subsist-bond','获取债券信息');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('tf_admin',   '/chinacsci/api/track-report/get-subsist-bond','获取债券信息');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('zhdb_admin', '/chinacsci/api/track-report/get-subsist-bond','获取债券信息');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('cxdb_admin', '/chinacsci/api/track-report/get-subsist-bond','获取债券信息');
insert into sys_client_interface(client_id, interface_uri, interface_name) values('hzhc_admin', '/chinacsci/api/track-report/get-subsist-bond','获取债券信息');

查看建表语句
show create table tf_test.pms_project_warning_act_check;


PK：primary key 主键

NN：not null 非空

UQ：unique 唯一索引

BIN：binary 二进制数据(比text更大)

UN：unsigned 无符号（非负数）

ZF：zero fill 填充0 例如字段内容是1 int(4), 则内容显示为0001

AI：auto increment 自增长
ALTER TABLE `rbms_test`.`pms_project_warning_act_check` 
CHANGE COLUMN `id` `id` BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键' ;


14:47:39	update rbms_test.act_csci_message_task set user_id = 16034,send_user = 15801 where user_id not in (select id from rbms_test.sys_user)	Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.	0.000 sec


DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4401';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4402';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4403';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4404';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4405';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4406';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4407';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4408';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4409';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4410';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4411';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4412';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4413';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4414';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4415';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4416';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4417';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4418';
DELETE FROM `rbms_test`.`pms_project_warning_act_check` WHERE `id`='4419';


INSERT INTO `rbms_test`.`sys_dict` (`id`, `num`, `pid`, `dict_name`, `dict_key`, `dict_value`) VALUES ('1045', '005', '1040', '资产管理事业部', 'dept_zg', '15');

#分组查询只取一条数据
SELECT company_id, final_rating, MAX(factor_dt) AS factor_dt
FROM data_rating_record
WHERE company_id = 8349
GROUP BY company_id


权限数据实现：
结合 mybatis 拦截器和正则表达式进行替换 根据用户的进行个性化查询

SELECT
	 * 
FROM
	pms_project_contribution t 
WHERE
	t.dept_id IN (SELECT t1.dept_id FROM sys_user_dept t1 WHERE t1.user_id = 303) 


```

```sql
使用mysql workbench建表时，字段中有PK,NN,UQ,BIN,UN,ZF,AI几个基本字段类型标识。

PK：primary key 主键

NN：not null 非空

UQ：unique 唯一索引

BIN：binary 二进制数据(比text更大的二进制数据)

UN：unsigned 无符号     整数（非负数）

ZF：zero fill 填充0 例如字段内容是1 int(4), 则内容显示为0001 

AI：auto increment 自增

G：generated column 生成列

在mysql查询语句中加\g、\G的意思：

\g  的作用是分号和在sql语句中写“；”是等效的
\G  的作用是将查到的结构旋转90度变成纵向（换行打印）
————————————————
版权声明：本文为CSDN博主「鸿*雁」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/heyw886/article/details/105098193/


ALTER TABLE `rbms_test`.`pms_project_org_score`
ADD COLUMN `org_score_no_complete` TINYINT(1) NOT NULL DEFAULT 0 AFTER `org_score`,
ADD COLUMN `org_score_no_complete_desc` VARCHAR(400) NULL AFTER `org_score_no_complete`;



drop table IF EXISTS rbms_test.pms_company_news_state; 
CREATE TABLE `pms_company_news_state` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT COMMENT '主键',
  `news_id` varchar(64) DEFAULT NULL COMMENT '新闻记录ID',
  `viewer_id` bigint NOT NULL COMMENT '查看人ID',
  `tenant_code` varchar(12) DEFAULT NULL COMMENT '租户编码',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_news_id` (`news_id`) USING BTREE,pms_assets_distributepms_assets_distribute
  KEY `idx_tenant_code` (`tenant_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC COMMENT='企业新闻状态表';


//修改项目阶段
update pms_project_info set project_phase = 80 where project_phase= 70 and  id in (
51006,50708,50704,50603,50432,50426,50418,50416,50409,50404,50333,50332,50331,50318,50249,50242,50201,50018,50017,50013,50009,50006,50005,50003,49905,49816,49814,49420,49412,49410,49401,49301,49106,48829,48823,48817,48814,48805)


```

![image-20221121102855293](C:\Users\Administrator.DESKTOP-80KRDB4\AppData\Roaming\Typora\typora-user-images\image-20221121102855293.png)

Invalid bound statement (not found)



```mysql
MySQL中的安全更新模式
查询
show variables like '%sql_safe%';
关闭safe mode 
set sql_safe_updates=0;
然后再启用safe mode 
set sql_safe_updates=1;
```

```mysql
ALTER TABLE `rbms_test`.`pms_contract_file` 
CHANGE COLUMN `file_code` `file_code` VARCHAR(128) NULL DEFAULT NULL COMMENT '文件编号' ;
```

```
pms_issue_credit_charge_plan id = 4

备份
# id, project_id, issue_id, contract_id, issue_credit_id, start_date, end_date, initial_duty_amount, final_repayment_amount, interest, compensation_amount, receive_credit_amount, receive_date, receipts_date, receipts_credit_amount, is_settle, receipts_remark, charge_plan_status, charge_plan_type, send_remind, remind_state, pins_id, tenant_code, create_user_id, create_time, update_time, receive_reinsurance_amount, receipts_reinsurance_amount, issue_rate, credit_rate
'4', '53809', '816', '34807', '105', '2022-09-21', '2022-09-30', '10000000.0000', '2000000.0000', '1000.0000', '222.0000', '333.0000', '2022-09-30', '2022-09-21', '333.0000', '1', '测试2', '2', '1', '1', '1', '24d52ff2-38c4-11ed-8bc3-0050568c5acc', NULL, '12101', '2022-09-20 17:10:22', '2022-09-21 10:27:43', NULL, NULL, NULL, NULL

```

## *mysql支持每秒并发16384。*

受服务器配置,及网络环境等制约,实际服务器支持的并发连接数会小一些。



# MySQL并发连接和并发查询

并发连接和并发查询，并不是同一个概念。你在 show processlist 的结果里，看到的几千个连接，指的就是并发连接。而“当前正在执行”的语句，才是我们所说的并发查询。
并发连接数达到几千个影响并不大，就是多占一些内存而已。我们应该关注的是并发查询，因为并发查询太高才是 CPU 杀手。这也是为什么我们需要设置 innodb_thread_concurrency 参数的原因。
————————————————
版权声明：本文为CSDN博主「雪落南城」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/lbh199466/article/details/107807767



# [mysql 之 group by 性能优化 查询与统计分离 ]

**背景介绍**

记录共128W条！

```sql
SELECT cpe_id, COUNT(*) restarts
FROM business_log
WHERE operate_time>='2012-12-05 00:00:00' AND operate_time<'2018-01-05 00:00:00' AND operate_type=3 AND result=0
GROUP BY cpe_id
```

尝试对原SQL语句进行优化后发现，统计速度依旧没有获得满意的提升。单独运行条件查询语句（不包含GROUP BY和COUNT函数）后发现，查询的结果数据量只有6655条，耗时0.825s；加上统计语句后，时间飙升至3s。

 **原理**

mysql 解释：

MySQL说明文档中关于优化GROUP BY的部分指出：The most general way to satisfy a GROUP BY clause is to scan the whole table and create a new temporary table where all rows from each group are consecutive, and then use this temporary table to discover groups and apply aggregate functions (if any)。即，GROUP BY语句会扫描全表并新建一个临时表用来分组存放数据，然后根据临时表中的分组对数据执行聚合函数。现在的问题聚焦在：如果GROUP BY和WHERE在同一个语句中，这个“全表”指的是物理表还是WHERE过滤后的数据集合？

```sql
SELECT cpe_id, COUNT(*) restarts
FROM (
SELECT cpe_id
FROM business_log
WHERE operate_time>='2012-12-05 00:00:00' AND operate_time<'2018-01-05 00:00:00' AND operate_type=3 AND result=0
) t
GROUP BY cpe_id
```

\---------------------

如上述语句所示，在查询语句外包了一个统计语句。执行结果：0.851s。时间消耗大幅减少！

**结论**

利用GROUP BY统计大数据时，应当将查询与统计分离，优化查询语句。

**引用资料**

https://www.cnblogs.com/zhaokunbokeyuan256/p/10721667.html

## 实际业务中

```sql

SELECT SUM(a.reportcount)reportcount,a.OrganizationId,a.organizationcode,a.organizationname,org.UpperComCode,org.organizationlevel FROM (SELECT COUNT(1) ReportCount, o.OrganizationCode ,o.organizationname, o.id OrganizationId,o.organizationlevel FROM report r JOIN organization o ON r.OrganizationCode = o.OrganizationCode WHERE o.OrganizationCode in ('44010000','44040000','44006600','44008800','44020000','44050000','44060000','44070000','44080000','44090000','44120000','44150000','44160000','44170000','44180000','44190000','44510000','44520000','44530000','44710000','44940000','44950000') and r.ReportTime>'2019/4/25 0:00:00' and r.ReportReasonSubmitCode in ('A10006','A10007') and r.ReportTime<'2019/5/20 0:00:00' and r.LossTime>'2019/4/11 0:00:00' and r.LossTime<'2019/5/6 0:00:00' and r.InsuranceType in (5,6,7,8) AND r.CatasCollectionId=361 GROUP BY o.OrganizationCode,o.organizationname, o.id,o.organizationlevel union all SELECT COUNT(1) ReportCount, o.OrganizationCode,o.organizationname, o.id OrganizationId,o.organizationlevel FROM report r JOIN organization o ON r.OrganizationCode = o.OrganizationCode WHERE o.UpperComCode IN('44010000','44040000','44006600','44008800','44020000','44050000','44060000','44070000','44080000','44090000','44120000','44150000','44160000','44170000','44180000','44190000','44510000','44520000','44530000','44710000','44940000','44950000')and r.ReportTime>'2019/4/25 0:00:00' and r.ReportReasonSubmitCode in ('A10006','A10007') and r.ReportTime<'2019/5/20 0:00:00' and r.LossTime>'2019/4/11 0:00:00' and r.LossTime<'2019/5/6 0:00:00' and r.InsuranceType in (5,6,7,8) AND r.CatasCollectionId=361 GROUP BY o.OrganizationCode,o.organizationname, o.id ,o.organizationlevel union all SELECT COUNT(1) ReportCount , o.UpperComCode OrganizationCode,o.ParentOrgName OrganizationName, o.ParentOrgId OrganizationId,o.organizationlevel FROM report r JOIN organization o ON r.OrganizationCode = o.OrganizationCode WHERE o.UpperComCode IN(SELECT OrganizationCode FROM organization WHERE UpperComCode IN ('44010000','44040000','44006600','44008800','44020000','44050000','44060000','44070000','44080000','44090000','44120000','44150000','44160000','44170000','44180000','44190000','44510000','44520000','44530000','44710000','44940000','44950000' )and r.ReportTime>'2019/4/25 0:00:00' and r.ReportReasonSubmitCode in ('A10006','A10007') and r.ReportTime<'2019/5/20 0:00:00' and r.LossTime>'2019/4/11 0:00:00' and r.LossTime<'2019/5/6 0:00:00' and r.InsuranceType in (5,6,7,8) AND r.CatasCollectionId=361) GROUP BY o.UpperComCode ,o.ParentOrgName, o.ParentOrgId,o.organizationlevel union all SELECT SUM(reportcount) reportcount , organization.UpperComCode OrganizationCode, organization.ParentOrgName OrganizationName,organization.ParentOrgId OrganizationId,organization.OrganizationLevel FROM ( SELECT COUNT(1) reportcount , o.UpperComCode newcode, o.organizationlevel FROM report r JOIN organization o ON r.OrganizationCode = o.OrganizationCode WHERE o.UpperComCode IN( SELECT OrganizationCode FROM organization WHERE UpperComCode IN(SELECT OrganizationCode FROM organization WHERE UpperComCode IN ('44010000','44040000','44006600','44008800','44020000','44050000','44060000','44070000','44080000','44090000','44120000','44150000','44160000','44170000','44180000','44190000','44510000','44520000','44530000','44710000','44940000','44950000' )and r.ReportTime>'2019/4/25 0:00:00' and r.ReportReasonSubmitCode in ('A10006','A10007') and r.ReportTime<'2019/5/20 0:00:00' and r.LossTime>'2019/4/11 0:00:00' and r.LossTime<'2019/5/6 0:00:00' and r.InsuranceType in (5,6,7,8) AND r.CatasCollectionId=361 ) ) GROUP BY o.UpperComCode, o.organizationlevel ) a JOIN organization ON a.newcode = organization.OrganizationCode GROUP BY organization.UpperComCode , organization.ParentOrgName ,organization.ParentOrgId ,organization.OrganizationLevel ) a JOIN organization org ON a.organizationcode=org.organizationcode GROUP BY a.organizationcode,a.organizationname,org.UpperComCode,org.organizationlevel,a.OrganizationId ORDER BY OrganizationLevel
```

上面为原查询语句

下面为优化后的查询语句

```sql
SELECT COUNT(1) AS reportcount,a.OrganizationId,a.organizationcode,a.organizationname,a.UpperComCode,a.organizationlevel FROM (
 
 
SELECT r.*,r.id AS reportid, o.OrganizationCode ,o.organizationname, o.id OrganizationId,o.organizationlevel ,o.UpperComCode
FROM report r JOIN organization o ON r.OrganizationCode = o.OrganizationCode
WHERE o.OrganizationCode IN ('44010000','44040000','44006600','44008800','44020000','44050000','44060000','44070000','44080000','44090000','44120000','44150000','44160000','44170000','44180000','44190000','44510000','44520000','44530000','44710000','44940000','44950000') AND r.ReportTime>'2010/4/25 0:00:00' AND r.ReportReasonSubmitCode IN ('A10006','A10007') AND r.ReportTime<'2019/5/20 0:00:00' AND r.LossTime>'2010/4/11 0:00:00' AND r.LossTime<'2019/5/6 0:00:00' AND r.InsuranceType IN (5,6,7,8) AND r.CatasCollectionId=0
 
UNION ALL
SELECT r.id AS reportid , o.OrganizationCode,o.organizationname, o.id OrganizationId,o.organizationlevel ,o.UpperComCode
FROM report r JOIN organization o ON r.OrganizationCode = o.OrganizationCode
WHERE o.UpperComCode IN('44010000','44040000','44006600','44008800','44020000','44050000','44060000','44070000','44080000','44090000','44120000','44150000','44160000','44170000','44180000','44190000','44510000','44520000','44530000','44710000','44940000','44950000')AND r.ReportTime>'2010/4/25 0:00:00' AND r.ReportReasonSubmitCode IN ('A10006','A10007') AND r.ReportTime<'2019/5/20 0:00:00' AND r.LossTime>'2010/4/11 0:00:00' AND r.LossTime<'2019/5/6 0:00:00' AND r.InsuranceType IN (5,6,7,8) AND r.CatasCollectionId=0
 
UNION ALL
SELECT r.id AS reportid , o.UpperComCode OrganizationCode,o.ParentOrgName OrganizationName, o.ParentOrgId OrganizationId,ou.organizationlevel ,ou.UpperComCode
FROM report r JOIN organization o ON r.OrganizationCode = o.OrganizationCode
JOIN organization ou ON o.UpperComCode=ou.OrganizationCode
WHERE o.UpperComCode IN
(SELECT OrganizationCode FROM organization WHERE UpperComCode IN
('44010000','44040000','44006600','44008800','44020000','44050000','44060000','44070000','44080000','44090000','44120000','44150000','44160000','44170000','44180000','44190000','44510000','44520000','44530000','44710000','44940000','44950000' )AND r.ReportTime>'2010/4/25 0:00:00' AND r.ReportReasonSubmitCode IN ('A10006','A10007') AND r.ReportTime<'2019/5/20 0:00:00' AND r.LossTime>'2010/4/11 0:00:00' AND r.LossTime<'2019/5/6 0:00:00' AND r.InsuranceType IN (5,6,7,8) AND r.CatasCollectionId=0)
 
) a
GROUP BY a.OrganizationCode,a.organizationname, a.OrganizationId,a.organizationlevel,a.UpperComCode
ORDER BY a.organizationlevel
```

### mysql两个索引时的union与or的比较

背景：用一个表中的父子级关系进行查询 优化的过程中 发现可以使用 or 来代替 union all

union all 需要查询两次 表 而 使用 or只需要 查询 一次 并且 两个字段都建立了索引

```sql
SELECT OrganizationCode FROM organization WHERE OrganizationCode IN ('44010000')
UNION ALL 
SELECT OrganizationCode FROM organization WHERE UpperComCode IN ('44010000');

SELECT OrganizationCode FROM organization WHERE OrganizationCode IN ('44010000') OR uppercomcode IN ('44010000')
```

------

## **索引的分类:**

主键索引（PRIMAY KEY）

唯一索引（UNIQUE）

常规索引（INDEX）

全文索引（FULLTEXT）

# MySQL_窗口函数_PARTITION BY 与 ORDER BY

窗口函数是分组统计的神器，在分组统计的情况下非常有用。

```sql
SELECT id, country, city, rating, 
RANK() OVER(PARTITION BY country ORDER BY rating DESC) AS `rank`
FROM store;

　count() over(partition by ... order by ...)：求分组后的总数。
　max() over(partition by ... order by ...)：求分组后的最大值。
　min() over(partition by ... order by ...)：求分组后的最小值。
　avg() over(partition by ... order by ...)：求分组后的平均值。
　lag() over(partition by ... order by ...)：取出前n行数据。　　
　lead() over(partition by ... order by ...)：取出后n行数据。


```

# MySQL大数据表处理的三种方案，查询效率嘎嘎高！

引用：https://mp.weixin.qq.com/s?__biz=MzA4NzQ0Njc4Ng==&mid=2247506058&idx=1&sn=b238e58ef533a2a6e38369a71e1d066a&chksm=903bdce7a74c55f18baee2651a312f92ddbc9b3225f63f419667a229e8e85fa50cad7a0488cc&scene=132#wechat_redirect

## 方案一：数据表分区

好处：多个分区放在多个磁盘，可以放更多的数据

​			可以删除分区来快速删除特定的数据

​             通过跨多个磁盘来分散数据查询，来获得更大的查询吞吐量。

限制：

- 一个表最多只能有1024个分区。

## **方案二：数据库分表**

- mysql的分表是真正的分表，一张表分成很多表后，每一个小表都是完整的一张表，都对应三个文件，一个`.MYD`数据文件，`.MYI`索引文件，`.frm`表结构

## **方案三：冷热归档**

定时任务定时转移过期数据

## 大数据表处理

![图片](https://mmbiz.qpic.cn/mmbiz_png/eQPyBffYbuc8N2iaSMLD3ib902z0jroQKMBKL7ATynz5Iac4a1v4zSvqS8eLhKWB9miakFaic6J7Fvag73HVgUUtkQ/640?wx_fmt=png&wxfrom=5&wx_lazy=1&wx_co=1)
