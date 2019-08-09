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
    var wc_navigationBarBackgroundColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.barBackgroundColor) as? UIColor ?? Colors.DEFAULT_BACKGROUND_COLOR
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.barBackgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    static let swizzle: Void = {
        let cls = UIViewController.self
        swizzleMethod(cls, #selector(UIViewController.viewDidLoad), #selector(UIViewController.wc_viewDidLoad))
        swizzleMethod(cls, #selector(UIViewController.viewWillLayoutSubviews), #selector(UIViewController.wc_viewWillLayoutSubviews))
        swizzleMethod(cls, #selector(UIViewController.viewWillAppear(_:)), #selector(UIViewController.wc_viewWillAppear(_:)))
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
            view.bringSubviewToFront(wc_navigationBar)
        }
        wc_viewWillAppear(animated)
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

//extension UIApplication {
//    open override var next: UIResponder? {
//        
//        return super.next
//    }
//}
