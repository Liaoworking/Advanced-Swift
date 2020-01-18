文章源地址:[https://swiftui-lab.com/geometryreader-to-the-rescue/](https://swiftui-lab.com/geometryreader-to-the-rescue/)

作者: Javier

翻译: Liaoworking

# 探究View树 part-1 PreferenceKey

#### 在SwiftUI中我们一般不用关心子级视图内部发生了什么。不同的View各自管各自内部的事情。但总是会遇到一些特殊的需求。比较惨的是[文档](https://developer.apple.com/documentation/swiftui/view/3278633-preference)都讲的比较粗略。 探究View树的三篇文章会做个补充。我们将要去了解 **PreferenceKey** 的协议和相关的修改器(```modifier```):如  
**.preference(), 
.transformPreference(),
.anchorPreference(), 
.transformAnchorPreference(),
.onPreferenceChange(),
.backgroundPreferenceValue() 
.overlayPreferenceValue().** 
 有很多，那我们开始吧~

SwiftUI有一个让我们去给View添加很多属性的机制。这些属性我们叫做 **偏好**(Preferences) 。 它们可以轻松的沿视图依次调用下去，甚至无论怎么修改偏好，添加的回调都会不受影响的执行。

有没有想过navigationView是如何通过 **.navigationBarTitle()** 来获取title。请注意 .navigationBarTitle() 并没有直接修改NavigationView。而是在沿着View的层级去调用。那么它是怎么做到的呢？ 可能你已经猜到了。其实是用了偏好。在2019WWDC的SwiftUI专栏里有一个很简短的介绍。大概只有20秒。感兴趣的话可以查看[Session 216 (SwiftUI Essentials)](https://developer.apple.com/videos/play/wwdc2019/216/)直接跳到52:35。

我们已经找到有一些特殊的偏好 叫"anchored preferences(锚定偏好)"， 可以利用它们来方便的检索子级View的所有几何学数据。在下中会详细介绍锚定偏好(anchored preferences)


### 独立的Views

我们将会用很短的时间去了解 **PreferenceKey** ，为了更好的了解今天的话题，我们先用一个没有使用偏好的例子开始。在例子中，先创建一个显示月份名的View。当月份标签被点击的时候，会在月份标签上面慢慢的显示一个边框(从之前选中的月份标签移除)。
![image](https://swiftui-lab.com/wp-content/uploads/2019/06/blog-tree-animation-1.gif)
例1

代码很简单，先创建我们的ContentView:

    import SwiftUI

    struct EasyExample : View {
        @State private var activeIdx: Int = 0
        
        var body: some View {
            VStack {
                Spacer()
                
                HStack {
                    MonthView(activeMonth: $activeIdx, label: "January", idx: 0)
                    MonthView(activeMonth: $activeIdx, label: "February", idx: 1)
                    MonthView(activeMonth: $activeIdx, label: "March", idx: 2)
                    MonthView(activeMonth: $activeIdx, label: "April", idx: 3)
                }
                
                Spacer()
                
                HStack {
                    MonthView(activeMonth: $activeIdx, label: "May", idx: 4)
                    MonthView(activeMonth: $activeIdx, label: "June", idx: 5)
                    MonthView(activeMonth: $activeIdx, label: "July", idx: 6)
                    MonthView(activeMonth: $activeIdx, label: "August", idx: 7)
                }
                
                Spacer()
                
                HStack {
                    MonthView(activeMonth: $activeIdx, label: "September", idx: 8)
                    MonthView(activeMonth: $activeIdx, label: "October", idx: 9)
                    MonthView(activeMonth: $activeIdx, label: "November", idx: 10)
                    MonthView(activeMonth: $activeIdx, label: "December", idx: 11)
                }
                
                Spacer()
            }
        }
    }


和自定义views:

    struct MonthView: View {
        @Binding var activeMonth: Int
        let label: String
        let idx: Int
        
        var body: some View {
            Text(label)
                .padding(10)
                .onTapGesture { self.activeMonth = self.idx }
                .background(MonthBorder(show: activeMonth == idx))
        }
    }
    
    struct MonthBorder: View {
        let show: Bool
        
        var body: some View {
            RoundedRectangle(cornerRadius: 15)
                .stroke(lineWidth: 3.0).foregroundColor(show ? Color.red : Color.clear)
                .animation(.easeInOut(duration: 0.6))
        }
    }

代码逻辑也很简单，当月份标签被点击，改变 ```@State``` 为最新点击的月份标签的序号。 而且每个月份边框的颜色都由自己的变量来控制。 如果月份标签被选中，边框会被设置成红色，否则边框就会变透明。这个例子很简答，每个View绘制自己的边框。

---

### 相互协作的Views
下面难度再升级一些，我们想让边框从一个月份移动到另外一个。
![image](https://swiftui-lab.com/wp-content/uploads/2019/06/blog-tree-animation-2.gif)
例子2

你可以先想想如何去实现，不像之前有12个边框，现在只有一个边框，你需要动画改变边框的位置和大小。

例子2中，边框并不是月份的一部分，你需要创建一个单独的边框View，并相应的改变位置和大小，这意味着必须有一种方式去跟踪每个月份的大小和位置。

如果你看过我上一批文章([GeometryReader to the Rescue](https://swiftui-lab.com/geometryreader-to-the-rescue/)),
你就已经有一种方式去解决这个问题了，如果你不知道GeometryReader是怎么工作的，可以先看看这篇文章。

解决这个问题的一种方式就是： 每一个月份标签都通过GeometryReader去获得自身的大小和位置。每个月份标签依次更新父级视图中的存放位置的数组(通过 **@Binding** )。 一旦父级视图找到了每一个子视图的位置和大小，边框就可以很容易的替换了。这个方案还不错，但子级视图修改数组的时候可能会产生问题。

对于某些布局，如果在构建视图的时候，修改其某个变量，其父级视图也会受到影响，反过来子级视图也会受到影响。这使我们正在构建的视图失效，有时可能需要再重新开始构建视图。 还有时候会变成一个循环。好的是SwiftUI视乎可以检测到这种情况，也不会产生崩溃。它会给你一个运行时的警告: **Modifying state during view update(当视图更新的时候修改视图)**. 快速修复这个问题的方法是延迟变量的改变，直到视图的更新完成：

    DispatchQueue.main.async {
      self.rects[k] = rect
    }

不过这好像有点取巧(hack), 虽然这起作用了，但只是一个暂时的解决方案。不确定以后会不会起作用。 有点对框架底层的原理下赌注的意思了。幸运的是 PreferenceKey 可以解决。


### PreferenceKey的介绍

SwiftUI 提供给我们一个修改器让我们添加一些数据到某个具体的视图。我们可以通过顶级视图(ancestor view)查询这些数据。并且有多种方式去读取PreferenceKey。这取决于你的目的是怎样的。无论怎样，偏好似乎就是我们想要的，那我们先试试来解决我们的问题。

我们可以通过下面的例子来知道通过preferences来暴露哪些信息。

1.去标记一些view，这里我们通过Int值0..11去标记，其实你可以用任何值都可以标记的。

2.获取文本框的CGRect.

我们先命名一个遵守 **Equatable** 协议的MyTextPreferenceData的结构体。

    struct MyTextPreferenceData: Equatable {
        let viewIdx: Int
        let rect: CGRect
    }

然后我们定义一个遵循 **PreferenceKey** 的结构体MyTextPreferenceKey。

    struct MyTextPreferenceKey: PreferenceKey {
        typealias Value = [MyTextPreferenceData]
    
        static var defaultValue: [MyTextPreferenceData] = []
        
        static func reduce(value: inout [MyTextPreferenceData], nextValue: () -> [MyTextPreferenceData]) {
            value.append(contentsOf: nextValue())
        }
    }

我强烈建议你阅读一些PreferenceKey的文档，遵守协议后你必须要实现如下:

* **value** 我们想要通过PreferenceKey获得什么类型的一个别名，例子中我们用的是[MyTextPreferenceData]数组。
* **defaultValue** 没有显式设置首选项时，SwiftUI会用这个默认值。
* **reduce** 用来覆盖在视图树中找到的所有键值对，是一个静态函数。通常你可以用来累加接收到的所有值。在我们的例子中，当SwiftUI遍历视图树时，会把所有preference键值对存储在一个数组中。下面我们会讲。你应该清楚  **值是按照视图树的顺序给reduce函数的** 我们会在另外一个例子中讨论。

我们现在有了 PreferenceKey 了，开始对之前的代码就行修改。

先修改MonthView， 通过GeometryReader来获取文字的大小和位置，这些值需要转换一下坐标系，才能绘制出正确的边框。视图可以通过修改器来命名它们的空间坐标系 ``.coordinateSpace(name: "name")``。 一旦我们转换了rect，我们也要相应的设置preference

    struct MonthView: View {
        @Binding var activeMonth: Int
        let label: String
        let idx: Int
        
        var body: some View {
            Text(label)
                .padding(10)
                .background(MyPreferenceViewSetter(idx: idx)).onTapGesture { self.activeMonth = self.idx }
        }
    }
    
    struct MyPreferenceViewSetter: View {
        let idx: Int
        
        var body: some View {
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.clear)
                    .preference(key: MyTextPreferenceKey.self,
                                value: [MyTextPreferenceData(viewIdx: self.idx, rect: geometry.frame(in: .named("myZstack")))])
            }
        }
    }

然后，我们创建一个单独的边框视图，该视图将更改其偏移量和frame以匹配与最后点击的视图相对应的矩形：

    RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 3.0).foregroundColor(Color.green)
        .frame(width: rects[activeIdx].size.width, height: rects[activeIdx].size.height)
        .offset(x: rects[activeIdx].minX, y: rects[activeIdx].minY)
        .animation(.easeInOut(duration: 1.0))

最后，我们只要保证当preferences改变的时候，我们相应的关系rect数组。 例如当设备旋转，或者window的大小改变， 下面的代码都会被调用：

    .onPreferenceChange(MyTextPreferenceKey.self) { preferences in
        for p in preferences {
            self.rects[p.viewIdx] = p.rect
        }
    }

下面是完整的代码：

    import SwiftUI
    
    struct MyTextPreferenceKey: PreferenceKey {
        typealias Value = [MyTextPreferenceData]
    
        static var defaultValue: [MyTextPreferenceData] = []
        
        static func reduce(value: inout [MyTextPreferenceData], nextValue: () -> [MyTextPreferenceData]) {
            value.append(contentsOf: nextValue())
        }
    }
    
    struct MyTextPreferenceData: Equatable {
        let viewIdx: Int
        let rect: CGRect
    }
    
    struct ContentView : View {
        
        @State private var activeIdx: Int = 0
        @State private var rects: [CGRect] = Array<CGRect>(repeating: CGRect(), count: 12)
        
        var body: some View {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 3.0).foregroundColor(Color.green)
                    .frame(width: rects[activeIdx].size.width, height: rects[activeIdx].size.height)
                    .offset(x: rects[activeIdx].minX, y: rects[activeIdx].minY)
                    .animation(.easeInOut(duration: 1.0))
                
                VStack {
                    Spacer()
                    
                    HStack {
                        MonthView(activeMonth: $activeIdx, label: "January", idx: 0)
                        MonthView(activeMonth: $activeIdx, label: "February", idx: 1)
                        MonthView(activeMonth: $activeIdx, label: "March", idx: 2)
                        MonthView(activeMonth: $activeIdx, label: "April", idx: 3)
                    }
                    
                    Spacer()
                    
                    HStack {
                        MonthView(activeMonth: $activeIdx, label: "May", idx: 4)
                        MonthView(activeMonth: $activeIdx, label: "June", idx: 5)
                        MonthView(activeMonth: $activeIdx, label: "July", idx: 6)
                        MonthView(activeMonth: $activeIdx, label: "August", idx: 7)
                    }
                    
                    Spacer()
                    
                    HStack {
                        MonthView(activeMonth: $activeIdx, label: "September", idx: 8)
                        MonthView(activeMonth: $activeIdx, label: "October", idx: 9)
                        MonthView(activeMonth: $activeIdx, label: "November", idx: 10)
                        MonthView(activeMonth: $activeIdx, label: "December", idx: 11)
                    }
                    
                    Spacer()
                    }.onPreferenceChange(MyTextPreferenceKey.self) { preferences in
                        for p in preferences {
                            self.rects[p.viewIdx] = p.rect
                        }
                }
            }.coordinateSpace(name: "myZstack")
        }
    }
    
    struct MonthView: View {
        @Binding var activeMonth: Int
        let label: String
        let idx: Int
        
        var body: some View {
            Text(label)
                .padding(10)
                .background(MyPreferenceViewSetter(idx: idx)).onTapGesture { self.activeMonth = self.idx }
        }
    }
    
    struct MyPreferenceViewSetter: View {
        let idx: Int
        
        var body: some View {
            GeometryReader { geometry in
                Rectangle()
                    .fill(Color.clear)
                    .preference(key: MyTextPreferenceKey.self,
                                value: [MyTextPreferenceData(viewIdx: self.idx, rect: geometry.frame(in: .named("myZstack")))])
            }
        }
    }


### 明智地使用Preferences(首选项)
当我们使用preferences，可能会使用子级视图的几何信息来布局它们的一个顶层视图(ancestors)，如果是这样的话，你应该注意。 如果顶层视图影响了子级视图的布局，反过来子级视图也会影响顶层视图，就会陷入一个递归循环中。

可能有时候程序会卡死，或者屏幕会闪动来持续的重新绘制。或者CPU会达到一个峰值，这些都会暗示你错误的使用了preferences。

例如你在VStack中有两个视图，上面的视图高度依据下面视图的y值。 可能就会给你带来循环。

为了解决这个问题，用一些布局工具使得顶层视图不要影响子级视图，一些好的方案就是: **ZStack, .overlay(), .background()** 
 或者几何影响（geometry effects）.
 我们将在即将发布的文章中去讨论 **几何影响** (GeometryEffect)

### 下一步是什么
这篇文章中我们通过GeometryReader来“窃取”了月份标签中的几何信息，然而我们可以通过锚定的偏好(Anchor Preferences)来更好的实现它。 在下面的[文章中](https://swiftui-lab.com/communicating-with-the-view-tree-part-2/)我们将继续学习它。而且我们将深入究竟SwiftUI是怎样遍历树的。其实也可以不通过``.onPreferenceChange()`` 来使用preferences。下篇文章中也有讲解。

当你一开始去使用preferences的时候，可能你的代码又乱又难阅读。我觉得你应该在View的extension中封装好preferences，我之前写过的一篇文章有讲过怎么去做。你可以查看[让你代码变的更好的View extension](https://swiftui-lab.com/view-extensions-for-better-code-readability/)。

