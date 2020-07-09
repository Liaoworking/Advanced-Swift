# 关于WWDC的10个代码段

文章源地址:[https://medium.com/swlh/10-code-snippets-from-wwdc20-5dba158e2903](https://medium.com/swlh/10-code-snippets-from-wwdc20-5dba158e2903)

作者: Francesco Marisaldi

翻译: Liaoworking

##### WWDC2020带给了我们很多新特性和宣布了很多令人激动的消息。这里有10个代码段开始在下一个iOS版本里面支持。每个都不超过5行。

###1.SKOverlay
[SKOverlay官方文档](https://developer.apple.com/documentation/storekit/skoverlay)
第一个可以使我们在其他的app中显示一个浮层，来快速的下载应用。你可以设置位置和代理，你可以通过代理监听到出现，消失和处理对应的错误。

    guard let scene = view.window?.windowScene else { return }
    let config = SKOverlay.AppConfiguration(appIdentifier: "your-app-id", position: .bottom)
    let overlay = SKOverlay(configuration: config)
    overlay.present(in: scene)

它和 ```SKStoreProductViewController```的不同之处是它只是一个浮层而不是全屏幕展示。专为app clips设计。
用```SKOverlay.AppClipConfiguration```来设置要响应的app和位置，图下图所示。


![image](https://upload-images.jianshu.io/upload_images/1724449-9e6d42fa6ea8eca7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


