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
### ⭐️tip1: 
#### swift项目```引用OC对象```的坑
##### swift项目引用OC对象时```必须要考虑```该OC象是否可能为nil， ```swift默认引用的OC对象为必选``` 当oc对象为nil就会引起崩溃。
##### 最好在引用OC对象时手动添加一个```?```,将OC对象标记为可选。
在开发过程中有遇到几次崩溃都是没有考虑到这种情况。😿

### ⭐️tip2: 
#### 多使用```let```
##### let会让我们在很多时候```放心大胆```的去使用定义好的值，而不用去考虑后面再哪里改变了这个值和安全性的问题。

### ⭐️tip3: 
#### array.isEmpty 效率比 arrya.count 更高
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

### ⭐️tip4: 
#### 将你```时常需要的常量```封装成你需要的属性
##### OC中的宏是我们在之前开发中经常用到的一些常用属性的封装。
##### 在swift中我们可以通过在```extension```中创建一些类属性，让你的常量更优雅
##### SwiftUI标准库中大部分常量都是以这种方式封装。

    extension UIFont {
        /// APP中大标题的字体
        static let appLargeTitle = UIFont.systemFont(ofSize: 24)
    }
    
    extension UIColor {
        /// APP主题色
        static let appMain = UIColor.yellow
    }
    
    let titleLabel = UILabel()
    titleLabel.font = .appLargeTitle
    titleLabel.backgroundColor = .appMain


### ⭐️tip5: 
#### 当你需要的返回值有```成功```或者```失败```两种情况，而且```成功或者失败的情况有很多种```的话。推荐你使用Swift5以后推出的```Result```类型。
##### 具体用法可看[之前写过的一篇文章](https://github.com/Liaoworking/Advanced-Swift/blob/master/%E7%AC%AC%E5%85%AB%E7%AB%A0%EF%BC%9A%E9%94%99%E8%AF%AF%E5%A4%84%E7%90%86/8.1%20result%E7%B1%BB%E5%9E%8B.md)
##### 它会让你的代码变的更简洁清晰。

### ⭐️tip6: 
#### 同样在Swift5.0中添加了bool值的新方法```toggle()```， 它的主要作用是让Bool值取反。 
##### 像我们在btn的按钮的状态改变的时候之前一般都会用 ```btn.isSelected = !btn.isSelected``` 有了toggle方法后 直接可以 ```btn.toggle()``` 达到同样的效果。 

### ⭐️tip7: 
#### TODO-~~用通俗的语言和使用场景向大家介绍@autoclosure 注解的使用~~  不了解的同学可以先google一下相关用法。

### ⭐️tip8: 
#### switch 语句中尽量少的使用```default``` 分支
##### 当我们添加新的case时候 有些没有cover到的地方没有编译报错就会产生一些逻辑错误。
##### 如果觉得编译报错太烦可以使用swift 5 出来的[@unknown](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E8%99%95%E7%90%86%E6%9C%AA%E4%BE%86-case-%E7%9A%84-unknown-default-swift-5-c064365d6c3) 关键字修饰default 分支  让新添加的case以编译警告的形式出现。

### ⭐️tip9: 
#### 打印 枚举的case名，输出并不是枚举的value值而是case的字面名字。
    
    enum Animal: String {
        case human = "H"
        case dog = "D"
        case cat = "C"
    }
    enum TimeUtile: Int {
        case second = 1
        case minute = 60
        case hour = 3600
    }
    
    var animal: Animal = .human
    var time: TimeUtile = .second
    print(animal) // human
    print(animal.rawValue) // H
    print(time) // second
    print(time.rawValue) // 1

### ⭐️tip10: 
#### 多用 ```guard let```   少用 ```if let``` 
    
    // 使用 if let 嵌套太多 不利于维护 ❌
    if let realOptionalA = optionalA {
        print("had A")
        if let realOptionalB = optionalB {
            print("had A and B")
            if let realOptionalC = optionalC {
                print("had A、B and C")
            }
        }
    }
    
    // 使用 guard let 调理清楚 便于阅读 ✅
    guard let realOptionalA = optionalA else { return }
    print("had A")
    guard let realOptionalB = optionalB else { return }
    print("had A and B")
    guard let realOptionalC = optionalC else { return }
    print("had A、B and C")

### ⭐️tip10: 
#### 快速为Class生成带有属性的初始化方法

在struct中， 编译器会自动生成带有属性的初始化方法。

    struct User {
        let name: String?
        var age: Int?
    }
    // 可直接调用
    User(name: String?, age: Int?)

但对于class就没有对于的初始化方法。我们可以使用XCode提供的辅助功能来生成对应的初始化方法。

    class Book {
        let name: String?
        let pageCount: Int?
    }

![image](https://github.com/Liaoworking/Advanced-Swift/raw/master/pic/tips_11.png)

    //使用后：
    class Book {
        // 编译器自动补全的方法
        internal init(name: String?, pageCount: Int?) {
            self.name = name
            self.pageCount = pageCount
        }
        
        let name: String?
        let pageCount: Int?
    }


### ⭐️tip11: 
#### 自定义enum中尽量不要使用 case none的枚举项。

    enum MyEnum {
        case ok
        case error
        case none   ❌
    }
    
    // 这个时候myEnum实际上是一个Optional的枚举值 而Optional 也有一个 none的枚举选项。 
    var myEnum : MyEnum? = .none

    //可以通过指定类型解决 但不建议这样
    var myEnum : MyEnum? = Optional.none
    var myEnum : MyEnum? = MyEnum.none


这个时候编译器会报警告 而且你的switch中会多一个case .some(.none):的选项。

### ⭐️tip12: 
#### 用枚举去定义一些静态的tableView数据源会让代码变的更简洁。
假设某电商app首页的tableView有4个section
   
    // 电商首页的tableView 分组
    //CaseIterable 用来获取枚举项个数
    enum HomeSectionType: Int, CaseIterable {
        // banner位
        case banner = 1
        // 合辑
        case menu = 2
        // 推荐
        case recommend = 3
        // 商品
        case goods = 4
        
        // 枚举内部封装组头高度的计算方法
        var headerHeight: CGFloat {
        switch self :
        case banner:
            return 88.88
            .....
        }
        
    }
  
    // tableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeSectionType.allCases.count
     }
    // 获取组头高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {  
        guard let sectionType = HomeSectionType(rawValue: section) else { return 0.0 }
        return sectionType.headerHeight
    }
    
    

这样就可以让tableView的代理看起来简洁明了。
    
```CaseIterable```协议可以让你的枚举具备Array相关的属性，如```count```
还有一个好处就是当产品某个版本想要```调换section的顺序```的时候  可以直接 修改```枚举项的Int值```即可。

Swift中的枚举还有很多很强大的用法，小伙伴们可以在开发过程中自己多尝试一下下~

### ⭐️tip13: 
#### 不要为所欲为的使用计算型属性。
有时候为了图方便就会使用计算型属性，保证每次都会拿到最新的数据。但如果是一些```耗时操作```建议添加缓存，或者使用普通的存储型属性。 缓存存在就直接返回缓存值，不存在的时候再去调用计算方法。 
我在SwiftUI中没有过多考虑性能问题，大部分使用的计算型属性，导致有些地方性能消耗过多。。。 分享出来以示警醒。。

to be continued⏱.


