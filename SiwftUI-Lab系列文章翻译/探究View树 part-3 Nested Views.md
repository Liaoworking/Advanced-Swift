文章源地址:[https://swiftui-lab.com/communicating-with-the-view-tree-part-3/)

作者: Javier

翻译: Liaoworking

# 探究View树 part-3 嵌套视图

### 处理嵌套视图的偏好(Preferences)

在之前的部分我们介绍了SwiftUI的锚定偏好(anchor preferences) , 现在到了最后一部分啦~ 把所有知识点放到一起，继续学习SwiftUI处理嵌套视图的偏好(preferences)。顺便添加一些Anchor<T>的其他用法。就从下面的例子开始吧。

我们的目标是创建一个小的示意图来展示一些状态的表格。
![image](https://swiftui-lab.com/wp-content/uploads/2019/06/minimap.gif)

在例子中需要注意:

* 左边小的示意图是缩小版的右边表格。不同的颜色代表不同的title view, 文本字段和文本字段的容器。
* 随着文字的变多，小示意图也会表现出来。
* 当我们添加新的视图的时候，小示意图也会改变。
* 当表格的frame改变的时候， 小示意图也会改变。
* 文本框的颜色红色代表没有输入，黄色小于3个，绿色大于等于3个。

---

注意小示意图并不知道任何关于表单的信息，它只是因为视图层级的偏好(preferences)的改变而改变。

### 那就开始吧~

因为这里的视图有多种类型，需要来将它们区分，这里我们用一个枚举。

    enum MyViewType: Equatable {
        case formContainer // 主容器
        case fieldContainer // 包括标签和文本框的容器
        case field(Int) //文本框，包括内容长度        
        case title // 表单标题
        case miniMapArea // 小示意图后面的视图
    }

    
然后我们定义一个MyPreferenceData类，用来处理偏好中设置的数据。它有两个属性(vtype 和 bounds)，还有一些会使用到的方法:
    
    struct MyPreferenceData: Identifiable {
        let id = UUID() // forEach必须要用的属性
        let vtype: MyViewType
        let bounds: Anchor<CGRect>
        
        // 配置小示意图的颜色
        func getColor() -> Color {
            switch vtype {
            case .field(let length):
                return length == 0 ? .red : (length < 3 ? .yellow : .green)
            case .title:
                return .purple
            default:
                return .gray
            }
        }
        
        // 如果当前view必须要显示在小示意图中 返回true
        // 只有文本框 文本框容器 标题才显示在小示意图中
        func show() -> Bool {
            switch vtype {
            case .field:
                return true
            case .title:
                return true
            case .fieldContainer:
                return true
            default:
                return false
            }
        }
    }

定义PreferenceKey

    struct MyPreferenceKey: PreferenceKey {
        typealias Value = [MyPreferenceData]
        
        static var defaultValue: [MyPreferenceData] = []
        
        static func reduce(value: inout [MyPreferenceData], nextValue: () -> [MyPreferenceData]) {
            value.append(contentsOf: nextValue())
        }
    }

有趣的地方开始了，我们有很多的区域，每一个区域前面都有一个textLabel，并被一个容器包裹。我们把这些重复的视图封装成MyFormField类。与此同时也相应的设置好偏好。文本框是VStack的一部分。我们需要两个嵌套视图的bounds. 不可以使用```.anchorPreference()```两次，在VStack中调用```anchorPreference() ```会阻止TextField中的调用。可以在VStack中掉用[```.transformAnchorPreference()```](https://developer.apple.com/documentation/swiftui/view/3278673-transformanchorpreference)来添加数据，而不是替换数据。

    // 包含标题、文本框的圆角视图
    struct MyFormField: View {
        @Binding var fieldValue: String
        let label: String
        
        var body: some View {
            VStack(alignment: .leading) {
                Text(label)
                TextField("", text: $fieldValue)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .anchorPreference(key: MyPreferenceKey.self, value: .bounds) {
                        return [MyPreferenceData(vtype: .field(self.fieldValue.count), bounds: $0)]
                    }
            }
            .padding(15)
            .background(RoundedRectangle(cornerRadius: 15).fill(Color(white: 0.9)))
            .transformAnchorPreference(key: MyPreferenceKey.self, value: .bounds) {
                $0.append(MyPreferenceData(vtype: .fieldContainer, bounds: $1))
            }
        }
    }

ContentView把所有的View都放到了一起，这里我们设置了三个偏好，稍后会再小示意图中用到。这三个偏好分别存储的是图表标题的bounds，图表区域和示意图区域。

    struct ContentView : View {
        @State private var fieldValues = Array<String>(repeating: "", count: 5)
        @State private var length: Float = 360
        @State private var twitterFieldPreset = false
        
        var body: some View {
            
            VStack {
                Spacer()
                
                HStack(alignment: .center) {
                    
                    // 存放小示意图的View
                    // 我们将获取它的大小、位置来确定小示意图的元素正确显示
                    Color(white: 0.7)
                        .frame(width: 200)
                        .anchorPreference(key: MyPreferenceKey.self, value: .bounds) {
                            return [MyPreferenceData(vtype: .miniMapArea, bounds: $0)]
                        }
                        .padding(.horizontal, 30)
                    
                    // 表单容器
                    VStack(alignment: .leading) {
                        // 标题
                        VStack {
                            Text("Hello \(fieldValues[0]) \(fieldValues[1]) \(fieldValues[2])")
                                .font(.title).fontWeight(.bold)
                                .anchorPreference(key: MyPreferenceKey.self, value: .bounds) {
                                    return [MyPreferenceData.init(vtype: .title, bounds: $0)]
                            }
                            Divider()
                        }
                        
                        // 开关和滑条
                        HStack {
                            Toggle(isOn: $twitterFieldPreset) { Text("") }
                            
                            Slider(value: $length, in: 360...540).layoutPriority(1)
                        }.padding(.bottom, 5)
    
                        // 文本框的第一行
                        HStack {
                            MyFormField(fieldValue: $fieldValues[0], label: "First Name")
                            MyFormField(fieldValue: $fieldValues[1], label: "Middle Name")
                            MyFormField(fieldValue: $fieldValues[2], label: "Last Name")
                        }.frame(width: 540)
                        
                        // 文本框的第二行
                        HStack {
                            MyFormField(fieldValue: $fieldValues[3], label: "Email")
                            
                            if twitterFieldPreset {
                                MyFormField(fieldValue: $fieldValues[4], label: "Twitter")
                            }
                            
                            
                        }.frame(width: CGFloat(length))
    
                    }.transformAnchorPreference(key: MyPreferenceKey.self, value: .bounds) {
                        $0.append(MyPreferenceData(vtype: .formContainer, bounds: $1))
                    }
    
                    Spacer()
                    
                }
                .overlayPreferenceValue(MyPreferenceKey.self) { preferences in
                    GeometryReader { geometry in
                        MiniMap(geometry: geometry, preferences: preferences)
                    }
                }
                
                Spacer()
            }.background(Color(white: 0.8)).edgesIgnoringSafeArea(.all)
        }
    }


最后，我们的小示意图会遍历所有的偏好，并绘制小示意图中的每一个元素。

    struct MiniMap: View {
        let geometry: GeometryProxy
        let preferences: [MyPreferenceData]
        
        var body: some View {
            // 获得表单容器的偏好
            guard let formContainerAnchor = preferences.first(where: { $0.vtype == .formContainer })?.bounds else { return AnyView(EmptyView()) }
            
            // 获得小示意图的偏好
            guard let miniMapAreaAnchor = preferences.first(where: { $0.vtype == .miniMapArea })?.bounds else { return AnyView(EmptyView()) }
            
            // 计算表单的数据 用来显示在小示意图中
            let factor = geometry[formContainerAnchor].size.width / (geometry[miniMapAreaAnchor].size.width - 10.0)
            
            // 确定表单的位置
            let containerPosition = CGPoint(x: geometry[formContainerAnchor].minX, y: geometry[formContainerAnchor].minY)
            
            // 确定小示意图的位置
            let miniMapPosition = CGPoint(x: geometry[miniMapAreaAnchor].minX, y: geometry[miniMapAreaAnchor].minY)
    
            // -------------------------------------------------------------------------------------------------
            // iOS 13 Beta 5 正式版发布日志 已知问题:
            // 复杂的ForEach view可能会有编译报错
            // 解决方案: 抽一个新的View出来
            // -------------------------------------------------------------------------------------------------
            // 由于 beta 5编译报错的bug，封装成AnyView.
            return AnyView(miniMapView(factor, containerPosition, miniMapPosition))
        }
    
        func miniMapView(_ factor: CGFloat, _ containerPosition: CGPoint, _ miniMapPosition: CGPoint) -> some View {
            ZStack(alignment: .topLeading) {
                // 创建小的示意图视图
                // 首选项以相反的顺序遍历
                // 将被父视图覆盖
                ForEach(preferences.reversed()) { pref in
                    if pref.show() { // 一些不想要显示的视图
                        self.rectangleView(pref, factor, containerPosition, miniMapPosition)
                    }
                }
            }.padding(5)
        }
        
        func rectangleView(_ pref: MyPreferenceData, _ factor: CGFloat, _ containerPosition: CGPoint, _ miniMapPosition: CGPoint) -> some View {
            Rectangle()
            .fill(pref.getColor())
            .frame(width: self.geometry[pref.bounds].size.width / factor,
                   height: self.geometry[pref.bounds].size.height / factor)
            .offset(x: (self.geometry[pref.bounds].minX - containerPosition.x) / factor + miniMapPosition.x,
                    y: (self.geometry[pref.bounds].minY - containerPosition.y) / factor + miniMapPosition.y)
        }
    
    }

### 关于视图树的一句话

现在让我们停下来思考一下：偏好(preference)闭包在嵌套视图中的执行顺序。例如先看看小示意图的实现，你可能会注意到ForEach以相反的顺序运行循环，否则文本框容器会最后才绘制，来覆盖对应的小示意图的文本框。 所以了解偏好的设置就变的很重要了。

> 首先请注意：并没有关于SwiftUI遍历视图树顺序的文档，PreferenceKey类中的reduce方法声明中提到值是以视图树的顺序排列。但是没有告诉我们这个顺序是什么，我们能确认的是这并不是随机顺序而且每次刷新的时候都保持一致。
> **下面我讲的所有和关于闭包中的运行顺序相关的，都是通过专门的实验弄清楚的。我几乎每个地方都打断点了，都说的通，我也对此很有信心**

下面的图表简单的说明了视图层级，为了让视图更容易理解，简单的视图就忽略了，红色的箭头表示``` anchorPreference() ```和```transformAnchorPreference()``` 闭包的执行顺序。注意，只有SwiftUI认为必须的才会调用，并不是所有的闭包都会被调用。例如视图的bounds并没有改变```.anchorPreference()```可能就不会调用。当不确定的时候，打个断点或者打印一下状态来调试一下。

![image](https://swiftui-lab.com/wp-content/uploads/2019/07/view-tree.png)

如图，SwiftUI遵循下面两个原则：

* 1.同级的视图的遍历顺序和它们在代码中的出现顺序相同。
* 2.子级视图的闭包执行时机要比父级视图早。

### Anchor<T>的其他使用。
正如我们所看到的，Anchor<T>.Source可以被一下静态变量获得到，如.bounds, .topLeading, .bottom等。我们通常将它传递给anchorPreference() 修改器。然而你可以通过静态变量Anchor<T>.Source创建你自己的Anchor<CGRect>.Source和Anchor<CGPoint>.Source，如下：

    let a1 = Anchor<CGRect>.Source.rect(CGRect(x: 0, y: 0, width: 100, height: 50))
    let a2 = Anchor<CGPoint>.Source.point(CGPoint(x: 10, y: 30))
    let a3 = Anchor<CGPoint>.Source.unitPoint(UnitPoint(x: 10, y: 30))


你可能会问我们什么时候用这些，你可以把值传递给偏好，如果已存在的静态变量对你都没啥用处，但是当处理弹框的时候用它就会特别的方便。

    .popover(isPresented: $showPopOver,
             attachmentAnchor: .rect(Anchor<CGRect>.Source.rect(CGRect(x: 0, y: 0, width: 100, height: 50))),
             arrowEdge: .leading) { ... }

### 总结：
恭喜，这一系列总算到最后了，希望你能享受享受这些工具而且用来创作炫酷的app。有着无限的可能性。欢迎评论，或者给我email和Twitter上关注我。

欢迎关注来获取更多文章。

