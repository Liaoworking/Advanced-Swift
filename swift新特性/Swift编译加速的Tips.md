网上关于Swift编译加速的文章挺多，这里就不赘述。
下面就讲讲最近在项目中关于编译优化的一些心得和感悟。

## 编译慢的原因：
Swift是一门静态语言。
不同于Objective-C, swift在编译阶段帮我们做了很多事情。
这也正是Swift语言 Modern，Safe的原因之一。
也使得我们可以写出很多优美的代码。

## 如何找出项目中编译耗时的代码？

在XCode 9的时候Swift就支持了[函数体及类型判断时间监控的编译警告](https://github.com/apple/swift/commit/18c75928639acf0ccf0e1fb6729eea75bc09cbd5)。
它能帮助我们找到项目中需要编译优化的函数，并量化具体的优化时间。

在```Build Settings ➔ Swift Compiler - Custom Flags ➔ Other Swift Flags``` 中添加.

    ///<limit>为warning的编译时间阈值
    -Xfrontend -warn-long-function-bodies=<limit>

    -Xfrontend -warn-long-expression-type-checking=<limit>

![添加编译警告](https://upload-images.jianshu.io/upload_images/1724449-d8ce839f34848a13.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

测试机型： 15寸 macBook pro 2016 2.7GHz-i7 16g

##下面就开始

### tip1: 使用 + 拼接字符串会及其耗时。
建议：改写成 "\(string1)\(string2)"的形式
下面这个函数需要606ms来编译含有 字符串拼接的闭包。

![image.png](https://upload-images.jianshu.io/upload_images/1724449-c0c3061afef926a4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

改写后 编译时间小于50ms
![image.png](https://upload-images.jianshu.io/upload_images/1724449-55e4cd2694245d3a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### Tip2:  多用guard let 提前将异常情况return。
使用了可选值?? 
优化后：

### Tip3: 将长计算式拆分成多个计算式 最后组合计算。

### Tip4: 计算式中的可选计算提前解包

###  Tip5: 三目运算符会增加编译耗时。 (三目运算符和可选值的运算组合在一起编译时间猛增加, 运算中嵌套三目同理)💥

### Tip6:  String(desc) isbetter than String().

### Tip7: 与或非逻辑运算进行拆分。不要在与或非中嵌套可选值运算

### Tip8: 长方法拆分成多行和仅一行差别不大，具体看个人习惯。


p.s.
[Measuring Swift compile times in Xcode 9](https://www.jessesquires.com/blog/2017/09/18/measuring-compile-times-xcode9/)