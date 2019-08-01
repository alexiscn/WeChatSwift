//
//  UIViewController+MMNavigationBar.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/1.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

extension UIViewController {
    
    private struct AssociatedKeys {
        static var useCustomNavigationBar = "useCustomNavigationBar"
        static var fakeNavigationBar = "fakeNavigationBar"
        static var useTransparentNavigationBar = "useTransparentNavigationBar"
    }
    
    
    var useFakeNavigationBar: Bool {
        if let faked = objc_getAssociatedObject(
            self,
            &AssociatedKeys.useCustomNavigationBar) as? Bool {
            return faked
        }
        let faked = false
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.useCustomNavigationBar,
            faked,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return faked
    }
    
    /// Whether navigation bar is transparent. Default to false.
    var useTransparentNavigationBar: Bool {
        if let transparent = objc_getAssociatedObject(
            self,
            &AssociatedKeys.useTransparentNavigationBar) as? Bool {
            return transparent
        }
        let transparent = false
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.useTransparentNavigationBar,
            transparent,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return transparent
    }
    
    var fakeNavigationBar: MMNavigationBar {
        if let bar = objc_getAssociatedObject(self, &AssociatedKeys.fakeNavigationBar) as? MMNavigationBar {
            return bar
        }
        let bar = MMNavigationBar()
        objc_setAssociatedObject(self, &AssociatedKeys.fakeNavigationBar, bar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return bar
    }
    
    static let methodSwizzling: Void = {
        swizzle(origin: #selector(UIViewController.viewWillDisappear(_:)), to: #selector(UIViewController.mm_viewWillDisappear(_:)))
        swizzle(origin: #selector(UIViewController.viewWillAppear(_:)), to: #selector(UIViewController.mm_viewWillAppear(_:)))
        swizzle(origin: #selector(UIViewController.viewDidAppear(_:)), to: #selector(UIViewController.mm_viewDidAppear(_:)))
    }()
    
    private static func swizzle(origin: Selector, to swizzled: Selector) {
        if let originMethod = class_getInstanceMethod(UIViewController.self, origin),
            let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzled) {
            method_exchangeImplementations(originMethod, swizzledMethod)
        }
    }
    
    @objc private func mm_viewWillAppear(_ animated: Bool) {
        mm_viewWillAppear(animated)
        
        
    }
    
    @objc private func mm_viewWillDisappear(_ animated: Bool) {
        mm_viewWillDisappear(animated)
        
        removeFakeNavigationBar()
        if let navigationController = navigationController as? MMNavigationController,
            navigationController.shouldAddFakeNavigationBar {
            addFakeNavigationBar()
        }
    }
    
    @objc private func mm_viewDidAppear(_ animated: Bool) {
        mm_viewDidAppear(animated)
        
        navigationController?.navigationBar.isUserInteractionEnabled = true
        
        if useFakeNavigationBar {
            
        } else {
            navigationController?.navigationBar.isTranslucent = true
        }
    }
    
    
    func addFakeNavigationBar() {
        
    }
    
    func removeFakeNavigationBar() {
        fakeNavigationBar.removeFromSuperview()
    }
}
