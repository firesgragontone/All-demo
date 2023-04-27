

# 主要type
feat:     增加新功能

feat(c,s,f,v):通用接口

fix:      修复bug

# 特殊type
docs:     只改动了文档相关的内容
style:    不影响代码含义的改动，例如去掉空格、改变缩进、增删分号
build:    构造工具的或者外部依赖的改动，例如webpack，npm
refactor: 代码重构时使用
revert:   执行git revert打印的message

# Git冲突：Your local changes would be overwritten by merge. Commit, stash or revert them to proceed.

第 二 种方案：stash，就是暂时隐藏本地的代码，将git仓库的代码直接pull下来，具体操作：

```python
git stash     # 第一步
git pull       # 第二步
git stash pop   # 第三步
```



vscode拉去前端工程

```
git clone url
用vscode打开
```





