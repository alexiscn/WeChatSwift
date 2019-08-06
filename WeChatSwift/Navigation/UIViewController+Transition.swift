//
//  UIViewController+Transition.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/6.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

func MethodSwizzle(_ cls: AnyClass, fromMethod: Selector, toMethod: Selector) {
    if let origin = class_getInstanceMethod(cls, fromMethod),
        let swizzle = class_getInstanceMethod(cls, toMethod) {
        method_exchangeImplementations(origin, swizzle)
    }
}

class WCNavigationBar: UINavigationBar {
    override func layoutSubviews() {
        super.layoutSubviews()
        wc_backgroundView?.frame = bounds
    }
}

extension UIViewController {
    
    var transitionNavigationBar: WCNavigationBar? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.transitionNavigationBar) as? WCNavigationBar }
        set { objc_setAssociatedObject(self, &AssociatedKeys.transitionNavigationBar, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var lockTransitionNavigationBar: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.lockTransitionNavigationBar) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &AssociatedKeys.lockTransitionNavigationBar, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    var originContainerViewBackgroundColor: UIColor? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.originContainerViewBackgroundColor) as? UIColor }
        set { objc_setAssociatedObject(self, &AssociatedKeys.originContainerViewBackgroundColor, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var prefersNavigationBarBackgroundViewHidden: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.prefersNavigationBarBackgroundViewHidden) as? Bool ?? false }
        set {
            navigationController?.navigationBar.wc_backgroundView?.layer.mask = newValue ? CALayer(): nil
            objc_setAssociatedObject(self, &AssociatedKeys.prefersNavigationBarBackgroundViewHidden, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    static let methodSwizzling: Void = {
        MethodSwizzle(
            UIViewController.classForCoder(),
            fromMethod: #selector(UIViewController.viewWillAppear(_:)),
            toMethod: #selector(UIViewController.wc_viewWillAppear(_:)))
        
        MethodSwizzle(
            UIViewController.classForCoder(),
            fromMethod: #selector(UIViewController.viewDidAppear(_:)),
            toMethod: #selector(UIViewController.wc_viewDidAppear(_:)))

        MethodSwizzle(
            UIViewController.classForCoder(),
            fromMethod: #selector(UIViewController.viewDidDisappear(_:)),
            toMethod: #selector(UIViewController.wc_viewDidDisappear(_:)))

        MethodSwizzle(
            UIViewController.classForCoder(),
            fromMethod: #selector(UIViewController.viewWillLayoutSubviews),
            toMethod: #selector(UIViewController.wc_viewWillLayoutSubviews))
    }()
    
    @objc private func wc_viewWillAppear(_ animated: Bool) {
        renderNavigationStyle(in: self, animated: animated)
        
        wc_viewWillAppear(animated)
    }
    
    @objc private func wc_viewDidAppear(_ animated: Bool) {
        
        self.lockTransitionNavigationBar = true
        
        if let bar = self.transitionNavigationBar, let originBar = self.navigationController?.navigationBar {
            UIViewController.copyStyle(from: originBar, to: bar)
            removeTransitionNavigationBar()
            self.transitionCoordinator?.containerView.backgroundColor = originContainerViewBackgroundColor
        }
        
        if let viewControllers = navigationController?.viewControllers, viewControllers.contains(self) {
            prefersNavigationBarBackgroundViewHidden = false
        }
        
        wc_viewDidAppear(animated)
    }
    
    @objc private func wc_viewDidDisappear(_ animated: Bool) {
        lockTransitionNavigationBar = false
        transitionNavigationBar?.removeFromSuperview()
        wc_viewDidDisappear(animated)
    }
    
    @objc private func wc_viewWillLayoutSubviews() {
        
    }
    
    private func addTransitionNavigationBarIfNeeded() {
        guard let navigationController = self.navigationController else {
            return
        }
        
        let navigationBar = navigationController.navigationBar
        
        let fakeBar = WCNavigationBar()
        fakeBar.barStyle = navigationBar.barStyle
        fakeBar.isTranslucent = navigationBar.isTranslucent
        fakeBar.barTintColor = navigationBar.barTintColor
        fakeBar.shadowImage = navigationBar.shadowImage
        let backgroundImage = navigationBar.backgroundImage(for: .default)
        if let backgroundImage = backgroundImage, backgroundImage.size == .zero {
            print("Background Image Size Zero")
        }
        fakeBar.setBackgroundImage(backgroundImage, for: .default)
        self.transitionNavigationBar = fakeBar
        resizeNavigationBarFrame()
        if !navigationController.isNavigationBarHidden {
            self.view.addSubview(fakeBar)
        }
    }
    
    private func removeTransitionNavigationBar() {
        self.transitionNavigationBar?.removeFromSuperview()
        self.transitionNavigationBar = nil
    }
    
    private func resizeNavigationBarFrame() {
        guard let backgroundView = navigationController?.navigationBar.wc_backgroundView else {
            return
        }
        if let rect = backgroundView.superview?.convert(backgroundView.frame, to: self.view) {
            self.transitionNavigationBar?.frame = rect
        }
    }
    
    private func renderNavigationStyle(in viewController: UIViewController, animated: Bool) {
        guard let navigationController = viewController.navigationController else { return }
        if !navigationController.viewControllers.contains(viewController) {
            return
        }
    }
    
    static func copyStyle(from navbarA: UINavigationBar, to navbarB: UINavigationBar) {
        navbarB.barStyle = navbarA.barStyle
        navbarB.barTintColor = navbarA.barTintColor
        navbarB.shadowImage = navbarA.shadowImage
        navbarB.setBackgroundImage(navbarA.backgroundImage(for: .default), for: .default)
    }
}
