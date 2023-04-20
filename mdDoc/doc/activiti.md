[TOC]

# activiti模型图

1.流程设计模型：一览、编辑（模型编辑器）、部署模型

2.流程定义：一览、挂起、激活、启动流程实例

3.流程实例：一览、挂起、激活、查看当前状态

4.任务：一览、签收、完成

5.监听器：触发、处理

![img](https://upload-images.jianshu.io/upload_images/80770-be3dfc25d69470d6.png?imageMogr2/auto-orient/strip|imageView2/2/format/webp)

```
/ 启动流程
ProcessInstance processInstance = iRbmProcessService.startProcessInstanceByKey(
        projectInfo.getId().toString()
        , String.valueOf(issueRefund.getId())
        , ProjectActivityTypeEnum.PROJECT_REFUND_APPLY
        , messageTask, processParams);
        
        
 // 完成第一个节点
 Task task = taskService.createTaskQuery().processInstanceId(processInstance.getId()).singleResult();
 CommonProcessDispatchForm processDispatchForm = new CommonProcessDispatchForm();
 processDispatchForm.setActivitiComment(HandleTypeEnum.HANDLE_TYPE_TG.getMessage());
 processDispatchForm.setTaskId(task.getId());
 this.csciTaskService.taskComplete(processDispatchForm);       
        
```

```java
1.流程  ----参数设置  启动流程 完成节点

/*设置流程参数*/
Map<String, Object> processParams = Maps.newHashMap();
processParams.put("project_id", projectId);
processParams.put("product_id", productId);
processParams.put("issue_id", issueId);
processParams.put("_ACTIVITI_SKIP_EXPRESSION_ENABLED", true);

// 启动流程
ProcessInstance processInstance = iRbmProcessService.startProcessInstanceByKey(
        projectId.toString()
        , String.valueOf(issueId)
        , ProjectActivityTypeEnum.ISSUING_LOANS
        , messageTask, processParams);

 // 完成第一个节点
        Task task = taskService.createTaskQuery().processInstanceId(processInstance.getId()).singleResult();
```



**事件结束处理**

```
大家在流程结束的事件触发可以继承这个类ActivitiEndEventDelegate， 用于处理以下场景
1.流程正常结束
2.流程拒绝
3.流程中止

比如立项到决策阶段。完成的时候需要发起下阶段流程并修改业务状态，这种就用场景1
```

![image-20220518141159551](C:\Users\Administrator.DESKTOP-80KRDB4\AppData\Roaming\Typora\typora-user-images\image-20220518141159551.png)

![image-20220518141229469](C:\Users\Administrator.DESKTOP-80KRDB4\AppData\Roaming\Typora\typora-user-images\image-20220518141229469.png)



数星星的孩子:
@Xy 通过bpmnModel获取Process的方式，taskReject和finished实现各不一样，
reject是这样获取的： bpmnModel.getProcesses().get(0)
finished是这样获取的:  bpmnModel.getMainProcess()

这两有啥不同？

数星星的孩子:
[图片]

数星星的孩子:
对流程引擎做了一些扩展，通用审批添加了"终止"按钮，对应serviceCode = terminate
与reject的不同在于，当审批节点位于并行分支时，
reject只会将当前分支流转到end节点
terminate会将所有分支流转到end节点

酌情使用

流程根据参数动态设置处理人

Xy:
<activiti:executorBean>beanName</activiti:executorBean>

Xy:
ActivitiExecutorBean



```
ActivitiFlowHandler的接口


```

1. 前端的xml下载下来的时候会丢失<activiti:executorBean>标签的信息，导致出错

# 删除运行中的流程

```mysql
#删除流程
DELETE FROM ACT_HI_ATTACHMENT WHERE PROC_INST_ID_= '流程ID'; 
DELETE FROM ACT_HI_COMMENT WHERE PROC_INST_ID_='流程ID'; 
DELETE FROM ACT_HI_ACTINST WHERE PROC_INST_ID_='流程ID'; 
DELETE FROM ACT_HI_DETAIL WHERE PROC_INST_ID_='流程ID'; 
  
DELETE FROM ACT_HI_IDENTITYLINK WHERE TASK_ID_ IN(
SELECT ID_ FROM ACT_RU_TASK WHERE PROC_INST_ID_='流程ID'
UNION ALL
SELECT ID_ FROM ACT_HI_TASKINST WHERE PROC_INST_ID_='流程ID'
)OR PROC_INST_ID_ ='流程ID'; 
DELETE FROM ACT_HI_TASKINST WHERE PROC_INST_ID_='流程ID'; 
DELETE FROM ACT_HI_PROCINST WHERE PROC_INST_ID_='流程ID'; 
DELETE FROM ACT_HI_VARINST WHERE PROC_INST_ID_='流程ID'; 
DELETE FROM ACT_RU_EVENT_SUBSCR WHERE PROC_INST_ID_='流程ID'; 
DELETE FROM ACT_RU_IDENTITYLINK WHERE TASK_ID_ IN(SELECT ID_ FROM ACT_RU_TASK WHERE PROC_INST_ID_='流程ID')OR PROC_INST_ID_='流程ID'; 
DELETE FROM ACT_RU_VARIABLE WHERE PROC_INST_ID_='流程ID';  
  
DELETE FROM ACT_RU_TASK WHERE PROC_INST_ID_='流程ID'; 
DELETE FROM ACT_RU_EXECUTION WHERE PROC_INST_ID_='流程ID';
DELETE FROM act_csci_message_hi_task WHERE PROC_INST_ID_ ='流程ID';
DELETE FROM act_csci_message_task WHERE PROC_INST_ID_ ='流程ID';    
DELETE FROM act_hi_taskinst WHERE PROC_INST_ID_ in ='流程ID'; 
DELETE FROM zzxypm_uat.act_ru_variable where PROC_INST_ID_ = 'db7886b5-6981-11ed-ac6f-5ecd25560e92';

————————————————
版权声明：本文为CSDN博主「LiMay4」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/weixin_41560845/article/details/127065300
```

设置可选下个节点的配置

```
<activiti:optionalExecutor>true</activiti:optionalExecutor> 分配下个节点处理人的节点
activiti:candidateUsers="${_OPTIONAL_EXECUTOR_usertask4}"   被分配的节点
```
