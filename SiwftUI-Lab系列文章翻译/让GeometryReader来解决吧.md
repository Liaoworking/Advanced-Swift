# 让GeometryReader来解决吧

##### 大多数情况下，SwiftUI都会发挥其[神奇的布局](https://swiftui-lab.com/layout-magic/)的特性。但是有时候，我们需要对自定义视图的布局进行更多操作。目前我们有几种工具。第一个需要我们去探索的就是**GeometryReader**。

#### 父级视图想要什么？
当我们创建自定义视图时，一般不用担心旁边视图的布局或size。如果你想要创建一个正方形。只要用一个Rectangle，就会以父级想要的size和position去画出一个正方形。

在下面的示例中，我们有一个frame为150×100的VStack。上面部分是Text，剩余空间都给了MyRectangle()。如图所示都被蓝色颜色填充：

    struct ContentView : View {
        var body: some View {
            
            VStack {
                
                Text("Hello There!")
                MyRectangle()
                
            }.frame(width: 150, height: 100).border(Color.black)
    
        }
    }
    
    struct MyRectangle: View {
        var body: some View {
            Rectangle().fill(Color.blue)
        }
    }

![image](https://swiftui-lab.com/wp-content/uploads/2019/06/blog-1.png)

正如你所看到的，MyRectangle()，不用去设置size，它只有一个任务，就是画矩形。让SwiftUI自己去管理好父级期望的子视图的大小和位置。 这个例子里Vstack就是父级视图。

``` 如果你想要知道更多关于父级视图如何确定子视图的位置和大小。我强烈推荐你看看2019WWDC session 237```[Building Custom Views With SwiftUI](https://developer.apple.com/videos/play/wwdc2019/237/)

   父级视图会自动为子视图找到合适的尺寸和位置。但是如果你想要自定义绘制一个矩形，大小是父级视图的一半。位置位于父级视图右边距里5像素的视图。
   其实也并不复杂，这个时候可以用GeometryReader作为解决方案。
   
###  子视图做了什么？
先看看Apple官方文档如何介绍的GeometryReader：

    A container view that defines its content as a function of its own size and coordinate space.
    一个容器视图，根据其自身大小和坐标空间定义其内容。

这个解释已经算很详细了。

那这句话是什么意思呢？ 简单来讲GeometryReader就是另外一种view。惊不惊喜？ 在SwiftUI中几乎```所有东西```都是View。 在下面的例子中，GeometryReader让你定义了它的content。 但是与其他View 不同。你可以拿到一些你在其他View中拿不到的信息。

上面说到想要绘制一个大小是父级视图的一半。位置位于父级视图右边距里5像素的视图。现在我们有了GeometryReader， 这就很简单了

   ![image](https://swiftui-lab.com/wp-content/uploads/2019/06/blog-2.png)

    struct ContentView : View {
        var body: some View {
            
            VStack {
                
                Text("Hello There!")
                MyRectangle()
                
            }.frame(width: 150, height: 100).border(Color.black)
    
        }
    }
    
    struct MyRectangle: View {
        var body: some View {
            GeometryReader { geometry in
                Rectangle()
                    .path(in: CGRect(x: geometry.size.width + 5,
                                     y: 0,
                                     width: geometry.size.width / 2.0,
                                     height: geometry.size.height / 2.0))
                    .fill(Color.blue)
                
            }
        }
    }


### GeometryProxy
上面的例子中，闭包中的geometry是一个**GeometryProxy**类的变量。我们可以通过[Inspecting the View Tree(检查视图树结构)](https://swiftui-lab.com/communicating-with-the-view-tree-part-1/)这篇文章去了解更多相关内容。

在GeometryProxy类中有两个计算型属性，一个方法，和一个下标取值。

    public var size: CGSize { get }
    public var safeAreaInsets: EdgeInsets { get }
    public func frame(in coordinateSpace: CoordinateSpace) -> CGRect
    public subscript<T>(anchor: Anchor<T>) -> T where T : Equatable { get }


**size**属性是父级视图建议的大小

GeometryProxy 把 **safeAreaInsets**也暴露给了我们。

**frame**方法暴露给我们了父级视图建议区域的大小位置，可以通过**.local,.global,.named()**来获取不同的坐标空间。 .named() 用来获取一个被命名的坐标空间。我们可以通过这个命名来获取其他view坐标空间。 [Inspecting the View Tree](https://swiftui-lab.com/communicating-with-the-view-tree-part-1/) 这篇文章中有具体的使用方法

最后，我们可以通过**下标取值**来获取一个**锚点<T>**。这个是GeometryReader的一个炫酷的功能。但也比较繁琐，我将在[second part of Inspecting the View Tree](https://swiftui-lab.com/communicating-with-the-view-tree-part-2/)有讲解。看完后就会有一个了解。可以获取视图树中任何子级视图的size和x,y. 是不是很强大，那你得先学啊。

### 吸收另外一个View的Geometry

GeometryReader 功能已经相当强大，但它如果与 **.background()**或 **.overlay()**的modifier相结合使用，功能就会更强大。

在我见过的教程中 background 都是以下面这种形式使用的：``Text("hello").background(Color.red)``
第一眼看，都会以为``Color.red``是一个颜色参数,它设置了背景色是红色，其实并不是，``Color.red``是一个View！它的功能就是把父级视图所建议的区域填充为红色。它的父级就是背景。而且背景修改了Text。所以建议``Color.red``所填充的区域就是``Text("Hello")``所在的区域。是不是很优美？

.overlay 修改器也是同样的道理，只是它并不是绘制背景，而是绘制前景而已。

我们已经知道了，我们可以给任意一个view使用.Color()方法还有 .background()方法。下面我们将结合GeometryReader，画一个每个角指定不同的半径的矩形的例子来演示如何利用它们。


![image](https://swiftui-lab.com/wp-content/uploads/2019/06/blog-3.png)

具体实现如下：

    struct ContentView : View {
        var body: some View {
            HStack {
                Text("SwiftUI")
                    .foregroundColor(.black).font(.title).padding(15)
                    .background(RoundedCorners(color: .green, tr: 30, bl: 30))
                
                Text("Lab")
                    .foregroundColor(.black).font(.title).padding(15)
                    .background(RoundedCorners(color: .blue, tl: 30, br: 30))
                
            }.padding(20).border(Color.gray).shadow(radius: 3)
        }
    }
    
    struct RoundedCorners: View {
        var color: Color = .black
        var tl: CGFloat = 0.0
        var tr: CGFloat = 0.0
        var bl: CGFloat = 0.0
        var br: CGFloat = 0.0
        
        var body: some View {
            GeometryReader { geometry in
                Path { path in
                    
                    let w = geometry.size.width
                    let h = geometry.size.height
                    
                    // We make sure the redius does not exceed the bounds dimensions
                    let tr = min(min(self.tr, h/2), w/2)
                    let tl = min(min(self.tl, h/2), w/2)
                    let bl = min(min(self.bl, h/2), w/2)
                    let br = min(min(self.br, h/2), w/2)
                    
                    path.move(to: CGPoint(x: w / 2.0, y: 0))
                    path.addLine(to: CGPoint(x: w - tr, y: 0))
                    path.addArc(center: CGPoint(x: w - tr, y: tr), radius: tr, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                    path.addLine(to: CGPoint(x: w, y: h - br))
                    path.addArc(center: CGPoint(x: w - br, y: h - br), radius: br, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                    path.addLine(to: CGPoint(x: bl, y: h))
                    path.addArc(center: CGPoint(x: bl, y: h - bl), radius: bl, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                    path.addLine(to: CGPoint(x: 0, y: tl))
                    path.addArc(center: CGPoint(x: tl, y: tl), radius: tl, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
                    }
                    .fill(self.color)
            }
        }
    }
    
另外，我们对自定义的Overlay设置透明度为0.5，设置在Text上。
代码如下：

    Text("SwiftUI")
        .foregroundColor(.black).font(.title).padding(15)
        .overlay(RoundedCorners(color: .green, tr: 30, bl: 30).opacity(0.5))
    Text("Lab")
        .foregroundColor(.black).font(.title).padding(15)
        .overlay(RoundedCorners(color: .blue, tl: 30, br: 30).opacity(0.5))
        
### 关于鸡和鸡蛋的问题
当你开始使用GeometryReader， 你就会发现所谓的鸡和鸡蛋的问题。
因为GeometryReader需要给子级试图提供可用空间，它首先需要尽可能多的占用空间。 但是子类可能会设置一个小的空间，这时候GeometryReader还是尽可能的保持大。
一旦子级试图确定了其所需空间， 你可能会被迫缩小GeometryReader。这时候子级试图就会GeometryReader计算出的新的大小做出反应。 一个循环就产生了。

所以 当遇到是子级试图依赖父级试图的大小，还是父级试图依赖于子级试图的大小。 可能GeometryReader并不适合解决你的布局问题。由此，你可以看看我的下一篇文章[Preferences and Anchor Preferences.](https://swiftui-lab.com/communicating-with-the-view-tree-part-1/)

### 总结

今天所学的GeometryReader让我们的自定义view知道了它们所需的大小和位置。 我们还学习了获取其他view的geometry。
这只是很第一篇官方并没有提及的讲SwiftUI中的布局工具的文章，接下来我们将会深度研究view的数层次，和子级试图如何把数据向上传递。[点我查看](https://swiftui-lab.com/communicating-with-the-view-tree-part-1/)

文章源地址:[https://swiftui-lab.com/geometryreader-to-the-rescue/](https://swiftui-lab.com/geometryreader-to-the-rescue/)
作者: Javier