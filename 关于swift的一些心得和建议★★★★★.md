# 写在最开始
## 代码规范性
可能有很多同学在一开始写swift代码时都不知道一些相关的代码规范，常量变量如何定义等等。

这里我推荐关于代码规范的两个指导文章， 对于一些同学的```代码规范性```会有很大的提升。


#### [raywenderlich/swift-style-guide   ⭐️10k](https://github.com/raywenderlich/swift-style-guide)

#### [github/swift-style-guide  ⭐️4.5k](https://github.com/github/swift-style-guide)(有中文翻译)



## All Tips
#### tip1: swift项目```引用OC对象```的坑
#####时必须要考虑该OC象是否可能为nil， ```swift默认引用的OC对象为必选``` 当oc对象为nil就会引起崩溃。
##### 最好在引用OC对象时手动添加一个```?```,将OC对象标记为可选。
在开发过程中有遇到几次崩溃都是没有考虑到这种情况。😿



to be continued⏱.


