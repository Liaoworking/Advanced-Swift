网上关于Swift编译加速的文章挺多，这里就不赘述。
这里推荐全方位无死角讲编译优化的文档[[Optimizing-Swift-Build-Times](https://github.com/fastred/Optimizing-Swift-Build-Times)
](https://github.com/fastred/Optimizing-Swift-Build-Times)

还有优化的神器[BuildTimeAnalyzer-for-Xcode](https://github.com/RobertGummesson/BuildTimeAnalyzer-for-Xcode)

下面就针对于具体代码层面的编译优化谈一些心得和感悟。

## 如何找出项目中编译耗时的代码？

在XCode 10的时候Swift就支持了[监控的编译超时的警告](https://github.com/apple/swift/commit/18c75928639acf0ccf0e1fb6729eea75bc09cbd5)。
它能帮助我们找到项目中需要编译优化的函数，并量化具体的优化时间。

在```Build Settings ➔ Swift Compiler - Custom Flags ➔ Other Swift Flags``` 中添加.

    ///<limit>为warning的编译时间阈值
    -Xfrontend -warn-long-function-bodies=<limit>

    -Xfrontend -warn-long-expression-type-checking=<limit>

![添加编译警告](https://upload-images.jianshu.io/upload_images/1724449-d8ce839f34848a13.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

测试机型： A12z  Apple DTK(所以编译时间会看起来短很多)

## Let's Start

### tip1: 使用 + 拼接可选字符串会极其耗时。
### 建议：改写成 "\\(string1)\\(string2)"的形式

![红框中为编译耗时代码](https://upload-images.jianshu.io/upload_images/1724449-7b68c6c34a3dfa5b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

耗时代码：编译耗时372ms

    let finalResult = (dbWordModel?.vocabularyModel?.justSentenceExplain ?? "") + "<br/>" + (dbWordModel?.vocabularyModel?.justSentence ?? "")



优化后： 编译时间20ms    ```18.5倍```的编译性能提升🤯。
               
     let finalResult = "\(dbWordModel?.vocabularyModel?.justSentenceExplain ?? "")<br/>\(dbWordModel?.vocabularyModel?.justSentence ?? "")"


### Tip2:  可选值使用```??```赋默认值再嵌套其他运算会极其耗时。
##### 优化方法： 使用guard let 解包。
还是上面的例子
优化后： 编译耗时 63ms  5.9倍的编译性能提升。

     guard let dbSentenceExp = dbWordModel?.vocabularyModel?.justSentenceExplain,
     let dbSentence = dbWordModel?.vocabularyModel?.justSentence else { return }
     let finalResult = "\(dbSentenceExp)<br/>\(dbSentence)"


### Tip3: 将长计算式代码拆分 最后组合计算。

![image.png](https://upload-images.jianshu.io/upload_images/1724449-f4eb78a6e9984d72.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

耗时代码：编译时长736ms

        let totalTime = (timeArray.first?.float()?.int ?? 0) * 60 + (timeArray.last?.float()?.int ?? 0)


优化拆分后： 耗时22ms   ```33.4倍```编译性能提升🤯

        let firstPart: Int = (timeArray.first?.float()?.int ?? 0)
        let lastPart: Int = (timeArray.last?.float()?.int ?? 0)
        let totalTime = firstPart * 60 + lastPart


### Tip4: 与或非和>=,<=,==逻辑运算嵌套Optional会比较耗时。
建议： 使用guard let + 拆分 进行优化。

![image](https://upload-images.jianshu.io/upload_images/1724449-c330901e132bcea1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

耗时代码： 10420ms 编译器已经无法编译并报错。

    if (homeMainVC?.scrollview.contentOffset.y ?? 0) >= ((homeMainVC?.headHeight ?? 0) - (homeMainVC?.ignoreTopSpeace ?? 0)) {

    }

优化后： 21ms    ```496倍```编译性能提升🤯

    let leftValue: CGFloat =  homeMainVC?.scrollview.contentOffset.y ?? 0
    let rightValue: CGFloat = (homeMainVC?.headHeight ?? 0.0) - (homeMainVC?.ignoreTopSpeace ?? 0.0)
    if leftValue == rightValue {
    }

### Tip5: 手动增加类型推断会降低编译时间。

在Tip4的基础上我们二次优化：
![image](https://upload-images.jianshu.io/upload_images/1724449-2a6c6fd1e4fe2c7a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

优化前：21ms

    let leftValue =  homeMainVC?.scrollview.contentOffset.y ?? 0
    let rightValue = (homeMainVC?.headHeight ?? 0.0) - (homeMainVC?.ignoreTopSpeace ?? 0.0)

优化后：增加了类型推断  16ms


    let leftValue: CGFloat =  homeMainVC?.scrollview.contentOffset.y ?? 0
    let rightValue: CGFloat = (homeMainVC?.headHeight ?? 0.0) - (homeMainVC?.ignoreTopSpeace ?? 0.0)


### 结论：
项目中的一百多个编译优化之后性能在MacBook pro 15寸 16款 i7 上面编译速度提升了34s   262s提升到了228s, 在公司性能较差的打包机上提升可能会更快。

### 感悟：
有的时候在```编译性能```和```代码的可阅读性```之间需要有一个权衡取舍。
一昧的追求编译性能而舍弃代码的可阅读性不可取。
电脑性能比较差的情况下浪费大部分时间在编译上也不可取。
M1芯片的电脑另说。


附录：
[Measuring Swift compile times in Xcode 9](https://www.jessesquires.com/blog/2017/09/18/measuring-compile-times-xcode9/)
