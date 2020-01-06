文章源地址:[https://swiftui-lab.com/communicating-with-the-view-tree-part-2/](https://swiftui-lab.com/communicating-with-the-view-tree-part-2/)

作者: Javier

翻译: Liaoworking

# 探究View树 part-2 AnchorPreferences(锚定偏好)

 在[第一部分](https://swiftui-lab.com/communicating-with-the-view-tree-part-1/)的文章中，我们介绍了偏好(preferences)的使用，它可以很有用的把信息向上传递(从子级视图传到祖级视图)。通过定义PreferenceKey的关联类型，可以获取到所有想要的数据。

在第二部分，我们将介绍 **锚定偏好** (Anchor Preferences 写的时候国内还没有对应的名词翻译，这里凭个人理解硬翻)，在写这篇文章的时候还没有找到任何相关文档、博客或者文章来介绍如何使用这些很难理解的工具类。那就让我来介绍一下吧。

锚定偏好看字面意思并不好理解。但只要我们掌握了，就很难忘却了。还是通过第一部分里面的例子来讲。这里不会用到之前的空间坐标系来解决。我们将用其他方法来替换```.onPreferenceChange()```。

这里在简单提及例子里所做的事情：点击不同的月份的时候边框会从一个月份移动到另外一个月份上面，并带有动画效果。

![image](https://swiftui-lab.com/wp-content/uploads/2019/06/blog-tree-animation-2.gif)

### 锚定偏好

首先迎来的是**Anchor< T >**, 这是存放泛型T的不透明的类型。 这里的T可以是CGRect或者是CGPoint。我们一般使用Anchor<CGRect>来获得视图的大小，用Anchor<CGPoint>来获取例top, topLeading, topTrailing, center, trailing, bottom, bottomLeading, bottomTrailing, leading属性。

因为这是不透明类型，所以我们不能单独使用它。还记得之前的文章[GeometryReader to the Rescue](https://swiftui-lab.com/geometryreader-to-the-rescue/)文章中GeometryProxy的通过下标getter方法么。现在你应该知道了，当使用Anchor<T>的值作为 geometry proxy 的索引时，你就可以获得CGRect和CGPoint的值。此外，你还可以获取它们在GeometryReader视图中的空间坐标。

我们先通过修改PreferenceKey处理的数据开始吧，在这个例子中我们把CGRect替换成了Anchor<CGRect>

    struct MyTextPreferenceData {
        let viewIdx: Int
        let bounds: Anchor<CGRect>
    }

我们的PreferenceKey 保持不变

    struct MyTextPreferenceKey: PreferenceKey {
        typealias Value = [MyTextPreferenceData]
        
        static var defaultValue: [MyTextPreferenceData] = []
        
        static func reduce(value: inout [MyTextPreferenceData], nextValue: () -> [MyTextPreferenceData]) {
            value.append(contentsOf: nextValue())
        }
    }

MonthView的代码就变的更简洁了，把MonthView的```.preference()```替换成```.anchorPreference()```。和其他方法不同，这里我们可以指定一个值(例子里面指定的是.bounds)。 那么我们transform这闭包中的Anchor<CGRect>就是修改视图的bounds。 和处理普通的偏好相似，我们用{$0}来创建MyTextPreferenceData值。这样的话我们就不需要在.background() 中使用GeometryReader来获取text View的bounds了。

代码如下：

    struct MonthView: View {
        @Binding var activeMonth: Int
        let label: String
        let idx: Int
        
        var body: some View {
            Text(label)
                .padding(10)
                .anchorPreference(key: MyTextPreferenceKey.self, value: .bounds, transform: { [MyTextPreferenceData(viewIdx: self.idx, bounds: $0)] })
                .onTapGesture { self.activeMonth = self.idx }
        }
    }

最后，更新我们的ContentView，这里会有一些变化。对初学者来说，我们不再使用```.onPreferenceChange()```，而是使用```.backgroundPreferenceValue()```。这是一个类似于```.background()```的修改器。
但它有一个很大的好处就是：
我们可以获取到整个视图树的偏好(preference)数组。
这样的话，我们也可以通过获取到所有的月份视图的Bounds信息来计算出边框应该绘制在哪里。

### #warning()

#### 在Xcode 11 beta5中，苹果悄悄的 用 **Equatable** 移除了 **Anchor<Value>** 的一致性。 如果你想要使用 **.onPreferenceChange()** ， 你大概能想象到，需要你的preference key的值符合 **Equatable** 协议。幸运的是例子中没有使用到 **.onPreferenceChange()** ， 自从Anchor<Value>的一致性被弃用之后我就一直希望在 GM版本发布之前恢复。 我提交了一个错误报告(FB6912036), 希望你也能这样。


仍然还有一个地方需要用到GeometryReader，通过它我们可以不用关心空间坐标，也让Anchor<CGRect>的值变的有用。



    struct ContentView : View {
        
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
            }.backgroundPreferenceValue(MyTextPreferenceKey.self) { preferences in
                return GeometryReader { geometry in
                    ZStack {
                        self.createBorder(geometry, preferences)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
            }
        }
        
        func createBorder(_ geometry: GeometryProxy, _ preferences: [MyTextPreferenceData]) -> some View {
            
            let p = preferences.first(where: { $0.viewIdx == self.activeIdx })
            
            let bounds = p != nil ? geometry[p!.bounds] : .zero
                    
            return RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 3.0)
                    .foregroundColor(Color.green)
                    .frame(width: bounds.size.width, height: bounds.size.height)
                    .fixedSize()
                    .offset(x: bounds.minX, y: bounds.minY)
                    .animation(.easeInOut(duration: 1.0))
        }
    }


和```.backgroundPreferenceValue()``` 相对应的是```.overlayPreferenceValue()```， 它们的作用相同，只不过一个是绘制背景，一个是绘制前景。

### 单个 PreferenceKey 和 多个锚定偏好

我们知道Anchor<T> 的值不止有bounds，还有topLeading, center, bottom等值。可能有的情况下我们需要的不止一个Anchor<T> 的值，然而，调用它并不像调用```.anchorPreference() ``` 一样容易。下面我们举例继续说明。
   我们将使用两个不同的 Anchor<CGPoint>，来获取月份标签的bounds， 其中一个左上角的Point 一个是右下角的 Point。而不是用Anchor<CGRect>。
提醒一下，使用Anchor<CGRect>是对这种特定问题的一个更好的解决方案。然而，我们用CGPoint方案只是为了知道如何获取一个视图的多个锚定偏好。
 
 首先修改MyTextPreferenceData来容纳两个极端rect，要设置成可选型， 因为它们不能同时赋值。
  
    struct MyTextPreferenceData {
        let viewIdx: Int
        var topLeading: Anchor<CGPoint>? = nil
        var bottomTrailing: Anchor<CGPoint>? = nil
    }

PreferenceKey 保持不变。

    struct MyTextPreferenceKey: PreferenceKey {
        typealias Value = [MyTextPreferenceData]
        
        static var defaultValue: [MyTextPreferenceData] = []
        
        static func reduce(value: inout [MyTextPreferenceData], nextValue: () -> [MyTextPreferenceData]) {
            value.append(contentsOf: nextValue())
        }
    }

月份标签没必要设置两个锚定偏好，但是如果我们在同一个视图中多次调用```.anchorPreference()```。 只有最后一次起作用。 相反我们需要调用 ```.anchorPreference()```, 然后再调用```.transformAnchorPreference()```,来补回缺失的信息。

    struct MonthView: View {
        @Binding var activeMonth: Int
        let label: String
        let idx: Int
        
        var body: some View {
            Text(label)
                .padding(10)
                .anchorPreference(key: MyTextPreferenceKey.self, value: .topLeading, transform: { [MyTextPreferenceData(viewIdx: self.idx, topLeading: $0)] })
                .transformAnchorPreference(key: MyTextPreferenceKey.self, value: .bottomTrailing, transform: { ( value: inout [MyTextPreferenceData], anchor: Anchor<CGPoint>) in
                    value[0].bottomTrailing = anchor
                })
                
                .onTapGesture { self.activeMonth = self.idx }
        }
    }
    

最后，我们相应的更新```.createBorder()```，所以它使用的是两个point来进行的计算，而不是rect.
    
            struct ContentView : View {
            
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
                }.backgroundPreferenceValue(MyTextPreferenceKey.self) { preferences in
                    return GeometryReader { geometry in
                        ZStack {
                            self.createBorder(geometry, preferences)
                        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    }
                }
            }
            
            func createBorder(_ geometry: GeometryProxy, _ preferences: [MyTextPreferenceData]) -> some View {
                let p = preferences.first(where: { $0.viewIdx == self.activeIdx })
                
                let aTopLeading = p?.topLeading
                let aBottomTrailing = p?.bottomTrailing
                
                let topLeading = aTopLeading != nil ? geometry[aTopLeading!] : .zero
                let bottomTrailing = aBottomTrailing != nil ? geometry[aBottomTrailing!] : .zero
                
                
                return RoundedRectangle(cornerRadius: 15)
                    .stroke(lineWidth: 3.0)
                    .foregroundColor(Color.green)
                    .frame(width: bottomTrailing.x - topLeading.x, height: bottomTrailing.y - topLeading.y)
                    .fixedSize()
                    .offset(x: topLeading.x, y: topLeading.y)
                    .animation(.easeInOut(duration: 1.0))
            }
        }
        
        
### 嵌套视图
到目前为止，我们已经在兄弟视图上使用了preferences。但在嵌套视图的使用上我们还有更多的挑战。```.transformAnchorPreference() ``` 就变的很重要了，如果你有嵌套的两个视图，而且两个都设置```.anchorPreference() ```，子级视图的将不会起作用。 为了解决这样个问题，你必须要指定子级视图的anchorPreference和父级视图的transformAnchorPreference。但是别慌， 我们会详细介绍的。

### 下一步是什么
在这一系列的最后一部分，将用一个不同的例子来说明。 我们将会有一个小的示意图。小的示意图将会读取视图树的表单来构造。 我们将会去修改表单的视图。而且会马上生效。它只是对这个表单视图树的preferences改变产生了反馈。

这里有个小图来解释：
![image](https://swiftui-lab.com/wp-content/uploads/2019/06/minimap.gif)

我相信这个系列的最后一部分你会来。如果你想要被提醒一下，可以在[Twitter](https://twitter.com/SwiftUILab)上关注我，下次见啦~

