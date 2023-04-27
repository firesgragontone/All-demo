[TOC]



## Stream Collectors.groupingBy的四种用法 解决分组统计（计数、求和、平均数等）、范围统计、分组合并、分组结果自定义映射等问题

1. **基础分组功能**
Collectors.groupingBy：基础分组功能
Collectors.groupingBy：自定义键——字段映射
Collectors.groupingBy：自定义键——范围
2. **分组统计功能**
Collectors.counting：计数
Collectors.summingInt：求和
Collectors.averagingInt：平均值
Collectors.minBy：最大最小值
Collectors.summarizingInt：完整统计（同时获取以上的全部统计结果）
Collectors.partitioningBy：范围统计
3. **分组合并功能**
Collectors.reducing：合并分组结果
Collectors.joining：合并字符串
4. **分组自定义映射功能**
Collectors.toXXX：映射结果为Collection对象
Collectors.mapping：自定义映射结果
Collector：自定义downstream



```java
#前置数据
List<Student> students = Stream.of(
        Student.builder().name("小张").age(16).clazz("高一1班").course("历史").score(88).build(),
        Student.builder().name("小李").age(16).clazz("高一3班").course("数学").score(12).build(),
        Student.builder().name("小王").age(17).clazz("高二1班").course("地理").score(44).build(),
        Student.builder().name("小红").age(18).clazz("高二1班").course("物理").score(67).build(),
        Student.builder().name("李华").age(15).clazz("高二2班").course("数学").score(99).build(),
        Student.builder().name("小潘").age(19).clazz("高三4班").course("英语").score(100).build(),
        Student.builder().name("小聂").age(20).clazz("高三4班").course("物理").score(32).build()
).collect(Collectors.toList());


```

#### Collectors.groupingBy：基础分组功能

```java
// 将不同课程的学生进行分类
Map<String, List<Student>> groupByCourse = students.stream().collect(Collectors.groupingBy(Student::getCourse));
Map<String, List<Student>> groupByCourse1 = students.stream().collect(Collectors.groupingBy(Student::getCourse, Collectors.toList()));
// 上面的方法中容器类型和值类型都是默认指定的，容器类型为：HashMap，值类型为：ArrayList
// 可以通过下面的方法自定义返回结果、值的类型
Map<String, List<Student>> groupByCourse2 = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse, HashMap::new, Collectors.toList()));

```

#### Collectors.groupingBy：自定义键——字段映射

```java
// 字段映射 分组显示每个课程的学生信息
Map<String, List<Student>> filedKey = students.stream().collect(Collectors.groupingBy(Student::getCourse));
// 组合字段 分组现实每个班不同课程的学生信息
Map<String, List<Student>> combineFiledKey = students.stream().collect(Collectors.groupingBy(student -> student.getClazz() + "#" + student.getCourse()));

```

#### Collectors.groupingBy：自定义键——范围

```sql
// 根据两级范围 将学生划分及格不及格两类
Map<Boolean, List<Student>> customRangeKey = students.stream().collect(Collectors.groupingBy(student -> student.getScore() > 60));
// 根据多级范围 根据学生成绩来评分
Map<String, List<Student>> customMultiRangeKey = students.stream().collect(Collectors.groupingBy(student -> {
    if (student.getScore() < 60) {
        return "C";
    } else if (student.getScore() < 80) {
        return "B";
    }
    return "A";
}));

```

### 2. 分组统计功能

```java
// 计数
Map<String, Long> groupCount = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse, Collectors.counting()));

// 求和
Map<String, Integer> groupSum = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse, Collectors.summingInt(Student::getScore)));

// 增加平均值计算
Map<String, Double> groupAverage = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse, Collectors.averagingInt(Student::getScore)));

// 同组最小值
Map<String, Optional<Student>> groupMin = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse,Collectors.minBy(Comparator.comparing(Student::getCourse))));
// 使用Collectors.collectingAndThen方法，处理Optional类型的数据
Map<String, Student> groupMin2 = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse,
        Collectors.collectingAndThen(Collectors.minBy(Comparator.comparing(Student::getCourse)), op ->op.orElse(null))));
// 同组最大值
Map<String, Optional<Student>> groupMax = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse,Collectors.maxBy(Comparator.comparing(Student::getCourse))));


// 统计方法同时统计同组的最大值、最小值、计数、求和、平均数信息
HashMap<String, IntSummaryStatistics> groupStat = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse, HashMap::new,Collectors.summarizingInt(Student::getScore)));
groupStat.forEach((k, v) -> {
	// 返回结果取决于用的哪种计算方式
    v.getAverage();
    v.getCount();
    v.getMax();
    v.getMin();
    v.getSum();
});

// 切分结果，同时统计大于60和小于60分的人的信息
Map<String, Map<Boolean, List<Student>>> groupPartition = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse, Collectors.partitioningBy(s -> s.getScore() > 60)));
// 同样的，我们还可以对上面两个分组的人数数据进行统计
Map<String, Map<Boolean, Long>> groupPartitionCount = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse, Collectors.partitioningBy(s -> s.getScore() > 60, Collectors.counting())));

Map<String, Map<Boolean, Map<Boolean, List<Student>>>> groupAngPartitionCount = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse, Collectors.partitioningBy(s -> s.getScore() > 60,
                Collectors.partitioningBy(s -> s.getScore() > 90))));


```

### 3. 分组合并功能

```java
// 合并结果，计算每科总分
Map<String, Integer> groupCalcSum = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse, Collectors.reducing(0, Student::getScore, Integer::sum)));
// 合并结果，获取每科最高分的学生信息
Map<String, Optional<Student>> groupCourseMax = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse, Collectors.reducing(BinaryOperator.maxBy(Comparator.comparing(Student::getScore)))));

// 统计各科的学生姓名
Map<String, String> groupCourseSelectSimpleStudent = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse, Collectors.mapping(Student::getName, Collectors.joining(","))));


```

### 4. 分组自定义映射功能

```java
Map<String, Map<String, Integer>> courseWithStudentScore = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse, Collectors.toMap(Student::getName, Student::getScore)));
Map<String, LinkedHashMap<String, Integer>> courseWithStudentScore2 = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse, Collectors.toMap(Student::getName, Student::getScore, (k1, k2) -> k2, LinkedHashMap::new)));

//将结果映射为指定字段：
Map<String, List<String>> groupMapping = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse, Collectors.mapping(Student::getName, Collectors.toList())));
//转换bean对象：
Map<String, List<OutstandingStudent>> groupMapping2 = students.stream()
        .filter(s -> s.getScore() > 60)
        .collect(Collectors.groupingBy(Student::getCourse, Collectors.mapping(s -> BeanUtil.copyProperties(s, OutstandingStudent.class), Collectors.toList())));

// 组合joining
Map<String, String> groupMapperThenJoin= students.stream()
        .collect(Collectors.groupingBy(Student::getCourse, Collectors.mapping(Student::getName, Collectors.joining(","))));
// 利用collectingAndThen处理joining后的结果
Map<String, String> groupMapperThenLink = students.stream()
        .collect(Collectors.groupingBy(Student::getCourse,
                Collectors.collectingAndThen(Collectors.mapping(Student::getName, Collectors.joining("，")), s -> "学生名单：" + s)));

```

### 5.分页

```
int skipNum = form.getLimit() * (form.getPage() - 1);
ret = vos.stream().skip(skipNum).limit(form.getLimit()).collect(Collectors.toList());
```
