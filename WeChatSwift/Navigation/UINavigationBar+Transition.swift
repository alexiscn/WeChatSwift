//
//  UINavigationBar+Transition.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/6.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

struct NavigationConstants {
    static var key_transitionNavigationBar = "wechat_transitionNavigationBar"
}

extension UINavigationBar {
    
    var transitionNavigationBar: UINavigationBar? {
        if let navigationBar = objc_getAssociatedObject(
            self,
            &NavigationConstants.key_transitionNavigationBar) as? UINavigationBar {
            return navigationBar
        }
        objc_setAssociatedObject(
            self,
            &NavigationConstants.key_transitionNavigationBar,
            nil,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return nil
    }
    
    static let methodSwizzling: Void = {
        swizzle(origin: #selector(getter: UINavigationBar.shadowImage), to: #selector(UINavigationBar.wc_setShadowImage(_:)))
        swizzle(origin: #selector(getter: UINavigationBar.barTintColor), to: #selector(UINavigationBar.wc_setBarTintColor(_:)))
        swizzle(origin: #selector(UINavigationBar.setBackgroundImage(_:for:)), to: #selector(UINavigationBar.wc_setBackgroundImage(_:for:)))
    }()
    
    private static func swizzle(origin: Selector, to swizzled: Selector) {
        if let originMethod = class_getInstanceMethod(UIViewController.self, origin),
            let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzled) {
            method_exchangeImplementations(originMethod, swizzledMethod)
        }
    }
    
    @objc private func wc_setShadowImage(_ image: UIImage?) {
        transitionNavigationBar?.shadowImage = image
        wc_setShadowImage(image)
    }
    
    @objc private func wc_setBarTintColor(_ tintColor: UIColor) {
        transitionNavigationBar?.barTintColor = tintColor
        wc_setBarTintColor(tintColor)
    }
    
    
    @objc private func wc_setBackgroundImage(_ backgroundImage: UIImage?, for barMetrics: UIBarMetrics) {
        transitionNavigationBar?.setBackgroundImage(backgroundImage, for: barMetrics)
        wc_setBackgroundImage(backgroundImage, for: barMetrics)
    }
    
    var wc_backgroundView: UIView? {
        return value(forKey: "_backgroundView") as? UIView
    }
}
