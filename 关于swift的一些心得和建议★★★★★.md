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
#### ⭐️tip1: swift项目```引用OC对象```的坑
##### swift项目引用OC对象时```必须要考虑```该OC象是否可能为nil， ```swift默认引用的OC对象为必选``` 当oc对象为nil就会引起崩溃。
##### 最好在引用OC对象时手动添加一个```?```,将OC对象标记为可选。
在开发过程中有遇到几次崩溃都是没有考虑到这种情况。😿

#### ⭐️tip2: 多使用```let```
##### let会让我们在很多时候```放心大胆```的去使用定义好的值，而不用去考虑后面再哪里改变了这个值和安全性的问题。

#### ⭐️tip3: array.isEmpty 效率比 arrya.count 更高
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

#### ⭐️tip4: 将你```时常需要的常量```封装成你需要的属性
##### OC中的宏是我们在之前开发中经常用到的一些常用属性的封装。
##### 在swift中我们可以通过在```extension```中创建一些类属性，让你的常量更优雅

    extension UIFont {
        /// APP中大标题的字体
        static let appLargeTitle = UIFont.systemFont(ofSize: 24)
    }
    
    extension UIColor {
        /// APP主题色
        static let appMainColor = UIColor.yellow
    }
    
    let titleLabel = UILabel()
    titleLabel.font = .appLargeTitle
    titleLabel.backgroundColor = .appMainColor


#### ⭐️tip5: 当你需要的返回值有```成功```或者```失败```两种情况，而且```成功或者失败的情况有很多种```的话。推荐你使用Swift5以后推出的```Result```类型。
##### 具体用法可看[之前写过的一篇文章](https://github.com/Liaoworking/Advanced-Swift/blob/master/%E7%AC%AC%E5%85%AB%E7%AB%A0%EF%BC%9A%E9%94%99%E8%AF%AF%E5%A4%84%E7%90%86/8.1%20result%E7%B1%BB%E5%9E%8B.md)
##### 它会让你的代码变的更简洁清晰。

#### ⭐️tip6: 同样在Swift5.0中添加了bool值的新方法```toggle()```， 它的主要作用是让Bool值取反。 
##### 像我们在btn的按钮的状态改变的时候之前一般都会用 ```btn.isSelected = !btn.isSelected``` 有了toggle方法后 直接可以 ```btn.toggle()``` 达到同样的效果。 

#### ⭐️tip7: TODO-用通俗的语言和使用场景向大家介绍@autoclosure 注解的使用

#### ⭐️tip8: switch 语句中尽量少的使用```default``` 分支
##### 当我们添加新的case时候 有些没有cover到的地方没有编译报错就会产生一些逻辑错误。
##### 如果觉得编译报错太烦可以使用swift 5 出来的[@unknown](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E8%99%95%E7%90%86%E6%9C%AA%E4%BE%86-case-%E7%9A%84-unknown-default-swift-5-c064365d6c3) 关键字修饰default 分支  让新添加的case以编译警告的形式出现。
to be continued⏱.


