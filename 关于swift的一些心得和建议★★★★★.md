# 写在最开始
## 代码规范性
可能有很多同学在一开始写swift代码时都不知道一些相关的代码规范，常量变量如何定义等等。

这里我推荐关于代码规范的三份指导文章， 对于一些同学的```代码规范性```会有很大的提升。


#### [raywenderlich/swift-style-guide   ⭐️10k](https://github.com/raywenderlich/swift-style-guide)

#### [github/swift-style-guide  ⭐️4.5k](https://github.com/github/swift-style-guide)(有中文翻译)

#### [airbnb/swift  ⭐️1k](https://github.com/airbnb/swift)


---
### 代码格式检查工具
我们项目中用的是Realm 团队的[swiftLint](https://github.com/realm/SwiftLint) 
安装比较简单 大部分的```警告```和```Error（不影响运行）```可以给你一些```代码规范的指导```

##### 唯一缺点：会```稍微增加一些编译时间```

公司项目中不改动任何代码的二次编译时间需要```3.82s```

添加swiftLint后时间为```4.279s```，有的时候会更长一些。


##### 如果你只是对代码格式化有要求
##### 推荐使用nicklockwood大神写的[SwiftFormat](https://github.com/nicklockwood/SwiftFormat)
以XCode插件的形式添加到XCode中，一键格式化当前Swift文件。非常方便。

### Swift API 设计命名规范：

得益于Swift中 ```外部参数命名```和```_ 代表的忽略外部参数命名 ```

Swift中的API命名会更强于Objective-C

Swift 官方对Swift API 设计命名有一套[规范文档](https://swift.org/documentation/api-design-guidelines/)

这里是[中文翻译](https://www.yuque.com/kiwi/ios/swift-api-design)

最好的学习方式是模仿Swift标准库的API设计的感觉去写自己项目的方法名。

个人感悟： 好的方法名读起来应该是一句```精炼流畅的英文句子```

---
## All Tips
### ⭐️tip1: 
#### swift项目```引用OC对象```的坑
##### swift项目引用OC对象时```必须要考虑```该OC象是否可能为nil， ```swift默认引用的OC对象为必选``` 当oc对象为nil就会引起崩溃。
##### 最好在引用OC对象时手动添加一个```?```,将OC对象标记为可选。
在开发过程中有遇到几次崩溃都是没有考虑到这种情况。😿

---
### ⭐️tip2: 
#### 多使用```let```
##### let会让我们在很多时候```放心大胆```的去使用定义好的值，而不用去考虑后面再哪里改变了这个值和安全性的问题。

---
### ⭐️tip3: 
#### 通过```计算型属性```实现```模型的转换```(Objective-C 到 Swift的一个思维转换)
##### 假设App中有一个全局播放器，我们需要把后台发给我们的```不同模块音乐模型```(```ChildrenSongModel```, ```PodcastModel```)转换成```统一的音乐模型```(```GenernalMusicModel```)。

刚刚从Objective-C过渡到Swift时候的我的写法：

    /// 统一音乐模型转换类
    class MusicConvertManager {
        
        /// 将儿歌的音乐模型转换成统一音乐模型
        /// - Parameter childernSongModel: 儿歌模型
        /// - Returns: 统一的音乐模型
        static func convertChildrenSong(of childernSongModel: ChildernSongModel) -> GenernalMusicModel {
            let genernalMusic  = GenernalMusicModel()
            genernalMusic.id   = childernSongModel._id
            genernalMusic.url  = childernSongModel.musicURL
            genernalMusic.name = childernSongModel.title
            return genernalMusic
        }
        
        /// 将播客的音乐模型转换成统一音乐模型
        /// - Parameter childernSongModel: 播客音乐模型
        /// - Returns: 统一的音乐模型
        static func convertChildrenSong(of podcastModel: PodcastModel) -> GenernalMusicModel {
            let genernalMusic  = GenernalMusicModel()
            genernalMusic.id   = PodcastModel.pid
            genernalMusic.url  = childernSongModel.url
            genernalMusic.name = childernSongModel.name
            return genernalMusic
        }

    }

    /// 具体使用   不建议这样，每次写到这里都需要先想到MusicConvertManager类，再思考用哪个具体的方法。❎
    MusicManager.shared.currentModel = MusicConvertManager.convertChildrenSong(of: jsonModel.childrenModel)


建议写法： 通过给具体的模型创建```extension```， 在extension中创建generalMusicModel的```计算型属性```方便阅读和使用。

    /// 通过genernalMusicModel计算型属性转换统一的音乐模型。   PodcastModel转换同理。
    extension ChildernSongModel {
        /// 统一的音乐模型  (如果是耗时操作建议缓存转换后的结果)
        var genernalMusicModel: GenernalMusicModel {
            let genernalMusic  = GenernalMusicModel()
            genernalMusic.id   = _id
            genernalMusic.url  = musicURL
            genernalMusic.name = title
            return genernalMusic
        }
    }

    /// 具体使用 这样写便于阅读及使用方便。 ✅
    MusicManager.shared.currentModel = jsonModel.childrenModel.genernalMusicModel
    
---
### ⭐️tip4: 
#### 自定义协议如何规范命名？
##### 参考了55个系统API的协议命名规范我们可以把协议命名分三类：

##### 1. 以```able```结尾:  ``` Codable```    表示当前协议可以```添加一个新的功能```。
##### 2. 以```Type```结尾：```CollectionType``` 表示当前协议可以```表示一种类型```。
##### 3. 以```Convertable```结尾：```CustomStringConvertible``` 表示当前协议可以```做类型转换```。
以后有自定义协议的时候，命名可以参照这三种情况去规范命名。

---
### ⭐️tip5: 
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

---
### ⭐️tip6: 
#### 集合上使用的一些函数式编程的性能提升建议。
##### 上面提到了isEmpty的性能会好于count， 下面会引申一些类似的提升性能的用法。
##### 操作集合我们经常会用到```map```、```filter```、```reduce```等函数，有时候可以使用标准库的其他API使性能提升。


    // 取一个集合中第一个大于0的数
    let numberArray = [-4,1,-1,2,3,9]
    let firstPositiveNumber = numberArray.first(where: { $0 > 0 })    ✅
    
    let firstPositiveNumber = numberArray.filter { $0 > 0 }.first    ❌
    // 第一个方法遍历到符合条件的元素后即停止，  第二个方法在所有元素都遍历完一遍后再去找第一个。
    
    // 同上面还有 取出集合中的最大最小元素
    let minNumber = numberArray.min()    ✅
    let maxNumber = numberArray.max()    ✅

    let minNumber = numberArray.sorted().first    ❌
    let maxNumber = numberArray.sorted().last     ❌

#####  在Swift4.2的时候推出了```allSatisfy(_:)``` 的用法，用于判断是否所有元素满足某一条件。
##### 某些时候可以替换filter。且对于长集合性能提升很大  具体使用场景如下：

    // 判断是不是所有的元素都是大于0   isAllPositive为Bool
    let isAllPositive = numberArray.allSatisfy { $0 > 0 }    ✅✅✅
    
    let isAllPositive = numberArray { $0 > 0 }.isEmpty   ❌❌❌
    // 第一个方法在遇到第一个元素不不符合条件就遍历结束 直接返回false
    // 第二个方法需要把所有的元素都遍历一遍后再去看是否是isEmpty  长集合会性能低下。


#####  判断是否包含一个元素： ```contains```的性能要优于使用```filter(_:)``` 和 ```first(where:)```的用法

    // 判断是否包含 -1 这个元素
    
    let isContiansNagtiveOne = numberArray.contains(-1) ✅
    
    let isContiansNagtiveOne = numberArray.filter { $0 == -1 }.isEmpty == false  ❌
    let isContiansNagtiveOne = numberArray.first(where: { $0 == -1 }) != nil  ❌
    // 其原因同上。


---
### ⭐️tip7: 
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

---
### ⭐️tip8: 
#### 当你需要的返回值有```成功```或者```失败```两种情况，而且```成功或者失败的情况有很多种```的话。推荐你使用Swift5以后推出的```Result```类型。
##### 具体用法可看[之前写过的一篇文章](https://github.com/Liaoworking/Advanced-Swift/blob/master/%E7%AC%AC%E5%85%AB%E7%AB%A0%EF%BC%9A%E9%94%99%E8%AF%AF%E5%A4%84%E7%90%86/8.1%20result%E7%B1%BB%E5%9E%8B.md)
##### 它会让你的代码变的更简洁清晰。
---
### ⭐️tip9: 
#### 同样在Swift5.0中添加了bool值的新方法```toggle()```， 它的主要作用是让Bool值取反。 
##### 像我们在btn的按钮的状态改变的时候之前一般都会用 ```btn.isSelected = !btn.isSelected``` 有了toggle方法后 直接可以 ```btn.toggle()``` 达到同样的效果。 
---
### ⭐️tip10: 
#### TODO-~~用通俗的语言和使用场景向大家介绍@autoclosure 注解的使用~~  不了解的同学可以先google一下相关用法。
---
### ⭐️tip11: 
#### switch 语句中尽量少的使用```default``` 分支
##### 当我们添加新的case时候 有些没有cover到的地方没有编译报错就会产生一些逻辑错误。
##### 如果觉得编译报错太烦可以使用swift 5 出来的[@unknown](https://medium.com/%E5%BD%BC%E5%BE%97%E6%BD%98%E7%9A%84-swift-ios-app-%E9%96%8B%E7%99%BC%E5%95%8F%E9%A1%8C%E8%A7%A3%E7%AD%94%E9%9B%86/%E8%99%95%E7%90%86%E6%9C%AA%E4%BE%86-case-%E7%9A%84-unknown-default-swift-5-c064365d6c3) 关键字修饰default 分支  让新添加的case以编译警告的形式出现。
---
### ⭐️tip12: 
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
---
### ⭐️tip13: 
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
    
    
#### 多用guard let 去解包可以在很多情况下```大幅度的减小一些耗时函数的编译时间```,具体可以参考[Swift编译加速Tips](https://github.com/Liaoworking/Advanced-Swift/blob/master/swift%E6%96%B0%E7%89%B9%E6%80%A7/Swift%E7%BC%96%E8%AF%91%E5%8A%A0%E9%80%9F%E7%9A%84Tips.md)这篇文章。
---
### ⭐️tip14: 
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

---
### ⭐️tip15: 
#### 自定义enum中尽量不要使用 case none的枚举项。
#### 原因Swift 自带 ```Optional``` 也有一个 case none的枚举。易混淆。

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

### ⭐️tip16: 
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
---
### ⭐️tip17: 
#### 不要为所欲为的使用计算型属性。
有时候为了图方便就会使用计算型属性，保证每次都会拿到最新的数据。但如果是一些```耗时操作```建议添加缓存，或者使用普通的存储型属性。 缓存存在就直接返回缓存值，不存在的时候再去调用计算方法。 
我在SwiftUI中没有过多考虑性能问题，大部分使用的计算型属性，导致有些地方性能消耗过多。。。 分享出来以示警醒。。

---
### ⭐️tip18: 
#### 方便的push或者present控制器(本来打算写优雅的push或者present，感觉优雅这个词已经被玩烂了，就换成了方便的。。🐶)。
日常写法是let vc = UIViewController()

navigationController?.pushViewController(vc)

或者 present(vc, animated: true, completion: nil)

可以给UIViewController添加extension方法， 对 push 和 present 的封装

    extension UIViewController {
      func bePushed(by currentVC: UIViewController?) {
        currentVC?.navigationController?.pushViewController(self, animated: true)
      }

      func bePresented(by currentVC: UIViewController?) {
        currentVC?.present(self, animated: true, completion: nil)
      }
    }

    // 在ViewController中使用如下：  个人感觉这样去弹出一个控制器语义上会更连贯便捷。
    UIViewController().bePushed(by: self)
    UIViewController().bePresented(by: self)

### ⭐️tip19: 
#### 对通知名的封装。
个人一开始在OC转Swift的时候会对如何更好的在Swift中写通知名感到有些疑惑。
苹果在```Swift4.0```中```Swift官方库```对通知名的使用做过一次修改。 改成了类的静态属性的形式，如下：

如监听UItextView的内容改变：

        NotificationCenter.default.addObserver(self, selector: #selector(textViewNotifitionAction), name: UITextView.textDidChangeNotification, object: nil)

我们再日常开发中就会在对于监听的类的extension中去定义通知名 

    extension MyClass {
        public class let MyNotification: NSNotification.Name = ....
    }

如果想```全局管理```你的通知，而且```更方便```的使用通知名可以使用下面这种方式：

    /// 创建一个通知名协议
    public protocol NotificationName {
        var name: Notification.Name { get }
    }
    
    extension RawRepresentable where RawValue == String, Self: NotificationName {
        public var name: Notification.Name {
            get {
                return Notification.Name(self.rawValue)
            }
        }
    }

    //最后用一个枚举去管理你所有的通知名
    /// 所有通知名
    public enum Notifications: String, NotificationName {
        /// 自定义某某通知
        case myNotification
    }
    
    // 使用
    NotificationCenter.default.addObserver(self, selector: #selector(fromMyNotification(notification:)), name: Notifications.myNotification.name, object: nil)

优点：1.规避了通知名同名的可能性。
     2.书写起来更方便。
     3.方便查找管理。

### ⭐️tip20: 
#### 使用where关键字让你的for循环变的更简洁

假设你需要对一个字符串数组strArray进行一些处理，但是当元素为a的时候直接忽略。
你可能会写成：

    let strArray = ["a","a","b","c","d"]
    
    for str in strArray {
        if str == "a" { continue }
        // do something here
    }

或者你也可以使用```where```关键字进行限定:

    for str in strArray where str != "a" {
     // do something here
    }

这样你的代码也会看起来更整洁一些，不过你如果用filter函数的话另讲。

### ⭐️tip21: 
#### 适当使用别名```typealias```让你的代码可读性更高

假设我们有一个处理图书的运用，一本书包括不同的章节，不同的章节又包括不同的页面，可以像下面这样表示。

    struct Page { }
    // 章节
    var myChapter: [Page] = []
    // 一本书
    var  myBook: [[Page]] = []

但如果我们用别名去定义章节类型和书类型
    
    // 章节
    typealias Chapter = [Page]
    // 书
    typealias Book = [Chapter]
    
    var myChapter: Chapter = []
    var myBook: Book = []

这样的好处可以让代码可读性更强,以后在项目中看到Chapter 和 Book 就知道表示的是章节和书了。


### ⭐️tip22: 
#### 使用自定义运算符让你的连续异步顺序执行的回调更优雅

现在有一个需求：
在一个引导之后去顺序执行其他的引导，
或者一个网络请求完去顺序执行另外的网络请求。 

我们可能会写出这个样子的代码：

    func asyncTask1(success: @escaping ()->Void) {
        // After a while
        success()
    }

    func asyncTask2(success: @escaping ()->Void) {
        // After a while
        success()
    }

    func asyncTask3(success: @escaping ()->Void) {
        // After a while
        success()
    }

    // 方法调用 多重闭包嵌套 阅读成本太大  不建议 ❌
    func start() {
        asyncTask1 {
            asyncTask2 {
                asyncTask3 {
                    // finished, do something here
                }
            }
        }
    }


在Swift中我们可以自定义运算符， 可以通过自定义操作符写出下面这样的代码

    // >--> 为我们自定义的运算符  >-->左边的方法执行完再去执行右边的方法 
    // 所有的方法都执行完后会调用 finish   方便阅读 ✅
    asyncTask1 >--> asyncTask2 >--> asyncTask3 {
    // finished,do something here
    }

运算符的具体定义如下

    typealias MyVoidClosure = ()->Void

    /// 定义优先级组
    precedencegroup MyAsyncPrecedencegroup {
        associativity: left // 从左往右执行
        assignment: false // 不可以赋值
    }

    infix operator >-->: MyAsyncPrecedencegroup  // 遵守 MyAsyncPrecedencegroup 优先级组
    
    /// 这里的逃逸闭包写的有点丑 本来想用alias来简化  发现语法不支持。
    func >-->(lhs:@escaping ((@escaping MyVoidClosure) -> Void),
              rhs: @escaping ((@escaping MyVoidClosure) -> Void))
              -> (@escaping MyVoidClosure) -> Void {

      return { complete in
        lhs {
          rhs {
              complete()
          }
        }
      }
      
    }

这样我们就可以通过自定义运算符来通俗易懂的表示出异步顺序执行事件了。

具体运算符的定义和使用：[Swift文档_自定义运算符](https://swiftgg.gitbook.io/swift/swift-jiao-cheng/27_advanced_operators#custom-operators)


### ⭐️tip23: 
#### 利用```compactMap```优雅解包。

为了明确区分flatMap函数的使用场景，在Swift4.1时候推出compactMap函数来加以区分。 
一般使用是用来过滤集合中的nil。

    var array: [String?]?

我们想要安全的取出array里面的第一个元素

平时的使用：

    // 这个时候array1元素的类型是 [String?], 如果需要安全的使用array1 需要二次对array1解包   ❌
    guard let array1 = array, let firstObject1 = array1.first, let realFirstObject = firstObject1 else { return }

使用 ```compactMap```

    // 使用compactMap后 array的类型是[String]   ✅
    guard let array2 = array?.compactMap({$0}), let firstObject2 = array2.first else { return }


### ⭐️tip24: 
#### 关于属性包装```propertyWrapper```对UserDefaults的封装的调用时机问题。

关于属性包装最有用的实际使用就是对UserDefaults的封装, 具体可以看[这篇文章的讲解](https://www.jianshu.com/p/ff4c048f0cf4)

    /// 当前用户的名称为 "liaoWorking"
    var name:String = "liaoWorking"
    
    /// 对UserDefaults的封装类
    struct UserDefaultsConfig {
      @UserDefault("had_shown_guide_view\(name)", defaultValue: false)
      static var hadShownGuideView: Bool
    }

假设当前用户引导显示完毕，将hadShownGuideView 置为true
    
    UserDefaultsConfig.hadShownGuideView = true
    
假设用户```liaoWorking```在```没杀死app```的情况下切换到用户```zhangMing```

这个时候再去读 UserDefaultsConfig.hadShownGuideView 的值 是true 还是 false ？🤔


实际这个时候 UserDefaultsConfig.hadShownGuideView 的key 还是 "had_shown_guide_view```liaoWorking```"

因为是static， UserDefaultsConfig.hadShownGuideView的key在第一次调用的时候就确定了。

你可以将hadShownGuideView改为成员变量，保证每一次获取UserDefaults的时候key都为包含当前用户名的key。

    struct UserDefaultsConfig {
      /// 去掉Static 改为成员变量
      @UserDefault("had_shown_guide_view\(name)", defaultValue: false)
      var hadShownGuideView: Bool
    }
    ///  保证每次调用的时候UserDefaults的key都是当前的用户的name
    UserDefaultsConfig().hadShownGuideView = true

### ⭐️tip25: 
#### Swift api 命名

假设我们有一个处理图书的运用，一本书包括不同的章节，不同的章节又包括不同的页面，可以像下面这样表示。

    struct Page { }
    // 章节
    var myChapter: [Page] = []
    // 一本书
    var  myBook: [[Page]] = []

但如果我们用别名去定义章节类型和书类型
    
    // 章节
    typealias Chapter = [Page]
    // 书
    typealias Book = [Chapter]
    
    var myChapter: Chapter = []
    var myBook: Book = []

这样的好处可以让代码可读性更强,以后在项目中看到Chapter 和 Book 就知道表示的是章节和书了。

to be continued⏱.


