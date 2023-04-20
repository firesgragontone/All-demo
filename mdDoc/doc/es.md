[TOC]



## elasticsearch架构分层

![img](https://img-blog.csdnimg.cn/e9fb78748c414bd69f9c008123c88d8b.png)



## es插入数据

![img](https://img-blog.csdnimg.cn/img_convert/b0bf4bf207e37083fec0dbd202ea5f22.png)

1. 客户端选择一个 node 发送请求过去，这个 node 就是 coordinating node (协调节点)

2. coordinating node，对 document 进行路由，将请求转发给对应的 node

3. 实际上的 node 上的 primary shard 处理请求，然后将数据同步到 replica node

4. coordinating node，如果发现 primary node 和所有的 replica node 都搞定之后，就会返回请求到客户端

     **其中步骤 3 中 primary 直接落盘 IO 效率低，所以参考操作系统的异步落盘机制：**

- ES 使用了一个内存缓冲区 Buffer，先把要写入的数据放进 buffer；同时将数据写入 translog 日志文件（其实是些 os cache）。


- refresh：buffer 数据满/1s 定时器到期会将 buffer 写入操作系统 segment file 中，进入 cache 立马就能搜索到，所以说 es 是近实时（NRT，near real-time）的

- flush：tanslog 超过指定大小/30min 定时器到期会触发 commit 操作将对应的 cache 刷到磁盘 file，commit point 写入磁盘，commit point 里面包含对应的所有的 segment file

- translog 默认 5s 把 cache fsync 到磁盘，所以 es 宕机会有最大 5s 窗口的丢失数据
  ————————————————
  版权声明：本文为CSDN博主「倾听铃的声」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
  原文链接：https://blog.csdn.net/m0_67698950/article/details/124027119



## 读取数据

1. 客户端发送任何一个请求到任意一个 node，成为 coordinate node
2. coordinate node 对 document 进行路由，将请求 rr 轮训转发到对应的 node，在 primary shard 以及所有的 replica 中随机选择一个，让读请求负载均衡，

3. 接受请求的 node，返回 document 给 coordinate note

4. coordinate node 返回给客户端


## 搜索过程

1. 客户端发送一个请求给 coordinate node
2. 协调节点将搜索的请求转发给所有的 shard 对应的 primary shard 或 replica shard

3. query phase：每一个 shard 将自己搜索的结果（其实也就是一些唯一标识），返回给协调节点，有协调节点进行数据的合并，排序，分页等操作，产出最后的结果

4. fetch phase ，接着由协调节点，根据唯一标识去各个节点进行拉去数据，最总返回给客户端
   ————————————————
   版权声明：本文为CSDN博主「倾听铃的声」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
   原文链接：https://blog.csdn.net/m0_67698950/article/details/124027119



## es与数据库对应关系

| es                           | 数据库 |
| ---------------------------- | ------ |
| 索引（index）                | 数据库 |
| 类型（type） (es7后没有type) | 表     |
| 文档 （document）            | 行     |
| 字段（Feild）                | 列     |

## es使用kibana交互

es遵循restful规范

### 直接用url请求

```json
#新建索引menu
http://127.0.0.1:9200/menu

#新建索引
http://127.0.0.1:9200/store
{
  "mappings": {
    "book": {
      "properties": {
        "text": { 
          "type": "string",
          "analyzer": "standard"
        }
      }
    },
    "user": {
      "properties": {
        "text": { 
          "type": "string",
          "analyzer": "standard"
        }
      }
    }
  }
}


http://127.0.0.1:9200/_mapping/user
{
  "properties": {
    "text": {
      "type": "string",
      "analyzer": "standard",
      "search_analyzer": "whitespace"
    }
  }
}

http://127.0.0.1:9200/_mapping/book
{
  "properties": {
    "text": {
      "type": "string",
      "analyzer": "standard",
      "search_analyzer": "whitespace"
    }
  }
}
#新增doc
http://127.0.0.1:9200/store/book/2
{
  "title": "混乱的代价",
  "description": "混乱是阶梯 ",
  "price": 9999,
  "onSale": "true",
  "type": "恩菲",
  "createDate": "2018-01-12"
}
#新增doc
http://127.0.0.1:9200/store/book/3?pretty

{
  "title": "百年孤独",
  "description": "混乱的一生 ",
  "price": 9999,
  "onSale": "true",
  "type": "恩菲",
  "createDate": "2018-01-12"
}

#查询get
http://127.0.0.1:9200/store/book/1?pretty

#查询post
http://127.0.0.1:9200/store/book/1?pretty

#更新post
http://127.0.0.1:9200/store/book/1/_update?pretty
{"doc":{
  "price": 7777
}}

#查询特定字段
http://127.0.0.1:9200/store/book/1?_source=doc,price&pretty

#返回所有满足条件的
http://127.0.0.1:9200/store/book/_search?pretty
{
   "query": {"match_all": {}},
   "size": 1
}

#查看所有的索引
http://127.0.0.1:9200/_cat/indices?v



```



### es用java客户端构造请求

1.构造查询请求

```java
SearchRequest searchRequest = new SearchRequest();
SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
BoolQueryBuilder boolQueryBuilder = buildGuarnteeBondQuery(form);
searchSourceBuilder.query(boolQueryBuilder);
```
3.构造条件  （termsQuery表示文档包含）

```java
BoolQueryBuilder boolQueryBuilder = QueryBuilders.boolQuery();
TermsQueryBuilder termQueryBuilder = QueryBuilders.termsQuery("issuername", “小米”);
boolQueryBuilder.filter(termQueryBuilder);
```

3.时间范围

```java
 item.getNoticeDt().before(nowDate) && item.getMrtyDt().after(nowDate)
```

4.构造查询条件

matchAllQuery匹配所有

matchPhraseQuery对中文精确匹配

```Java
1，matchAllQuery匹配所有

queryBuilder.matchAllQuery();
2,termQuery精准匹配，大小写敏感且不支持

queryBuilder.termQuery("key", value) 一次匹配一个值，完全匹配
queryBuilder.termsQuery("key", obj1, obj2..)   一次匹配多个值
    
TermsQueryBuilder isDelBuilder = QueryBuilders.termsQuery(FieldName, new int[]{0});
boolQueryBuilder.filter(isDelBuilder);//可以连续添加多个条件
    
3，matchPhraseQuery对中文精确匹配

queryBuilder.matchPhraseQuery("key", value)

4，matchQuery("key", Obj) 单个匹配, field不支持通配符, 前缀具高级特性
queryBuilder.matchQuery(key, value);

5，multiMatchQuery("text", "field1", "field2"..); 匹配多个字段, field有通配符忒行

queryBuilder.multiMatchQuery(value, key1, key2, key3);
6，组合查询
   * must:   AND
   * mustNot: NOT
   * should:: OR
 queryBuilder.must(QueryBuilders.termQuery("user", "kimchy"))
            .mustNot(QueryBuilders.termQuery("message", "nihao"))
            .should(QueryBuilders.termQuery("gender", "male"));

7.模糊查询
 //搜索名字中含有jack文档（name中只要包含jack即可）  
 WildcardQueryBuilder wildcardQueryBuilder = QueryBuilders.wildcardQuery(“name”, "*" + form.getName() + "*");
                boolQueryBuilder.filter(wildcardQueryBuilder);
 boolQueryBuilder.filter(wildcardQueryBuilder);


8.分页查询
    searchSourceBuilder.size(20);
    searchSourceBuilder.from(0);
9.排序
searchSourceBuilder.sort(SortBuilders.fieldSort(BondInfoConstant.ISSUE_DATE).order(SortOrder.DESC));
searchSourceBuilder.sort("updated_date", SortOrder.DESC);
10.指定查询语句和索引
   searchSourceBuilder.query(boolQueryBuilder);
   searchRequest.source(searchSourceBuilder);
   searchRequest.indices(EsIndexConstant.BOND_BASICINFO_INDEX);
11.布尔查询----各种查询条件
    searchSourceBuilder.query(boolQueryBuilder);
	QueryBuilders.boolQuery();
    QueryBuilders.rangeQuery();
    QueryBuilders.termsQuery();
    QueryBuilders.fuzzyQuery();
    QueryBuilders.prefixQuery();
12.使用客户端连接查询
 SearchResponse searchResponse = restHighLevelClient.search(searchRequest, RequestOptions.DEFAULT);

 13.searchResponse.status() == RestStatus.OK判断是否查询成功
 14.取出es返回中的数据
      1.方式1
     
     if (searchResponse.status() == RestStatus.OK) {
            SearchHits hits = searchResponse.getHits();
            hits.forEach(e -> {
                Map<String, Object> sourceAsMap = e.getSourceAsMap();
                resultMapList.add(sourceAsMap);
            });
            resultVO.setTotal(hits.getTotalHits().value);
        } else {
            resultVO.setTotal(0L);
        }
        resultVO.setResult(resultMapList);
     2.方式2
         if (searchHits.length > 0) {
             for (SearchHit hit : searchHits) {
                 Map<String, Object> map = hit.getSourceAsMap();
                 GovernmentDistrictVO vo = JSON.parseObject(JSON.toJSONString(map), GovernmentDistrictVO.class);
                 governmentDistrictList.add(vo);
             }
         }
     3.聚合查询结果取出
         if (searchResponse.status() == RestStatus.OK) {
            Aggregation aggregation = searchResponse.getAggregations().get(cityGroupName);
            List<? extends Terms.Bucket> cityLevelBuckets = ((ParsedStringTerms) aggregation).getBuckets();
            for (Terms.Bucket cityLevelBucket : cityLevelBuckets) {
                //城市等级
                String cityLevel = cityLevelBucket.getKeyAsString();
                HashMap<String, Object> resultMap = Maps.newHashMap();
                resultMap.put(cityGroupName, cityLevel);
                for (LandGroupDto landGroupDto : groupList) {
                    double value = 0;
                    if (landGroupDto.getGroupType().equals("sum")) {
                        ParsedSum sumParse = cityLevelBucket.getAggregations().get(landGroupDto.getGroupName());
                        value = sumParse.getValue();
                    } else if (landGroupDto.getGroupType().equals("avg")) {
                        ParsedAvg avgParse = cityLevelBucket.getAggregations().get(landGroupDto.getGroupName());
                        value = avgParse.getValue();
                        if (Double.isInfinite(value)) {
                            value = 0;
                        }
                    }
                    resultMap.put(landGroupDto.getGroupName(), value);
                }
                resultList.add(resultMap);
            }
        }


15.聚合查询
    //计算列“issue_vol”的和，并赋值为par_value_sum
    SumAggregationBuilder sumAggregationBuilder = AggregationBuilders.sum("par_value_sum").field("issue_vol");
    FilterAggregationBuilder filterAggregationBuilder = AggregationBuilders.filter("remaining_year", QueryBuilders.rangeQuery("remaining_year").gt(0)).subAggregation(sumAggregationBuilder);
   searchSourceBuilder.aggregation(filterAggregationBuilder);

TermsAggregationBuilder termsAggregationBuilder = AggregationBuilders.terms("issue_year_term").field("issue_year").order(BucketOrder.key(true)).subAggregation(sumAggregationBuilder);
            searchSourceBuilder.aggregation(termsAggregationBuilder);
16.分组聚合查询
    AggregationBuilder city_level = AggregationBuilders.terms(cityGroupName).field(cityGroupName);

        for (LandGroupDto landGroupDto : groupList) {
            if (landGroupDto.getGroupType().equals("sum")) {
                SumAggregationBuilder sumAgg = AggregationBuilders.sum(landGroupDto.getGroupName()).field(landGroupDto.getGroupName());
                city_level = city_level.subAggregation(sumAgg);
            } else if (landGroupDto.getGroupType().equals("avg")) {
                AvgAggregationBuilder avgAgg = AggregationBuilders.avg(landGroupDto.getGroupName()).field(landGroupDto.getGroupName());
                city_level = city_level.subAggregation(avgAgg);
            }
        }


18 获取聚合结果
            //获取结果
 Map<String, Aggregation> asMap = searchResponse.getAggregations().getAsMap();
ParsedFilter parsedFilter = (ParsedFilter) asMap.get("age_sum");
ParsedSum parsedSum = (ParsedSum) parsedFilter.getAggregations().getAsMap().get("par_value_sum");
System.out.println(parsedSum.getValue());

19 keyword不分词查找 
 boolQueryBuilder.filter(QueryBuilders.termQuery("province_nm.keyword", form.getProvince()));

```



### 查询集群的信息

```json
GET _cat/health?v
```

​                                                                                                                     集群索引信息

![image-20220107171223458](C:\Users\Administrator.DESKTOP-80KRDB4\AppData\Roaming\Typora\typora-user-images\image-20220107171223458.png)



| 集群索引指标说明                          |                                                              |
| ----------------------------------------- | ------------------------------------------------------------ |
| 集群的状（status）                        | red红表示集群不可用，有故障。yellow黄表示集群不可靠但可用，一般单节点时就是此状态。green正常状态，表示集群一切正常。 |
| 节点（node.total）                        | 节点数，这里是1，表示该集群有1个节点。                       |
| 分片数（shards）                          | 这是152，表示我们把数据分成多少块存储。                      |
| 主分片数（pri）                           | primary shards，这里是152，实际上是分片数的两倍，因为有一个副本，如果有两个副本，这里的数量应该是分片数的三倍，这个会跟后面的索引分片数对应起来，这里只是个总数。 |
| 激活的分片百分比（active_shards_percent） | 这里可以理解为加载的数据分片数，只有加载所有的分片数，集群才算正常启动，在启动的过程中，如果我们不断刷新这个页面，我们会发现这个百分比会不断加大。 |
|                                           |                                                              |
|                                           |                                                              |
|                                           |                                                              |
|                                           |                                                              |



### filter与query对比大解密

**es缓存 filster**

添加filster条件在查询的时候，会将查询的结果缓存下来，这样能增加下次查询的速度。

**filter与query对比大解密**
	filter，仅仅只是按照搜索条件过滤出需要的数据而已，不计算任何相关度分数，对相关度没有任何影响。
	query，会计算每个document相对于搜索条件的相关度，并按照相关度进行排序。
       一般来说，如果你是在进行搜索，需要将最匹配搜索条件的数据先返回，那么用query；如果你只是要根据一些条件筛选出一部分数据，不关注排序，那么使用filter。

**filter和query性能对比**
    filter，不需要计算相关度分数，不需要按照相关度分数进行排序，同时还有内置的机制，自动cache最常使用filter的数据。
    query，相反，要计算相关度分数，按照分数进行排序，而且无法cache结果。

### **fielddata查询**

一般不推荐在Text字段上启用fielddata,因为field data和其缓存存储在堆中,这使得它们的计算成本很高.计算这些字段会造成延迟,增加的堆占用会造成集群性能问题.

这keyword和fielddata两种方式的区别除了具体实现方式外,主要在于是否要求对于文本字段进行解析操作,由于keyword不要求进行文本解析,所以它的效率更高.

那么如何实现聚合和排序那?
其实上面的异常提示中已经介绍了如何进行聚合排序,具体方式如下:

1 (推荐方式)在Text类型字段上增加keyword参数.这是字段就具备了全文检索能力(text)和聚合排序能力(keyword).
2 使用fielddata内存处理能力.如果要对分析后文本字段进行聚合排序或执行脚本处理文本时,只能使用fielddata方式.



### **es使用脚本查询**

不同字段的比较需要用脚本，且不能出现空值，否则报错。有多种查询语言，其中有一种是java语言的子集。

```json
{
  "query": {
    "bool": {
      "must": {
        "script": {
          "script": {
            "source": "doc['fieldA'].value >= doc['fieldB'].value"
          }
        }
      }
    }
  }
}
```



```java
painless语法
if (doc[item].size() == 0) {
  // do something if "item" is missing
} else if (doc[item].value == 'something') {
  // do something if "item" value is: something
} else {
  // do something else
}

if (doc['event_incoming_interval'].size() != 0) {
  doc['event_incoming_interval'].getValue() < 2L
}else{
  0L < 2L
}

if (doc['event_incoming_interval'].size() != 0) {
  doc['event_incoming_interval'].getValue() < 2L
}else{
  0L < 2L
}

doc['event_incoming_interval'].getValue() < 2L
    
数据Feild 设置了 keyword
GET company_warning_info/_search
{
  "query": {
    "bool": {
      "filter": [
        {
          "script": {
            "script": {
              "source": """if(doc['event_incoming_interval.keyword'].size() > 0){Long.parseLong(doc['event_incoming_interval.keyword'].value) <= 2L}"""
            }
          }
        }
        
      ]
    }
   
  }
}

设置了fielddata=true
GET company_warning_info/_search
{
  "query": {
   "bool": {
     "must": [
       {
          "script": {
          "script": """ if (doc['event_incoming_interval'].size() > 0) 		          {doc['event_incoming_interval'].getValue() <= 2L} """
    }
       }
     ]
   }
  },
  "sort": [
    {
      "event_incoming_interval": {
        "order": "asc"
      }
    }
  ]
  
}

//筛选T2 ≤ 2天的数据展示；历史数据视为满足T2 ≤ 2天的条件；
String interval = CompanyWarningConstant.EVENT_INCOMING_INTERVAL_VAL;
RangeQueryBuilder rangeQueryBuilder = QueryBuilders.rangeQuery(CompanyWarningConstant.EVENT_INCOMING_INTERVAL).lte(interval);
BoolQueryBuilder existsQuery = QueryBuilders.boolQuery().
mustNot(QueryBuilders.existsQuery(CompanyWarningConstant.EVENT_INCOMING_INTERVAL));
boolQueryBuilder.should(rangeQueryBuilder).should(existsQuery).minimumShouldMatch(1);

//调试判定字段类型
POST /company_warning_info/_explain/8d5df1551915c59cca5da6b54e06f84a
{
  "query": {
    "script": {
      "script": "Debug.explain(doc['result_desc'])"
    }
  }
}


    
```



## kibana#/dev_tools/console 客户端查询

```json
#条件删除
POST company_warning_info/_delete_by_query
{
  "query": {
    "match": {
      "event_class": "新增事件"
    }
  }
}
#根据id删除
DELETE company_warning_info/_doc/hUY0u38BWZHojpjwiAAM

//分页查询
GET  company_warning_info/_search
{
  "from": 3,
  "size": 1
}

#插入文档
POST company_warning_info/_doc
{         
          "company_id" : "88596",
          "event_body" : "广元市投资控股（集团）有限公司",
          "order_fields" : " ",
          "group_name" : "湖北融担项目风险监测2",
          "major_category" : "企业",
          "project_name" : "广元市投资项目",
          "log_id" : "10000000011825",
          "log_time" : "2021-10-18T08:54:54",
          "minor_category" : "主体公共信用风险",
          "risk_level" : "M",
          "event_desc" : "统计历史全量，企业近5年发行的债券中，评级偏低的债券占比大于等于60%，评级偏低的范围为低于AA，即(AA-,A+,A,A-,BBB+,BBB,BBB-,BB+,BB,BB-,B+,B,B-,CCC,CC,C,D) ",
          "event_id" : "10000088",
          "event_type" : "公共类事件",
          "group_id" : "127309",
          "event_name" : "企业历史发债评级偏低",
          "primary_id" : "c8ffff43efa35781dd7ea375ec641096",
          "event_body_area" : "",
           "result_desc" :"""发生时间：20150124，风险类别：公司实际担保总额占公司净资产比例超过20%，风险类别代码：FN004，事件类型：一般风险信号，风险严重程度：低，风险表述：2015年01月24日, 据临时公告披露, 方大特钢科技股份有限公司截止2015年01月24日, 报告期末实际担保总额为223500万元, 报告期末实际担保总额占公司净资产的比例为80.66%, 公司实际担保总额占公司净资产比例超过20%。；""",
           "area_id":"123",
          "body_type":"E1",
          "event_title":"提醒999",
          "event_class":"新增事件",
          "event_time_interval":12
}

#修改文档
PUT company_warning_info/_doc/gUYqtn8BWZHojpjw3gAs
{
  "primary_id" : "4444444444"
}

//查询表结构
GET company_warning_info/_mapping

多条件查询
# must
POST lc_guarantee_spread/_search
{
  "query": {
    "bool": {
      "must": [
        {"match": {
          "guarantor": "苏州市融资再担保有限公司"
        }},
        {"match": {
          "is_classified": "1"
        }}
      ]
    }
  }
}


# should
GET /bank/_search?pretty
{
  "query": {
    "bool": {
      "should": [
        { "match": { "address":{ "query":"mill", "_name":"first" } }},
        { "match": { "address":{"query":"lane","_name":"second" } }},
        { "term": { "age": "38" } }
      ],
      "minimum_should_match" : 2
    }
  },
  "_source": {  
    "includes" : [
      "address",
      "banalance",
      "age"
    ]
  }
}
# or查询
实现 "name"=="a" and ("city" == "b" or "city" == "c")
POST lc_guarantee_spread/_search
{
    "query": {
        "bool": {
            "must": [{
                "match_phrase": {
                    "name": "a"
                }
            }],
            "should": [{
                "match_phrase": {
                    "city": "b"
                }
            },
            {
                "match_phrase": {
                    "city": "c"
                }
            }],
            "minimum_should_match": 1
        }
    },
    "size": 5
}


```



4. 打印参数

5. ```
   System.out.println(searchSourceBuilder);
   ```

### #全面风险查询

```json
#全面风险查询
GET company_warning_info/_search
{
  "query": {
    "bool": {
      "should": [{
               "range": {
                 "event_incoming_interval": {
                   "lte": 20
                 }
               }
            },
            {
              "bool": {
                "must_not": [
                  {"exists": {"field": "event_incoming_interval"}}
                ]
              }
            }],
            "minimum_should_match": 1
      
    }
  }
}

POST company_warning_info/_doc
{
    "company_id" : "88596",
    "event_body" : "广元市投资控股（集团）有限公司",
    "event_body_area" : "",
    "event_desc" : "统计历史全量，企业的控股股东或实控人频繁减持",
    "event_id" : "10000080",
    "event_name" : "企业股权变更",
    "event_type" : "公共类事件",
    "group_id" : "127309",
    "group_name" : "湖北融担项目风险监测2",
    "log_id" : "10000000011795",
    "log_time" : "2021-10-18T08:54:06",
    "major_category" : "企业",
    "minor_category" : "经营风险",
    "order_fields" : " ",
    "primary_id" : "ecfde753c72222ce9868e2ece0fff5f0",
    "project_name" : "湖北融担项目",
    "result_desc" : """发生时间：20170714，风险类别：被采取监哈哈哈管措施，风险类别代码：OP011，事件类型：一般风险信号，风险严重程度：中，风险表述：2016年07月14日, 重庆永鹏网络科技股份有限公司披露公告: 
    重庆永鹏网络科技股份有限公司由于未及时披露公司重大事件被中国证券监督管理委员会重庆证监局处罚, 处罚类型: 监管措施, 处罚文号: [2016]12号；""",
    "risk_level" : "M",
    "area_id":"222",
    "body_type":"E1",
    "event_title":"提醒dddd",
    "event_class":"新增事件",
    "event_time_interval":40
}


GET company_warning_info/_search
{"query":{"bool":{"must":[{"terms":{"company_id.keyword":[0,389,14796,15897,16649,25360,34861,35392,41997,43846,45683,46641,51508,52824,61134,64798,65255,69613,76901,88121,88596,89140,90589,92728,96540,102556,107816,114072,117103,118177,130000,147224,147494,148652,163952,166540,169393,170519,170838,172656,172881,198439,202106,208825,213603,215915,227373,231596,232856,237645,239643,244251,250539,257262,260062,261253,264648,274430,286114,305049,310542,313495,333663,337150,338015,338832,343581,345424,347519,347962,374375,387684,409787,431388,434986,438443,439459,451741,458360,459009,465811,466743,468664,470884,472143,472777,476727,477282,477762,480081,480886,481097,487927,493041,513747,519669,571821,573458,596387,2933536,5476983,6110523,6113029,6113433,6113530,6114329,6146746,6253378,6348874,6382048,6461463,6567122,6874219,6951145,7098853,7260545,7444638,7785182,7958844,8384884,8449683,8471549,8698159,8767570,9121562,9224554,9624578,9684522,9754839,9947856,9998940,10133909,10216735,10218840,10416852,10424725,10671893,10766925,10852396,10860521,10915525,10927064,10945115,11026213,11027011,11027458,11092531,11109256,11334532,11359462,11489036,11651816,11652923,12016428,12047215,12060485,17466163,44162668,44184561,45374940,46695115,48412178,48810565,49812469,50476521,51168928,54415371,54447583,54506217,54597062,55151582,55493074,55659203,56054905,60942026,81667585,89493970,92928742,94407550],"boost":1.0}},{"terms":{"event_body.keyword":["双城信用增进股份有限公司","宜华健康医疗股份有限公司","诸城市经济开发投资公司","攀枝花市国有投资（集团）有限责任公司","峨眉山发展(控股)有限责任公司","成都市新津县国有资产投资经营有限责任公司","彭山发展控股有限责任公司","攀枝花市城市建设投资经营有限公司","四川成阿发展实业有限公司","重庆市合川工业投资(集团)有限公司","巴中市国有资本运营集团有限公司","成都市郫都区国有资产投资经营公司","都江堰兴堰投资有限公司","渤海银行股份有限公司","长城华西银行股份有限公司","眉山市资产经营有限公司","重庆大足工业园区建设发展有限公司","乐山高新投资发展（集团）有限公司","四川省国有资产经营投资管理有限责任公司","重庆市万州三峡平湖有限公司","广元市投资控股（集团）有限公司","彭州市国有投资有限公司","眉山发展控股集团有限公司","广元市园区建设投资有限公司","成都市金牛城市建设投资经营集团有限公司","雅安发展投资有限责任公司","成都蜀都川菜产业投资发展有限公司","成都市新津水城水务投资有限责任公司","成都兴蜀投资开发有限责任公司","重庆绅鹏实业开发有限公司","彭州市国有资产经营管理有限公司","成都经济技术开发区建设发展有限公司","成都市兴蒲投资有限公司","重庆市永川区兴永建设发展有限公司","任兴集团有限公司","内江市兴元实业有限责任公司","成都市润弘投资有限公司","泸州市龙驰实业集团有限责任公司","南充航空港投资开发有限公司","成都市青白江区国有资产投资经营有限公司","邛崃市建设投资集团有限公司","重庆市茶园工业园区建设开发有限责任公司","成都市龙泉现代农业投资有限公司","绵阳科技城发展投资（集团）有限公司","成都市新益州城市建设发展有限公司","成都经济技术开发区国有资产投资有限公司","金堂县国有资产投资经营有限责任公司","泸州市工业投资集团有限公司","恒大集团有限公司","崇州市兴旅景区管理有限公司","达州发展(控股)有限责任公司","遂宁市富源实业有限公司","江油鸿飞投资（集团）有限公司","成都海科投资有限责任公司","成都市蜀州城市建设投资有限责任公司","自贡市国有资本投资运营集团有限公司","新津新城发展集团有限公司","四川发展土地资产运营管理有限公司","浙江南太湖控股集团有限公司","内江建工集团有限责任公司","华为技术有限公司","遂宁发展投资集团有限公司","成都双流兴城建设投资有限公司","成都市兴光华城市建设有限公司","成都市融禾现代农业发展有限公司","自贡高新国有资本投资运营集团有限公司","重庆大足石刻国际旅游集团有限公司","金堂县兴金开发建设投资有限责任公司","成都隆博投资有限责任公司","寿光市城市建设投资开发有限公司","成都市新津县城乡建设投资有限责任公司","沧州港务集团有限公司","成都市兴城建实业发展有限责任公司","四川龙阳天府新区建设投资有限公司","眉山市东坡发展投资有限公司","成都铸康实业有限公司","泸州兴阳投资集团有限公司","重庆豪江建设开发有限公司","广安发展建设集团有限公司","重庆铝产业开发投资集团有限公司","内江投资控股集团有限公司","遂宁开达投资有限公司","成都新开元城市建设投资有限公司","重庆万林投资发展有限公司","绵阳经开投资控股集团有限公司","重庆市双桥经济技术开发区开发投资集团有限公司","达州市国有资产经营管理有限公司","成都花园水城城乡建设投资有限责任公司","广安经济技术开发区恒生投资开发有限公司","遂宁广利工业发展有限公司","重庆市四面山旅游投资有限公司","彭州市统一建设集团有限公司","四川发展资产管理有限公司","碧桂园地产集团有限公司","威海市文登区蓝海投资开发有限公司","成都宜居水城城乡交通建设投资有限公司","成都天府水城城乡水务建设有限公司","四川简州城投有限公司","广安交通投资建设开发集团有限责任公司","成都武侯资本投资管理集团有限公司","洪湖市弘瑞投资开发有限公司","遂宁柔刚投资有限责任公司","简阳市现代工业投资发展有限公司","新津县交通建设投资有限责任公司","四川秦巴新城投资集团有限公司","简阳市水务投资发展有限公司","成都市兴锦现代农业投资有限责任公司","南充市顺投发展集团有限公司","成都市金牛农发投资有限公司","江油城市投资发展有限公司","成都市新津花红堰投资有限公司","重庆大足永晟实业发展有限公司","内江路桥集团有限公司","泸州临港投资集团有限公司","崇州市鼎兴实业有限公司","成都九联投资有限公司","成都西岭城乡投资运营集团有限公司","绵竹市金申投资集团有限公司","崇州市崇兴投资有限责任公司","成都市金牛国有资产投资经营集团有限公司","重庆巴洲文化旅游产业集团有限公司","广汉市广鑫投资发展有限公司","荣成市财鑫投资有限公司","蒲江县城乡建设项目管理投资有限公司","泸州白酒产业发展投资集团有限公司","四川阳安交通投资有限公司","四川省商业投资集团有限责任公司","成都光华资产管理有限公司","绵阳富诚投资集团有限公司","邛崃市天际山水文化旅游投资集团有限公司","宜宾市翠屏区国有资产经营管理有限责任公司","攀枝花市花城投资有限责任公司","四川雄州实业有限责任公司","绵阳宏达资产投资经营(集团)有限公司","无锡惠玉投资控股有限公司","成都市惠山城市建设投资有限公司","成都市瀚宇投资有限公司","宣汉县城乡建设发展有限公司","自贡市城市建设投资开发集团有限公司","广安金财投融资(集团)有限责任公司","成都智慧城市交通建设投资有限公司","江安县城市建设投资有限责任公司","泸州汇兴投资集团有限公司","成都金堂发展投资有限公司","屏山县恒源投资有限公司","什邡市国有投资控股集团有限公司","四川花园水城城乡产业发展投资开发有限责任公司","泸州市城市建设投资集团有限公司","绵阳新兴投资控股有限公司","遂宁市天泰旅游投资开发有限公司","江油市创元开发建设投资公司","四川岷东城市建设开发有限公司","泸州市高新投资集团有限公司","遂宁市天泰实业有限责任公司","四川通融统筹城乡建设投资有限公司","广安鑫鸿投资控股有限公司","成都九联科海健康科技有限公司","乐山城市建设投资发展(集团)有限公司","华鲁能源有限公司","成都湔江投资集团有限公司","延安经济技术开发建设投资有限公司","西安港实业有限公司","成都市龙腾水利开发有限公司","乐山交通投资发展(集团)有限公司","成都市天新交通建设有限公司","成都市简州新城投资集团有限公司","泸州航空发展投资集团有限公司","眉山市工业投资有限公司","四川省广播电视工程公司","成都市羊安新城开发建设有限公司","达州市文化旅游投资有限公司","泸州市江南新区建设投资有限责任公司","宜宾市科教产业投资集团有限公司","无锡惠鑫汇资产经营管理有限公司","北京普联普惠科技有限公司","眉山天府新区投资集团有限公司","四川天府增进投资管理有限公司","中证信用融资担保有限公司","雅安产业投资（集团）有限公司"],"boost":1.0}}],"filter":[{"match":{"event_class.keyword":{"query":"新增事件","operator":"OR","prefix_length":0,"max_expansions":50,"fuzzy_transpositions":true,"lenient":false,"zero_terms_query":"NONE","auto_generate_synonyms_phrase_query":true,"boost":1.0}}},{"match":{"body_type.keyword":{"query":"E1","operator":"OR","prefix_length":0,"max_expansions":50,"fuzzy_transpositions":true,"lenient":false,"zero_terms_query":"NONE","auto_generate_synonyms_phrase_query":true,"boost":1.0}}}],"should":[{"range":{"event_incoming_interval":{"from":null,"to":null,"include_lower":true,"include_upper":true,"boost":1.0}}},{"bool":{"must_not":[{"exists":{"field":"event_incoming_interval","boost":1.0}}],"adjust_pure_negative":true,"boost":1.0}}],"adjust_pure_negative":true,"minimum_should_match":"1","boost":1.0}},"sort":[{"event_incoming_interval":{"order":"desc"}}]}


{groupId=128071, companyList=[QueryCompanyInfoForm(companyId=389, companyName=宜华健康医疗股份有限公司), QueryCompanyInfoForm(companyId=2339, companyName=海尔集团公司), QueryCompanyInfoForm(companyId=52824, companyName=渤海银行股份有限公司), QueryCompanyInfoForm(companyId=81530, companyName=比亚迪汽车有限公司), QueryCompanyInfoForm(companyId=179213, companyName=云锋(SZ)投资香港有限公司), QueryCompanyInfoForm(companyId=232856, companyName=恒大集团有限公司), QueryCompanyInfoForm(companyId=247729, companyName=鲁能集团有限公司), QueryCompanyInfoForm(companyId=275419, companyName=腾讯科技(深圳)有限公司), QueryCompanyInfoForm(companyId=310542, companyName=华为技术有限公司), QueryCompanyInfoForm(companyId=354389, companyName=五矿地产控股有限公司), QueryCompanyInfoForm(companyId=360238, companyName=方大特钢科技股份有限公司), QueryCompanyInfoForm(companyId=493041, companyName=碧桂园地产集团有限公司), QueryCompanyInfoForm(companyId=11883804, companyName=江苏华为医药物流有限公司华为大药房), QueryCompanyInfoForm(companyId=16618800, companyName=中铁三局集团), QueryCompanyInfoForm(companyId=20317245, companyName=万科企业集团(简称：万科集团)), QueryCompanyInfoForm(companyId=26116303, companyName=南京金箔集团南京展销中心), QueryCompanyInfoForm(companyId=36474360, companyName=深圳市银城国际货运代理有限公司), QueryCompanyInfoForm(companyId=37169713, companyName=南京福瑞园餐饮有限公司), QueryCompanyInfoForm(companyId=58425162, companyName=五矿盛世广业(北京)有限公司), QueryCompanyInfoForm(companyId=79690276, companyName=临泉县宋集镇杨集123小吃店), QueryCompanyInfoForm(companyId=79853497, companyName=dsfa;lfkldfksd--2-45), QueryCompanyInfoForm(companyId=79918275, companyName=扎鲁特旗1+1文体用品), QueryCompanyInfoForm(companyId=80347530, companyName=邵阳市双清区1+1通讯), QueryCompanyInfoForm(companyId=97395324, companyName=悟新(深圳)数字科技有限公司), QueryCompanyInfoForm(companyId=102050972, companyName=中建八局中南建设有限公司), QueryCompanyInfoForm(companyId=104725989, companyName=中建八局苏中建设有限公司), QueryCompanyInfoForm(companyId=105821013, companyName=阜阳市颍东区1+1网吧), QueryCompanyInfoForm(companyId=106070061, companyName=农七师123团烨丰农资经销部), QueryCompanyInfoForm(companyId=106760755, companyName=苏州江南画院), QueryCompanyInfoForm(companyId=108437126, companyName=牡丹江市福思特1+1海鲜城), QueryCompanyInfoForm(companyId=108829822, companyName=飘1+1音乐虫工作室网吧), QueryCompanyInfoForm(companyId=115181059, companyName=重庆市南川区曾经餐馆4门市)], partFlag=false, exportFlag=false, page=1, limit=10}

GET  company_warning_info/_search
{"query":{"bool":{"must":[{"terms":{"company_id.keyword":[5056,389],"boost":1.0}},{"terms":{"event_body.keyword":["双城信用增进股份有限公司","重庆大足城乡建设投资集团有限公司"],"boost":1.0}}],
  "filter":[
            {"match":{"event_class.keyword":{"query":"新增事件","operator":"OR","prefix_length":0,"max_expansions":50,"fuzzy_transpositions":true,"lenient":false,"zero_terms_query":"NONE","auto_generate_synonyms_phrase_query":true,"boost":1.0}}},
            {"match":{"body_type.keyword":{"query":"E1","operator":"OR","prefix_length":0,"max_expansions":50,"fuzzy_transpositions":true,"lenient":false,"zero_terms_query":"NONE","auto_generate_synonyms_phrase_query":true,"boost":1.0}}}],"adjust_pure_negative":true,"boost":1.0}},"sort":[{"log_time":{"order":"desc"}}]}


//
一般不推荐在Text字段上启用fielddata,因为field data和其缓存存储在堆中,这使得它们的计算成本很高.计算这些字段会造成延迟,增加的堆占用会造成集群性能问题.

这keyword和fielddata两种方式的区别除了具体实现方式外,主要在于是否要求对于文本字段进行解析操作,由于keyword不要求进行文本解析,所以它的效率更高.

那么如何实现聚合和排序那?
其实上面的异常提示中已经介绍了如何进行聚合排序,具体方式如下:

1 (推荐方式)在Text类型字段上增加keyword参数.这是字段就具备了全文检索能力(text)和聚合排序能力(keyword).
2 使用fielddata内存处理能力.如果要对分析后文本字段进行聚合排序或执行脚本处理文本时,只能使用fielddata方式.
PUT indexname/_mapping
	{
	  "properties": {
	    "about": { 
	      "type":     "text",
	      "fielddata": true
	    }
	  }
	}



```

### java客户端多条件查询

```java
//多条件查询
BoolQueryBuilder boolQuery = QueryBuilders.boolQuery();
boolQuery.filter(QueryBuilders.termsQuery("查询条件a", "a值"));
boolQuery.should(QueryBuilders.termsQuery("查询条件b", "b值"))
    .should(QueryBuilders.termsQuery("查询条件c", "c值"))
    .minimumShouldMatch(1);
```

### kibana查询

```shell
多条件查询
{
  "from": 0,
  "size": 1000,
  "query": {
    "bool": {
      "filter": [
        {
          "terms": {
            "revenue_year": [
              "2021"
            ],
            "boost": 1
          }
        },
        {
          "terms": {
            "city": [
              "四川省-资阳市-乐至县",
              "四川省-资阳市-安岳县",
              "四川省-资阳市-资阳高新技术产业园区",
              "四川省-资阳市-雁江区"
            ],
            "boost": 1
          }
        },
        {
          "terms": {
            "is_del": [
              0
            ],
            "boost": 1
          }
        }
      ],
      "adjust_pure_negative": true,
      "boost": 1
    }
  }
}

PUT company_warning_info/_doc
{
    "_index" : "company_warning_info",
    "_type" : "_doc",
    "_id" : "a7c8c30da858f1ca4666b9ea79c615da",
    "_score" : null,
    "_source" : {
    "area_id" : "",
    "body_type" : "E1",
    "company_id" : "61134",
    "event_body" : "长城华西银行股份有限公司",
    "event_body_area" : "",
    "event_class" : "新增事件",
    "event_desc" : "新闻与企业相关且被标注为负面",
    "event_id" : "10000276",
    "event_incoming_interval" : "51",
    "event_name" : "企业新增负面新闻",
    "event_time" : "20220222080733",
    "event_time_interval" : "51",
    "event_title" : "2022年02月22日，长城华西银行股份有限公司出现轻微负面新闻：长城华西银行去年营收净利润双降 资产利润率连续4年低于监管“红线”",
    "event_type" : "公共类事件",
    "group_id" : "127459",
    "group_name" : "天府增信项目风险监测",
    "incoming_time" : "20220222162402",
    "log_id" : "10000000332576",
    "log_time" : "2022-04-13T13:30:23",
    "major_category" : "企业",
    "minor_category" : "经营风险-舆情风险",
    "order_fields" : "",
    "primary_id" : "a7c8c30da858f1ca4666b9ea79c615da",
    "project_name" : "",
    "result_desc" : "新闻ID：86700933，作者：中国网财经，来源：中国网财经，新闻链接：https://k.sina.cn/article_2377587254_8db71a36020011008.html，重要性：非常重要，情感值：轻微负面，关联性：较强，发布日期：2022-02-22 08:07:33，新闻标题：长城华西银行去年营收净利润双降 资产利润率连续4年低于监管“红线；",
    "risk_level" : "L"
}


POST company_warning_info/_doc
{
  "area_id": "",
  "company_id": "76901",
  "event_body": "四川省国有资产经营投资管理有限责任公司",
  "event_body_area": "",
  "event_desc": "公告与企业相关且被标注为负面",
  "event_id": "10000279",
  "event_incoming_interval": "2",
  "event_name": "企业新增负面公告",
  "event_time": "20220605000000",
  "event_time_interval": "2",
  "event_title": "2022年01月18日，四川省国有资产经营投资管理有限责任公司出现轻微负面公告：东方金诚国际信用评估有限公司关于四川省国有资产经营投资管理有限责任公司当年累计新增借款超过上年末净资产百分之二十以及资产无偿划转的关注公告",
  "event_type": "公共类事件",
  "group_id": "127459",
  "group_name": "天府增信项目风险监测",
  "incoming_time": "20220605191002",
  "log_id": "10000000358377",
  "log_time": "2022-06-05T13:31:26",
  "major_category": "企业",
  "minor_category": "经营风险-舆情风险",
  "order_fields": "",
  "primary_id": "99191cbd0d71ee459b790e7baaebeeee",
  "project_name": "",
  "result_desc": "公告ID：40507815，来源类型名称：中国货币网，公告链接：https://www.chinamoney.com.cn/dqs/cm-s-notice-query/fileDownLoad.do?contentId=2289765&priority=0&mode=open，重要性：比较重要，情感值：轻微负面，关联度：强，公告日期：2022-01-18，公告标题：东方金诚国际信用评估有限公司关于四川省国有资产经营投资管理有限责任公司当年累计新增借款超过上年末净资产百分之二十以及资产无偿划转的关注公；",
  "risk_level": "H"
}

GET company_warning_info/_search
{
  "_source": ["event_type"], 
  "collapse": {
    "field": "event_type.keyword"
  },
  "size": 100
  
}


#批量更新
POST company_warning_info/_bulk/
{"update":{"_id":"BTvPI4EBgTNU8YaYTeqy"}}
{"doc":{"primary_id":"99191cbd0d71ee459b790e7baaeb6610"}}
{"update":{"_id":"BjvPI4EBgTNU8YaYUOpP"}}
{"doc":{"primary_id":"99191cbd0d71ee459b790e7baaeb6611"}}
{"update":{"_id":"CTvPI4EBgTNU8YaYVeoy"}}
{"doc":{"primary_id":"99191cbd0d71ee459b790e7baaeb6612"}}
{"update":{"_id":"CjvPI4EBgTNU8YaYVuqd"}}
{"doc":{"primary_id":"99191cbd0d71ee459b790e7baaeb6613"}}
{"update":{"_id":"CzvPI4EBgTNU8YaYV-pr"}}
{"doc":{"primary_id":"99191cbd0d71ee459b790e7baaeb6614"}}
{"update":{"_id":"DDvPI4EBgTNU8YaYWOob"}}
{"doc":{"primary_id":"99191cbd0d71ee459b790e7baaeb6615"}}


POST cat/tab2/1/_update
{
    "age":99
}


说明：由于ES6.3以后已经支持sql查询，所有首先尝试大家最熟悉的sql查询方案能否实现。

POST /_sql?format=txt
{
  "query": "SELECT primary_id,count(primary_id) orderCount FROM company_warning_info group by primary_id having orderCount >=2 "
}


GET company_warning_info/_search
{"aggregations":{"group_by_minor_category":{"terms":{"field":"minor_category.keyword","size":10,"min_doc_count":1,"shard_min_doc_count":0,"show_term_doc_count_error":false,"order":[{"_count":"desc"},{"_key":"asc"}]}}},"query":{"bool":{"must":[{"terms":{"company_id.keyword":[0,14796,15897,16649,25360,34861,35392,41997,43846,45683,46641,51508,61134,64798,65255,69613,76901,88121,88596,89140,90589,92728,96540,102556,107816,114072,117103,118177,130000,135454,147224,147494,148652,163952,166540,169393,170519,170838,172656,172881,198439,202106,208825,213603,215915,227373,231596,237645,239589,239643,244251,250539,257262,260062,261253,264648,274430,286114,305049,313495,325568,333663,337150,338015,338832,343581,345424,347519,347962,374375,376675,387684,398877,401561,409787,431388,434986,438443,439459,451741,456265,458360,459009,460712,465811,466743,468664,470884,472143,472777,476727,477282,477762,480081,480886,481097,487927,492599,519669,571821,573458,596387,608581,2933536,4781096,6110523,6112020,6113029,6113433,6113530,6114329,6146746,6253378,6348874,6382048,6461463,6567122,6874219,6917153,6951145,7098853,7260545,7444638,7785182,7958844,8384884,8449683,8471549,8698159,8767570,9121562,9224554,9624578,9684522,9754839,9947856,9998940,10133909,10216735,10218840,10416852,10424725,10671893,10766925,10852396,10860521,10915525,10927064,10945115,11026213,11027011,11027458,11092531,11107376,11109256,11334532,11359462,11489036,11651816,11652923,12016428,12047215,12060485,17466163,42171099,44162668,45374940,46695115,48412178,48810565,49812469,50476521,51168928,54415371,54447583,54506217,54597062,54972075,55151582,55493074,55659203,56054905,81667585,89493970,92928742,94407550,107288597,118458024],"boost":1}},{"terms":{"event_body.keyword":["双城信用增进股份有限公司","诸城市经济开发投资公司","攀枝花市国有投资（集团）有限责任公司","峨眉山发展（控股）有限责任公司","成都市新津县国有资产投资经营有限责任公司","彭山发展控股有限责任公司","攀枝花城市投资建设（集团）有限公司","四川成阿发展实业有限公司","重庆市合川工业投资(集团)有限公司","巴中市国有资本运营集团有限公司","成都市郫都区国有资产投资经营公司","都江堰兴堰投资有限公司","长城华西银行股份有限公司","眉山市国有资本投资运营集团有限公司","重庆大足工业园区建设发展有限公司","乐山高新投资发展（集团）有限公司","四川省国有资产经营投资管理有限责任公司","重庆市万州三峡平湖有限公司","广元市投资控股（集团）有限公司","彭州市医药健康产业投资有限公司","眉山发展控股集团有限公司","广元市园区建设投资有限公司","成都市金牛城市建设投资经营集团有限公司","雅安发展投资有限责任公司","成都蜀都川菜产业投资发展有限公司","成都市新津环境投资集团有限公司","成都兴蜀投资开发有限责任公司","重庆绅鹏实业开发有限公司","彭州市国有资产经营管理有限公司","绵阳市投资控股（集团）有限公司","成都经开产业投资集团有限公司","成都市兴蒲投资有限公司","重庆市永川区兴永建设发展有限公司","任兴集团有限公司","内江兴元实业集团有限责任公司","成都市润弘投资有限公司","泸州市龙驰实业集团有限责任公司","南充临江东方投资集团有限公司","成都市青白江区国有资产投资经营有限公司","邛崃市建设投资集团有限公司","重庆市茶园工业园区建设开发有限责任公司","成都市龙泉现代农业投资有限公司","绵阳科技城发展投资（集团）有限公司","成都市新益州城市建设发展有限公司","成都经开国投集团有限公司","金堂县国有资产投资经营有限责任公司","泸州产业发展投资集团有限公司","成都市兴旅旅游发展有限责任公司","中证信用增进股份有限公司","达州发展（控股）有限责任公司","遂宁市富源实业有限公司","江油鸿飞投资（集团）有限公司","成都海科投资有限责任公司","成都市蜀州城市建设投资有限责任公司","自贡市国有资本投资运营集团有限公司","新津新城发展集团有限公司","四川发展土地资产运营管理有限公司","浙江南太湖控股集团有限公司","内江建工集团有限责任公司","遂宁发展投资集团有限公司","重庆市铜梁区金龙城市建设发展（集团）有限公司","成都空港兴城投资集团有限公司","成都市兴光华城市建设有限公司","成都市融禾投资发展集团有限公司","自贡高新国有资本投资运营集团有限公司","重庆大足石刻国际旅游集团有限公司","金堂县兴金开发建设投资有限责任公司","成都隆博投资有限责任公司","寿光市城市建设投资开发有限公司","成都市新津城乡建设投资有限责任公司","四川能投建工集团有限公司","沧州港务集团有限公司","成都市新都香城建设投资有限公司","荣成市经济开发投资有限公司","成都市兴城建实业发展有限责任公司","四川龙阳天府新区建设投资有限公司","眉山市东坡发展投资集团有限公司","成都铸康实业有限公司","泸州兴阳投资集团有限公司","重庆豪江建设开发有限公司","成都市兴锦城市建设投资有限责任公司","广安发展建设集团有限公司","重庆铝产业开发投资集团有限公司","余姚经济开发区建设投资发展有限公司","内江投资控股集团有限公司","遂宁开达投资有限公司","成都新开元城市建设投资有限公司","重庆万林投资发展有限公司","绵阳经开投资控股集团有限公司","重庆市双桥经济技术开发区开发投资集团有限公司","达州市高新科创有限公司","成都花园水城城乡建设投资有限责任公司","广安经济技术开发区恒生投资开发有限公司","遂宁广利工业发展有限公司","重庆市四面山旅游投资有限公司","彭州市城市建设投资集团有限公司","四川发展资产管理有限公司","长沙雨花经开开发建设有限公司","成都宜居水城城乡交通建设投资有限公司","成都天府水城城乡水务建设有限公司","简阳发展（控股）有限公司","广安交通投资建设开发集团有限责任公司","宁波市镇海发展有限公司","成都武侯资本投资管理集团有限公司","驻马店市产业投资集团有限公司","遂宁柔刚投资有限责任公司","四川省生态环保产业集团有限责任公司","简阳市现代工业投资发展有限公司","成都市新津交通建设投资有限责任公司","四川秦巴新城投资集团有限公司","简阳市水务投资发展有限公司","成都市兴锦现代农业投资有限责任公司","南充市顺投发展集团有限公司","成都市金牛环境投资发展集团有限公司","江油城市投资发展有限公司","成都天府农博乡村发展集团有限公司","重庆大足永晟实业发展有限公司","内江路桥集团有限公司","成都市蜀州兴宇城市建设有限责任公司","泸州临港投资集团有限公司","崇州市鼎兴实业有限公司","成都九联投资集团有限公司","成都西岭文旅投资运营集团有限公司","绵竹市金申投资集团有限公司","崇州市崇兴投资有限责任公司","成都市金牛国有资产投资经营集团有限公司","重庆巴洲文化旅游产业集团有限公司","广汉市广鑫投资发展有限公司","荣成市财鑫投资有限公司","蒲江县城乡建设项目管理投资有限公司","泸州白酒产业发展投资集团有限公司","四川阳安交通投资有限公司","四川省商业投资集团有限责任公司","成都光华资产管理有限公司","绵阳富诚投资集团有限公司","邛崃市天际山水文化旅游投资集团有限公司","宜宾市翠屏区国有资产经营管理有限责任公司","攀枝花市花城投资有限责任公司","四川雄州实业有限责任公司","绵阳宏达资产投资经营（集团）有限公司","无锡惠玉投资控股有限公司","成都西岭城市投资建设集团有限公司","成都市瀚宇投资有限公司","宣汉发展投资集团有限公司","自贡市城市建设投资开发集团有限公司","广安金财投融资（集团）有限责任公司","成都锦城光华投资集团有限公司","江安县城市建设投资有限责任公司","泸州汇兴投资集团有限公司","成都金堂发展投资有限公司","屏山县恒源投资有限公司","什邡市国有投资控股集团有限公司","四川花园水城城乡产业发展投资开发有限责任公司","简阳市汇众农业投资发展有限公司","泸州市城市建设投资集团有限公司","绵阳新兴投资控股有限公司","遂宁市天泰旅游投资开发有限公司","江油市创元开发建设投资有限公司","四川岷东城市建设开发有限公司","泸州市高新投资集团有限公司","遂宁市天泰实业有限责任公司","四川通融统筹城乡建设投资有限公司","广安鑫鸿投资控股有限公司","成都九联科海健康科技有限公司","金堂县兴金工业投资有限责任公司","乐山城市建设投资发展（集团）有限公司","成都湔江投资集团有限公司","延安经济技术开发建设投资有限公司","西安港实业有限公司","成都市龙腾水利开发有限公司","乐山交通投资发展（集团）有限公司","成都市天新交通建设有限公司","成都市简州新城投资集团有限公司","泸州航空发展投资集团有限公司","眉山市产业投资有限公司","四川省广播电视工程公司","成都市羊安新城开发建设有限公司","达州高新投资有限公司","达州市文化旅游投资有限公司","泸州市江南新区建设投资有限责任公司","宜宾市科教产业投资集团有限公司","无锡惠鑫汇资产经营管理有限公司","眉山天府新区投资集团有限公司","四川天府增进投资管理有限公司","中证信用融资担保有限公司","雅安产业投资（集团）有限公司","威宁县碧桂园农家乐","物衍商业保理有限公司"],"boost":1}}],"filter":[{"terms":{"risk_level.keyword":["L","M","H"],"boost":1}},{"range":{"log_time":{"from":"2022-01-01","to":null,"include_lower":true,"include_upper":true,"boost":1}}},{"range":{"log_time":{"from":null,"to":"2022-06-06","include_lower":true,"include_upper":true,"boost":1}}},{"bool":{"must_not":[{"script":{"script":{"source":"if (doc['event_incoming_interval'].size() > 0) {doc['event_incoming_interval'].getValue() <= 2L}","lang":"painless"},"boost":1}}],"adjust_pure_negative":true,"boost":1}},{"match":{"group_id.keyword":{"query":"127459","operator":"OR","prefix_length":0,"max_expansions":50,"fuzzy_transpositions":true,"lenient":false,"zero_terms_query":"NONE","auto_generate_synonyms_phrase_query":true,"boost":1}}}],"must_not":[{"match":{"event_class.keyword":{"query":"新增事件","operator":"OR","prefix_length":0,"max_expansions":50,"fuzzy_transpositions":true,"lenient":false,"zero_terms_query":"NONE","auto_generate_synonyms_phrase_query":true,"boost":1}}}],"adjust_pure_negative":true,"boost":1}},"sort":[{"log_time":{"order":"desc","missing": "_first"}},{"event_time.keyword":{"order":"desc","missing": "_first"}}]}


备份es
POST _reindex
{
  "source": {
    "index": "company_warning_info"
  },
   
  "dest": {
    "index": "company_warning_info0627"
  }
}

GET py_ct_area_rank/_search?scroll=1m
{
  "_source": {
    "excludes": "itemvalues"
  }
}

#游标查询 适合一页一页的往下查询
POST  /_search/scroll 
{
    "scroll" : "1m", 
    "scroll_id" : "FGluY2x1ZGVfY29udGV4dF91dWlkDXF1ZXJ5QW5kRmV0Y2gBFFVVNXltNEVCbEw2STE0YmVyZUFzAAAAAAAIoFoWcmhPQkwtbU1TV3EyUEp3b3FWY0xBZw==" 
}

GET py_ct_area_rank/_search?scroll=1m
{
  "_source": {
    "excludes": "itemvalues"
  }
}


  //指定distinct字段
 CollapseBuilder collapseBuilder = new CollapseBuilder("remaining_scale");
        searchSourceBuilder.collapse(collapseBuilder);
GET vw_dds_bond/_search
{
  "query": {
    "bool": {
      "must": [
        {
          "term": {
            "remaining_scale": {
              "value": "0"
            }
          }
        }
      ]
    }
  },
  "collapse": {
    "field": "bond_snm"
  }
}


```

```shell
#模糊搜索
GET company_warning_info/_search
{
  "query": {
    "simple_query_string": {
      "query": "公司"

    }
  }
}
+表示AND操作
|表示OR操作
-表示否定
"用于圈定一个短语
*放在token的后面表示前缀匹配
()表示优先级
~N放在token后面表示模糊查询的最大编辑距离fuzziness
~N放在phrase后面表示模糊匹配短语的slop值

作者：佛西先森
链接：https://www.jianshu.com/p/ca3b9fa67bcf
来源：简书
著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

#正则匹配查询
GET lkp_region/_search
{
  "query": {
    "regexp": {
      "region_nm.keyword": "简阳."
    }
  }
}


#分词器
POST /_analyze
{
  "analyzer": "standard",
  "text": "恒大地产集团有限公司"
}


#前缀搜索
GET company_warning_info/_search
{
  "query": {
    "match_bool_prefix": {
      "event_desc": "统计历史全量"
    }
  }
}


#搜索标题中包含java的帖子，同时呢，如果标题中包含hadoop或elasticsearch就优先搜索出来，同时呢，如果一个帖子包含java hadoop，一个帖子包含java elasticsearch，包含hadoop的帖子要比elasticsearch优先搜索出来
#知识点，搜索条件的权重，boost，可以将某个搜索条件的权重加大，此时当匹配这个搜索条件和匹配另一个搜索条件的#document，计算relevance score时，匹配权重更大的搜索条件的document，relevance score会更高，当然也就会优先被返回回来
#默认情况下，搜索条件的权重都是一样的，都是1

GET company_warning_info/_search
{
  "query": {
    "simple_query_string": {
      "query": "恒大地产集团有限公司 | 失信被执行人"
    }
  }
}

GET /forum/article/_search 
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "title": "blog"
          }
        }
      ],
      "should": [
        {
          "match": {
            "title": {
              "query": "java"
            }
          }
        },
        {
          "match": {
            "title": {
              "query": "hadoop"
            }
          }
        },
        {
          "match": {
            "title": {
              "query": "elasticsearch"
            }
          }
        },
        {
          "match": {
            "title": {
              "query": "spark",
              "boost": 5
            }
          }
        }
      ]
    }
  }
}
 
结果：
{
  "took" : 2,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 5,
    "max_score" : 1.7260925,
    "hits" : [
      {
        "_index" : "forum",
        "_type" : "article",
        "_id" : "5",
        "_score" : 1.7260925,
        "_source" : {
          "articleID" : "QQPX-R-3956-#aD8",
          "userID" : 2,
          "hidden" : true,
          "postDate" : "2017-01-02",
          "title" : "this is spark blog"
        }
      },
      {
        "_index" : "forum",
        "_type" : "article",
        "_id" : "4",
        "_score" : 1.6185135,
        "_source" : {
          "articleID" : "QQPX-R-3956-#aD8",
          "userID" : 2,
          "hidden" : true,
          "postDate" : "2017-01-02",
          "title" : "this is java, elasticsearch, hadoop blog"
        }
      },
      {
        "_index" : "forum",
        "_type" : "article",
        "_id" : "1",
        "_score" : 0.8630463,
        "_source" : {
          "articleID" : "XHDK-A-1293-#fJ3",
          "userID" : 1,
          "hidden" : false,
          "postDate" : "2017-01-01",
          "title" : "this is java and elasticsearch blog"
        }
      },
      {
        "_index" : "forum",
        "_type" : "article",
        "_id" : "3",
        "_score" : 0.5753642,
        "_source" : {
          "articleID" : "JODL-X-1937-#pV7",
          "userID" : 2,
          "hidden" : false,
          "postDate" : "2017-01-01",
          "title" : "this is elasticsearch blog"
        }
      },
      {
        "_index" : "forum",
        "_type" : "article",
        "_id" : "2",
        "_score" : 0.3971361,
        "_source" : {
          "articleID" : "KDKE-B-9947-#kL5",
          "userID" : 1,
          "hidden" : false,
          "postDate" : "2017-01-02",
          "title" : "this is java blog"
        }
      }
    ]
  }
}


#分词搜索
GET /match_phrase_db2/_search
{
  "query": {
    "match_phrase": {
      "content": {
        "query": "安徽风景区",
        "slop": 2
      }
    }
  }
}
```

