# 写在最开始
## 代码规范性
可能有很多同学在一开始写swift代码时都不知道一些相关的代码规范，常量变量如何定义等等。

这里我推荐关于代码规范的两个指导文章， 对于一些同学的```代码规范性```会有很大的提升。


#### [raywenderlich/swift-style-guide   ⭐️10k](https://github.com/raywenderlich/swift-style-guide)

#### [github/swift-style-guide  ⭐️4.5k](https://github.com/github/swift-style-guide)(有中文翻译)


### 代码格式检查工具
我们项目中用的是Realm 团队的[swiftLint](https://github.com/realm/SwiftLint) 
安装比较简单 大部分的```警告```和```Error（不影响运行）```可以给你一些```代码规范的指导```

##### 唯一缺点：会```稍微增加一些编译时间```

公司项目中不改动任何代码的二次编译时间需要```3.82s```

添加swiftLint后时间为```4.279s```，有的时候会更长一些。



## All Tips
#### tip1: swift项目```引用OC对象```的坑
##### swift项目引用OC对象时```必须要考虑```该OC象是否可能为nil， ```swift默认引用的OC对象为必选``` 当oc对象为nil就会引起崩溃。
##### 最好在引用OC对象时手动添加一个```?```,将OC对象标记为可选。
在开发过程中有遇到几次崩溃都是没有考虑到这种情况。😿

#### tip2: 多使用```let```
##### let会让我们在很多时候```放心大胆```的去使用定义好的值，而不用去考虑后面再哪里改变了这个值和安全性的问题。

#### tip3: array.isEmpty 效率比 arrya.count 更高
##### 当我们去判断一个```数组是否为空```的时候 大多都会写if array.count > 0 {} 
##### isEmpty 方法只有检查array```startIndex == endIndex``就可以。而count的底层是```遍历整个array```求集合长度。当数组长度过大时```性能低```一些。

##### 不仅isEmpty效率高，而且会```更安全```
有时候我们判断一个array? 是否为空会写出下面这样代码

    var array:[String]?
    /// 一番array 操作后
    if array?.count != 0 {
        ///当数组长度不为0时
        doSomething()
    } 
    
##### 其实当array为```nil```时 也会走doSomething() 的逻辑   这个时候可能就会出现逻辑上的bug.
##### 用 isEmpty 就不会忽略这样的问题。



to be continued⏱.


