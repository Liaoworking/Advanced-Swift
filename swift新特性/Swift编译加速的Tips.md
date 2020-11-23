网上关于Swift编译加速的文章挺多，这里就不赘述。
这里推荐全方位无死角讲解编译优化的文档[[Optimizing-Swift-Build-Times](https://github.com/fastred/Optimizing-Swift-Build-Times)
](https://github.com/fastred/Optimizing-Swift-Build-Times)
下面就针对于具体代码层面的编译优化谈一些心得和感悟。

## 编译慢的原因：
Swift是一门静态语言。
不同于Objective-C, swift在编译阶段帮我们做了很多事情。
这也正是Swift语言 Modern，Safe的原因之一。
使得我们可以写出很多优美高级的代码。

## 如何找出项目中编译耗时的代码？

在XCode 10的时候Swift就支持了[函数体及类型判断时间监控的编译警告](https://github.com/apple/swift/commit/18c75928639acf0ccf0e1fb6729eea75bc09cbd5)。
它能帮助我们找到项目中需要编译优化的函数，并量化具体的优化时间。

在```Build Settings ➔ Swift Compiler - Custom Flags ➔ Other Swift Flags``` 中添加.

    ///<limit>为warning的编译时间阈值
    -Xfrontend -warn-long-function-bodies=<limit>

    -Xfrontend -warn-long-expression-type-checking=<limit>

![添加编译警告](https://upload-images.jianshu.io/upload_images/1724449-d8ce839f34848a13.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

测试机型： A12z  Apple DTK(性能好于大部分主机 所以编译时间会看起来短很多)

## 下面就开始

### tip1: 使用 + 拼接字符串会及其耗时。
### 建议：改写成 "\\(string1)\\(string2)"的形式
下面这个函数需要372ms来编译含有 字符串拼接的闭包。

![红框中为编译耗时代码](https://upload-images.jianshu.io/upload_images/1724449-7b68c6c34a3dfa5b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

改写后： 编译时间20ms    ```18.5倍```的编译性能提升🤯。
![红框中为改写后的代码](https://upload-images.jianshu.io/upload_images/1724449-933bdfb152d43fc2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### Tip2:  可选值 ?? 赋默认值再嵌套其他运算会及其耗时。
优化后： 使用guard let 解包把异常情况抛出。

还是刚刚的例子，我们将编译耗时代码中的可选值提前用guard let return 掉。
编译耗时降低到了63ms  ```5.9倍```的编译性能提升。
![红框中为改写后的代码](https://upload-images.jianshu.io/upload_images/1724449-067f44a8ab234ef6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### Tip3: 将长计算式拆分成多个计算式 最后组合计算。

###  Tip5: 三目运算符会增加编译耗时。 (三目运算符和可选值的运算组合在一起编译时间猛增加, 运算中嵌套三目同理)💥

### Tip6:  String(desc) isbetter than String().

### Tip7: 与或非逻辑运算进行拆分。不要在与或非中嵌套可选值运算

### Tip8: 长方法拆分成多行和仅一行差别不大，具体看个人习惯。


p.s.
[Measuring Swift compile times in Xcode 9](https://www.jessesquires.com/blog/2017/09/18/measuring-compile-times-xcode9/)
