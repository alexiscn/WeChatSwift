//
//  MMNavigationControllerDelegate.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/6.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

///  push/pop 相关的一些方法
@objc protocol MMNavigationControllerTransitionDelegate: class {
    
    /// 当前界面正处于手势返回的过程中，可自行通过 gestureRecognizer.state 来区分手势返回的各个阶段。手势返回有多个阶段（手势返回开始、拖拽过程中、松手并成功返回、松手但不切换界面），不同阶段的 viewController 的状态可能不一样。
    ///
    /// - Parameters:
    ///   - navigationController: 当前正在手势返回的 QMUINavigationController，由于某些阶段下无法通过 vc.navigationController 获取到 nav 的引用，所以直接传一个参数
    ///   - poppingByInteractiveGestureRecognizer: 手势对象
    ///   - viewControllerWillDisppear: 手势返回中顶部的那个 vc
    ///   - viewControllerWillAppear: 手势返回中背后的那个 vc
    @objc optional func navigationController(_ navigationController: MMNavigationController,
                                             poppingByInteractiveGestureRecognizer: UIScreenEdgePanGestureRecognizer?,
                                             viewControllerWillDisppear: UIViewController?,
                                             viewControllerWillAppear: UIViewController?)
    
    @objc optional func willPopInNavigationController(_ animated: Bool)
    
    /// 在 self.navigationController 进行以下 4 个操作后，相应的 viewController 的 didPopInNavigationControllerWithAnimated: 方法会被调用：
    /// 1. popViewControllerAnimated:
    /// 2. popToViewController:animated:
    /// 3. popToRootViewControllerAnimated:
    /// 4. setViewControllers:animated:
    ///
    @objc optional func didPopInNavigationController(_ animated: Bool)
    
    /// 当通过 setViewControllers:animated: 来修改 viewController 的堆栈时，如果参数 viewControllers.lastObject 与当前的 self.viewControllers.lastObject 不相同，则意味着会产生界面的切换，这种情况系统会自动调用两个切换的界面的生命周期方法，但如果两者相同，则意味着并不会产生界面切换，此时之前就已经在显示的那个 viewController 的 viewWillAppear:、viewDidAppear: 并不会被调用，那如果用户确实需要在这个时候修改一些界面元素，则找不到一个时机。所以这个方法就是提供这样一个时机给用户修改界面元素。
    @objc optional func viewControllerKeepAppearWhenSetViewController(_ animated: Bool)
}

@objc protocol MMNavigationControllerAppearanceDelegate: class {
    
    /// 设置 titleView 的 tintColor
    @objc optional var titleViewTintColor: UIColor? { get }
    
    /// 设置导航栏的背景图，默认为 NavBarBackgroundImage
    @objc optional var navigationBarBackgroundImage: UIImage? { get }
    
    /// 设置导航栏底部的分隔线图片，默认为 NavBarShadowImage，必须在 navigationBar 设置了背景图后才有效（系统限制如此）
    @objc optional var navigationBarShadowImage: UIImage? { get }
    
    /// 设置当前导航栏的 barTintColor，默认为 NavBarBarTintColor
    @objc optional var navigationBarBarTintColor: UIColor? { get }
    
    /// 设置当前导航栏的 UIBarButtonItem 的 tintColor，默认为NavBarTintColor
    @objc optional var navigationBarTintColor: UIColor? { get }
    
    /// 设置系统返回按钮title，如果返回nil则使用系统默认的返回按钮标题
    @objc optional func backBarButtonTitle(with previousViewController: UIViewController?) -> String?
}


/// 控制 navigationBar 显隐/动画相关的方法
@objc protocol MMNavigationBarTransitionDelegate {
    
    /// 设置每个界面导航栏的显示/隐藏，为了减少对项目的侵入性，默认不开启这个接口的功能，只有当 shouldCustomizeNavigationBarTransitionIfHideable 返回 YES 时才会开启此功能。如果需要全局开启，那么就在 Controller 基类里面返回 YES；如果是老项目并不想全局使用此功能，那么则可以在单独的界面里面开启。
    @objc optional var preferredNavigationBarHidden: Bool { get }
    
    
    /// 当切换界面时，如果不同界面导航栏的显隐状态不同，可以通过 shouldCustomizeNavigationBarTransitionIfHideable
    /// 设置是否需要接管导航栏的显示和隐藏。从而不需要在各自的界面的 viewWillAppear 和 viewWillDisappear 里面去管理导航栏的状态。
    @objc optional var shouldCustomizeNavigationBarTransitionIfHideable: Bool { get }
    
    /// 自定义navBar效果过程中UINavigationController的containerView的背景色
    @objc optional var containerBackgroundColorWhenInTransitioning: UIColor { get }
}


protocol MMNavigationControllerDelegate: UINavigationControllerDelegate, MMNavigationControllerTransitionDelegate, MMNavigationControllerAppearanceDelegate, MMNavigationBarTransitionDelegate {
    
}

class _MMNavigationControllerDelegator: NSObject, MMNavigationControllerDelegate {
    weak var _navigationController: MMNavigationController?
    
}
