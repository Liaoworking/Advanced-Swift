
### 什么是@propertyWrapper?

##### 从字面意思去理解 property Wrapper 就是```属性包裹器```(我初二英语水平硬翻，写的时候国内好像还没有一个统一的叫法。有知道学名的同学提醒下谢啦~)。
##### 它的```作用对象```是```属性```
##### 其```主旨```就是：通过```property Wrapper```机制，对一些类似的```属性```的实现代码做同一封装。
##### 说简单点： 通过@propertyWrapper可以移除掉一些重复或者类似的代码。 

![@propertyWrapper 的使用步骤 ](https://upload-images.jianshu.io/upload_images/1724449-29d018764bf6c310.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

propertyWrapper这个知识点不难,比较新而已。只要自己复制下面的Demo在```playGround```里跑一遍看一下就会了。 


## 下面用UserDefaults保存是否显示新手引导的例子来让大家有一个直观的了解

#### 没有@propertyWrapper 的时候。。😔

extension UserDefaults {

public enum Keys {
static let hadShownGuideView = "had_shown_guide_view"
}

var hadShownGuideView: Bool {
set {
set(newValue, forKey: Keys.hadShownGuideView)
}
get {
return bool(forKey: Keys.hadShownGuideView)
}
}
}

/// 下面的就是业务代码了。
let hadShownGuide =  UserDefaults.standard.hadShownGuideView 
if !hadShownGuide {
/// 显示新手引导 并保存本地为已显示
showGuideView() /// showGuideView具体实现略。
UserDefaults.standard.hadShownGuideView = true
}


可是项目中有很多地方需要UserDefaults保存本地数据,数据量多了这样的```重复代码```就很多了。


#### 有@propertyWrapper 的时候。。😁

@propertyWrapper /// 先告诉编译器 下面这个UserDefault是一个属性包裹器
struct UserDefault<T> {
///这里的属性key 和 defaultValue 还有init方法都是实际业务中的业务代码   
///我们不需要过多关注
let key: String
let defaultValue: T

init(_ key: String, defaultValue: T) {
self.key = key
self.defaultValue = defaultValue
}
///  wrappedValue是@propertyWrapper必须要实现的属性
/// 当操作我们要包裹的属性时  其具体set get方法实际上走的都是wrappedValue 的set get 方法。 
var wrappedValue: T {
get {
return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
}
set {
UserDefaults.standard.set(newValue, forKey: key)
}
}
}

///封装一个UserDefault配置文件
struct UserDefaultsConfig {
///告诉编译器 我要包裹的是hadShownGuideView这个值。
///实际写法就是在UserDefault包裹器的初始化方法前加了个@
/// hadShownGuideView 属性的一些key和默认值已经在 UserDefault包裹器的构造方法中实现
@UserDefault("had_shown_guide_view", defaultValue: false)
static var hadShownGuideView: Bool
}

///具体的业务代码。
UserDefaultsConfig.hadShownGuideView = false
print(UserDefaultsConfig.hadShownGuideView) // false
UserDefaultsConfig.hadShownGuideView = true
print(UserDefaultsConfig.hadShownGuideView) // true

我把@propertyWrapper 的具体用法和知识点已经写到了demo中。    ```PlayGround```中跑一跑就很稳了。

当添加新的key去保存数据的时候只用在UserDefaultsConfig 中添加新的属性和包裹器就行

struct UserDefaultsConfig {
@UserDefault("had_shown_guide_view", defaultValue: false)
static var hadShownGuideView: Bool
///保存用户名称
@UserDefault("username", defaultValue: "unknown")
static var username: String
}




Over.


##### 参考资料：
[最早关于Property Wrapper 的提案:swift-evolution 0258 ](https://github.com/DougGregor/swift-evolution/blob/property-wrappers/proposals/0258-property-wrappers.md) (特别长一段英文，略略略)
[Property wrappers to remove boilerplate code in Swift](https://www.avanderlee.com/swift/property-wrappers/)
[nshipster-propertywrapper](https://nshipster.com/propertywrapper/)
