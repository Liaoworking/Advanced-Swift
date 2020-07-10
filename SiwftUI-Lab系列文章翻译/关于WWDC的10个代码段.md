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

### 2.Configurations

Configurations是一个用于设置视图和Cell样式的全新API。很灵活，因为它可以用在任何的UIView上，包括collectionView和tableView的cell，使用简单。
下面就是一个```UIListContentConfiguration```的使用例子:

    var config = UIListContentConfiguration.subtitleCell()
    config.image = UIImage(systemName:"tortoise")
    config.text = "Hello world!"
    config.secondaryText = "WWDC20"
    let list = UIListContentView(configuration: config)

List content的设置有很多默认的设置，包括状态，内容和背景设置，此外，它替代了 UITableViewCell废弃的"textLabel","detailTextLabel","imageView"的属性，[具体文档](https://developer.apple.com/documentation/uikit/views_and_controls/configurations)

### 3. CollectionView 新增的 Lists

从iOS 14开始，collectionView就可以设置类似于tableView的列表样式(这意味着tableView的时代要到了尽头)，示例代码如下：

    let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    let layout = UICollectionViewCompositionalLayout.list(using: config)

列表会有不同的样式，而且会有滑动手势，分割线，accessories，WWDC的[Lists in UICollectionView](https://developer.apple.com/videos/play/wwdc2020/10026/)会告诉你更多细节。

### 4.定位精确度的改变。
Core Location框架这次也迎来了一些改变。可以允许用户选择分享给app的位置精确度的高或者低。
如果你需要高精读的定位，而用户分享给你的是低精度的怎么办？你可以用下面的代码来解决你的问题：

    let manager = CLLocationManager()
    manager.requestTemporaryFullAccuracyAuthorization(withPurposeKey: "YOUR-PURPOSE-KEY") { (error) in
        // Your code
    }

暂时性的高精度只对运行中的进程可以，你必须要通过在info.plist中添加```NSLocationTemporaryUsageDescriptionDictionary```key及对应的描述才可以。 如果有更多的需求，或者你感兴趣的话，可以通过WWDC中的[What’s new in location](https://developer.apple.com/wwdc20/10660)和[Design for location privacy](https://developer.apple.com/wwdc20/10162)两个session来了解。

### 5.行为追踪的授权
今年苹果对用户发隐私有很大的关注(其实最近几年年年都是。。。)，不仅是定位和浏览器，而且应用的数据也会有限制。如果你获取设备的IDFA或者其他的敏感信息来追踪用户行为。你现在需要使用新的```AppTrackingTrasparency```框架。

    ATTrackingManager.requestTrackingAuthorization { (status) in
        // your code
    }
    // To know current status
    ATTrackingManager.trackingAuthorizationStatus

需要你在info.plist中去添加```NSUserTrackingUsageDescription``` key和对应的授权描述。用户可以在对于设置授权弹框不弹出。这样手机中所有app的这个授权弹框都不会弹出。[Build trust through better privacy](https://developer.apple.com/videos/play/wwdc2020/10676/) 这个session讲了更多相关的细节。


