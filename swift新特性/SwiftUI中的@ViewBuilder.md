
### 什么是@ViewBuilder?

##### 从字面意思去理解 ViewBuilder 就是```视图构建```，其主要使用场景就是构建视图。
##### 可以通过ViewBuilder把许多具体相同特点的View封装起来，并且分离逻辑代码和视图，提升代码的可复用性，并增强可读性。
##### 看了下面的例子你可能就会对@ViewBuilder的使用有一个更好的理解。

如果我们想要设置一个Text的背景为红色，圆角为5。我们可能这样去写

    Text("Liaoworking")
    .background(Color.red)
    .cornerRadius(5)

后台产品加需求了： 图片也是红色的背景，圆角为5：

    Image("Liaoworking")
    .background(Color.red)
    .cornerRadius(5)

再后来产品又加需求：一些自定义视图也是红色的背景，圆角为5：
这里假设我们的自定义视图类为MyView
    
    MyView()
    .background(Color.red)
    .cornerRadius(5)

聪明的你肯定想到了用一个View的extension来统一处理。

    extension View {
        func addRedBGWithRoundCorner() -> some View {
            self
            .background(Color.red)
            .cornerRadius(5)
        }
    }
    
    //调用：
    Text("Liaoworking").addRedBGWithRoundCorner()
    
这样做的确可以达到相同的效果，而且代码也会简洁不少。

这个时候你还可以用```@ViewBuilder```注解来创建你的自定义视图达到相同的效果：

    struct RedBackgroundAndCornerView<Content: View>: View {
        let content: Content
        
        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        var body: some View {
            content
                .background(Color.red)
                .cornerRadius(5)
        }
    }
    
    使用方法如下：
    
    RedBackgroundAndCornerView {
        Text("liaoworking")
    }
    
    
两种封装的最后效果都是一样的，你可能会觉得，```View的extension封装要比@ViewBuilder 封装 好太多```。代码都少写很多。

但是突然有一天，你的产品经理决定再加一个功能，上面的这些视图点击后都自动隐藏，你会怎么写？

    @State var needHideText: Bool = false

    Text("Liaoworking")
        .addRedBGWithRoundCorner()
        .opacity(needHideText ? 0.0 : 1.0)
        .onTapGesture {
            self.needHideText = true
        }
    
   
然后到了Image，还有MyView， ```对于每一个需要隐藏的对象，你都得创建一个类似于needHideText的变量来控制显示隐藏逻辑```。 到最后你的重复代码可能会越来越多。
    
因为extension```无法去存储控制隐藏逻辑的变量```，这个时候@ViewBuilder的先天优势马上就体现出来了。

我们只需要将逻辑代码在@ViewBuilder中写一次，所有的View就具有了相同的特性。

    struct RedBackgroundAndCornerView<Content: View>: View {
        let content: Content
        @State var needHidden: Bool = false
        
        init(@ViewBuilder content: () -> Content) {
            self.content = content()
        }
        
        var body: some View {
            content
                .background(Color.red)
                .cornerRadius(5)
                .opacity(needHideText ? 0.0 : 1.0)
                .onTapGesture {
                    self.needHidden = true
            }
        }
    }
    // 所有被RedBackgroundAndCornerView包裹的View就都具有了点击后隐藏的功能了。
    RedBackgroundAndCornerView {
        Text("liaoworking")
    }
    
    RedBackgroundAndCornerView {
        Image("liaoworking")
    }
    
    RedBackgroundAndCornerView {
        MyView("liaoworking")
    }
    
    
### 总结：
@ViewBuilder是一个封装可复用view逻辑的利器。它最大的好处就是把你逻辑代码和你的视图剥离开。让代码的可维护行和易读性有很大提升。我在之前的项目里一开始写过很多垃圾代码，后来知道了@ViewBuilder，这的确在对相同逻辑View的封装和使用上有了很大的便捷。 