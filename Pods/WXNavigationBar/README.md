
# WXNavigationBar
WeChat NavigationBar

![](Assets/navigationbar01.gif)

<!-- Toc begin -->

* [Features](#features)
* [Requirements](#requirements)
* [Installation](#installation)
    * [CocoaPods](#cocoapods)
    * [Carthage](#carthage)
    * [Swift Package Manager](#swift-package-manager)
* [Design Principle](#design-principle)
* [Getting Started](#getting-started)
   * [UINavigationController based configuration](#uinavigationcontroller-based-configuration)
   * [ViewController based configuration](#viewcontroller-based-configuration)
      * [Background Color](#background-color)
      * [Background Image](#background-image)
      * [System blur navigation bar](#system-blur-navigation-bar)
      * [NavigationBar bar tint color](#navigationbar-bar-tint-color)
      * [NavigationBar tint color](#navigationbar-tint-color)
      * [Shadow Image](#shadow-image)
      * [Back Button Image](#back-button-image)
      * [fullscreen interactive pop gesture](#fullscreen-interactive-pop-gesture)
      * [interactivePopMaxAllowedInitialDistanceToLeftEdge](#interactivepopmaxallowedinitialdistancetoleftedge)
* [Advance usage](#advance-usage)
   * [Transparent Navigation Bar](#transparent-navigation-bar)
     * [alpha](#alpha)
     * [hidden](#hidden)
     * [background color](#background-color-1)
   * [Dynamic update navigation bar](#dynamic-update-navigation-bar)
   * [wx_navigationBar](#wx_navigationbar)
* [License](#license)
* [中文文档](#中文文档)

<!-- Toc End -->

## Features

- [x] Support transparent navigationbar
- [x] Support navigationbar background image
- [x] Support navigationbar large title mode
- [x] Support iOS 13 dark mode
- [x] Support fullscreen pop gesture
- [x] As Simple as using UINavigationBar 
 
## Requirements

- iOS 12.0+
- Xcode 11.0+
- Swift 5.0+

## Installation

### CocoaPods

`WXNavigationBar` is available through CocoaPods. To install it, simply add the following line to your Podfile:

```bash
use_frameworks!

pod 'WXNavigationBar'
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate WXNavigationBar into your Xcode project using Carthage, specify it in your Cartfile:

```bash
git alexiscn/WXNavigationBar
```

### Swift Package Manager

[The Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the swift compiler. It is in early development, but WXNavigationBar does support its use on supported platforms.

Once you have your Swift package set up, adding WXNavigationBar as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```
dependencies: [
    .package(url: "https://github.com/alexiscn/WXNavigationBar.git", .upToNextMajor(from: "1.8.0"))
]
```


## Design Principle

`WXNavigation` make the actual UINavigationBar transparent and add a view as a fake navigation bar to the view controller. 

The actual navigation bar still handles the touch events, the fake navigation bar do the display staffs, eg: backgroundColor, backgroundImage.

So you use navigation bar as usual. when you want to handle the display things, you use `WXNavigationBar`


## Getting Started

There is no setup needed for using WXNavigationBar. However you can customize WXNavigationBar if needed. There are two ways to configure WXNavigationBar: via `UINavigationController.Nav` and via `UIViewController` properties.

### UINavigationController based configuration

In your `AppDelegate.swift`

```swift

import WXNavigationBar

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

    // ...
    
    // Customize WXNavigationBar if needed (Optional)
    // WXNavigationBar.NavBar.backImage = UIImage(named: "xxx")
}

```

You can configure following options:

```swift
/// Back Image for Navigation Bar
public static var backImage: UIImage? = Utility.image(named: "wx_nav_back")
        
/// Background Image for NavigationBar
public static var backgroundImage: UIImage? = nil

/// Background color for NavigationBar
public static var backgroundColor: UIColor = UIColor(white: 237.0/255, alpha: 1.0)

/// Tint Color for NavigationBar
public static var tintColor = UIColor(white: 24.0/255, alpha: 1.0)

/// Shadow Image for NavigationBar
public static var shadowImage: UIImage? = UIImage()

/// Enable fullscreen pop gesture
public static var fullscreenPopGestureEnabled = false
```

### ViewController based configuration

You can also configure specific view controller by override properties that `WXNavigationBar` supported.

#### Background Color

You can configure background color of navigation bar.

```swift
/// Background color of fake NavigationBar
/// Default color is UIColor(white: 237.0/255, alpha: 1.0)
override var wx_navigationBarBackgroundColor: UIColor? {
    return .white
}
```

#### Background Image

You can confgiure navigation bar background using image.

```swift
override var wx_navigationBarBackgroundImage: UIImage? {
    return UIImage(named: "icons_navigation_bar")
}
```

#### System blur navigation bar

If you want to use system alike blured navigation bar:

```swift
override var wx_useSystemBlurNavBar: Bool {
    return true
}
```

#### NavigationBar bar tint color

By setting `wx_barBarTintColor`, you actually setting `barTintColor` of `navigationController?.navigationBar`

```swift
override var wx_barBarTintColor: UIColor? {
    return .red
}
```

#### NavigationBar tint color

By setting `wx_baTintColor`, you actually setting `tintColor` of `navigationController?.navigationBar`

```swift
override var wx_barTintColor: UIColor? {
    return .black
}
```

#### Shadow Image

You can specify navigation bar shadow image for specific view controller(eg: solid color line or gradient color line):

```swift
override var wx_shadowImage: UIImage? {
    return UIImage(named: "icons_navigation_bar_shadow_line")
}
```

#### Back Button Image

You can specify navigation bar back image for specific view controller:

```swift
override var wx_backImage: UIImage? {
    return UIImage(named: "icons_view_controller_back_image")
}
```

#### fullscreen interactive pop gesture

```swift
override var wx_interactivePopEnabled: Bool {
    return false
}
```

#### interactivePopMaxAllowedInitialDistanceToLeftEdge

```swift
override wx_interactivePopMaxAllowedInitialDistanceToLeftEdge: CGFloat {
    return view.bounds.width * 0.5
}
```

## Advance usage

Here is some adavnce usage suggestions for `WXNavigationBar`.

### Transparent Navigation Bar

There are several ways to make navigation bar transparent.

##### alpha

```swift
wx_navigationBar.alpha = 0
```

##### hidden

```swift
wx_navigationBar.isHidden = true
```

##### background color

```swift
override var wx_navigationBarBackgroundColor: UIColor? {
    return .clear
}
```

### Dynamic update navigation bar

You can dynamic update navigation bar, such as dynamic update through scrolling.

See `MomentViewController` for details.

### wx_navigationBar

`wx_navigationBar` is a subclass of UIView, so you can do anything to `wx_navigationBar` that can be done with UIView.

## License

WXNavigationBar is MIT-licensed. [LICENSE](LICENSE)


## 中文文档

你可以参考[中文文档](README_CN.md)