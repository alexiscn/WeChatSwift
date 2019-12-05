# WXActionSheet
a WeChat liked ActionSheet for iOS

![](Assets/preview.gif)

# Requirements

* iOS 11.0+
* Xcode 10.0+
* Swift 5.0+

# Installation

WXActionSheet is available through CocoaPods. To install it, simply add the following line to your Podfile:

```sh
pod 'WXActionSheet'
```

# Usage


Basic Usage


```swift

let actionSheet = WXActionSheet(cancelButtonTitle: "取消")
actionSheet.add(WXActionSheetItem(title: "发送给朋友", handler: { _ in
    
}))
actionSheet.add(WXActionSheetItem(title: "收藏", handler: { _ in
    
}))
actionSheet.add(WXActionSheetItem(title: "保存图片", handler: { _ in
    
}))
actionSheet.add(WXActionSheetItem(title: "删除", handler: { _ in
    
}, type: .destructive))
actionSheet.show()

```

Or your can custom titleView

```swift
let titleView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 50))
let titleLabel = UILabel()
titleLabel.font = UIFont.systemFont(ofSize: 13)
titleLabel.textColor = UIColor.gray
titleLabel.text = "清除位置信息后，别人将不能查看到你"
titleView.addSubview(titleLabel)
titleLabel.translatesAutoresizingMaskIntoConstraints = false
titleLabel.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true

let actionSheet = WXActionSheet(cancelButtonTitle: "取消")
actionSheet.titleView = titleView
actionSheet.add(WXActionSheetItem(title: "清除位置并退出", handler: { _ in

}, type: .destructive))
actionSheet.show()
```

You can also configure styles globally:

```swift
WXActionSheet.Preferences.ButtonHeight = 44.0
WXActionSheet.Preferences.ButtonTitleColor = .white
WXActionSheet.Preferences.ButtonNormalBackgroundColor = UIColor(white: 0.0, alpha: 0.3)
WXActionSheet.Preferences.ButtonHighlightBackgroundColor = UIColor(white: 0.0, alpha: 0.5)
WXActionSheet.Preferences.DestructiveButtonTitleColor = UIColor.black
```