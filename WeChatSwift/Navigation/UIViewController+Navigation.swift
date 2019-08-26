//
//  UIViewController+Navigation.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

extension UIViewController {
    
    private struct AssociatedKeys {
        static var barBackgroundColor = "barBackgroundColor"
        static var fakeNavigationBar = "fakeNavigationBar"
        static var barBarTintColor = "barBarTintColor"
        static var barTintColor = "barTintColor"
        static var titleTextAttributes = "titleTextAttributes"
    }
    
    /// Fake NavigationBar
    var wc_navigationBar: UIView {
        if let bar = objc_getAssociatedObject(self, &AssociatedKeys.fakeNavigationBar) as? UIView {
            return bar
        }
        let bar = UIView()
        objc_setAssociatedObject(self, &AssociatedKeys.fakeNavigationBar, bar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return bar
    }
    
    /// Setting background color of Fake NavigationBar
    @objc var wc_navigationBarBackgroundColor: UIColor? {
        if let color = objc_getAssociatedObject(self, &AssociatedKeys.barBackgroundColor) as? UIColor {
            return color
        }
        let color = Colors.DEFAULT_BACKGROUND_COLOR
        objc_setAssociatedObject(self, &AssociatedKeys.barBackgroundColor, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return color
    }
    
    @objc var wc_barBarTintColor: UIColor? {
        if let barBarTintColor = objc_getAssociatedObject(self, &AssociatedKeys.barBarTintColor) as? UIColor {
            return barBarTintColor
        }
        objc_setAssociatedObject(self, &AssociatedKeys.barBarTintColor, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return nil
//        let barBarTintColor = Colors.black
//        objc_setAssociatedObject(self, &AssociatedKeys.barBarTintColor, barBarTintColor, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//        return barBarTintColor
    }
    
    @objc var wc_barTintColor: UIColor? {
        if let tintColor = objc_getAssociatedObject(self, &AssociatedKeys.barTintColor) as? UIColor {
            return tintColor
        }
        let tintColor = UIColor(hexString: "#181818")
        objc_setAssociatedObject(self, &AssociatedKeys.barTintColor, tintColor, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return tintColor
    }
    
    @objc var wc_titleTextAttributes: [NSAttributedString.Key: Any]? {
        if let attributes = objc_getAssociatedObject(self, &AssociatedKeys.titleTextAttributes) as? [NSAttributedString.Key: Any] {
            return attributes
        }
        objc_setAssociatedObject(self, &AssociatedKeys.titleTextAttributes, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return nil
    }
    
    static let swizzle: Void = {
        let cls = UIViewController.self
        swizzleMethod(cls, #selector(UIViewController.viewDidLoad), #selector(UIViewController.wc_viewDidLoad))
        swizzleMethod(cls, #selector(UIViewController.viewWillLayoutSubviews), #selector(UIViewController.wc_viewWillLayoutSubviews))
        swizzleMethod(cls, #selector(UIViewController.viewWillAppear(_:)), #selector(UIViewController.wc_viewWillAppear(_:)))
        swizzleMethod(cls, #selector(UIViewController.viewDidAppear(_:)), #selector(UIViewController.wc_viewDidAppear(_:)))
    }()
    
    @objc private func wc_viewDidLoad() {
        
        if navigationController != nil {
            wc_navigationBar.backgroundColor = wc_navigationBarBackgroundColor
            view.addSubview(wc_navigationBar)
        }
        
        wc_viewDidLoad()
    }
    
    @objc private func wc_viewWillLayoutSubviews() {
        if navigationController != nil {
            let navigationBarHeight: CGFloat = Constants.iPhoneX ? 88: 64 // TODO
            wc_navigationBar.frame = CGRect(origin: .zero, size: CGSize(width: Constants.screenWidth, height: navigationBarHeight))
        }
        wc_viewWillLayoutSubviews()
    }
    
    @objc private func wc_viewWillAppear(_ animated: Bool) {
        if navigationController != nil {
            navigationController?.navigationBar.barTintColor = wc_barBarTintColor
            navigationController?.navigationBar.tintColor = wc_barTintColor
            navigationController?.navigationBar.titleTextAttributes = wc_titleTextAttributes
            view.bringSubviewToFront(wc_navigationBar)
        }
        wc_viewWillAppear(animated)
    }
    
    
    @objc private func wc_viewDidAppear(_ animated: Bool) {
        // 修正在TabBarController中使用了返回了手势，导致Push卡死的现象
        // 当导航栏中只有一个ViewController时禁用返回手势
        if let navigationController = self.navigationController {
            navigationController.interactivePopGestureRecognizer?.isEnabled = navigationController.viewControllers.count > 1
        }
        wc_viewDidAppear(animated)
    }
}

func swizzleMethod(_ cls: AnyClass, _ originSelector: Selector, _ newSelector: Selector) {
    guard let oriMethod = class_getInstanceMethod(cls, originSelector),
        let newMethod = class_getInstanceMethod(cls, newSelector) else {
            return
    }
    
    let isAddedMethod = class_addMethod(cls, originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))
    if isAddedMethod {
        class_replaceMethod(cls, newSelector, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod))
    } else {
        method_exchangeImplementations(oriMethod, newMethod)
    }
}


extension UIViewController {
    
    func wc_doneBarButton(title: String = "完成") -> UIButton {
        let doneButton = UIButton(type: .system)
        doneButton.layer.cornerRadius = 5
        doneButton.layer.masksToBounds = true
        doneButton.frame.size = CGSize(width: 56, height: 30)
        doneButton.backgroundColor = Colors.Brand
        doneButton.setBackgroundImage(UIImage(color: Colors.Brand_120), for: .disabled)
        doneButton.setBackgroundImage(UIImage(color: Colors.Brand), for: .normal)
        doneButton.setTitle(title, for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return doneButton
    }
    
}
