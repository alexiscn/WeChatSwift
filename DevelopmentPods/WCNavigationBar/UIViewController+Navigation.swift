//
//  UIViewController+Navigation.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/1.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var wc_navigationBar: NavigationBar {
        if let bar = objc_getAssociatedObject(self, &NavigationConstants.Keys.navigationBar) as? NavigationBar {
            return bar
        }
        let bar = NavigationBar(viewController: self)
        objc_setAssociatedObject(self, &NavigationConstants.Keys.navigationBar, bar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return bar
    }
    
    var wc_navigationItem: UINavigationItem {
        if let item = objc_getAssociatedObject(self, &NavigationConstants.Keys.navigationItem) as? UINavigationItem {
            return item
        }
        let item = UINavigationItem()
        item.title = navigationItem.title
        item.prompt = navigationItem.prompt
        
        objc_setAssociatedObject(self, &NavigationConstants.Keys.navigationItem, item, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return item
    }
    
    static let methodSwizzling: Void = {
        swizzle(origin: #selector(UIViewController.viewDidLoad), to: #selector(UIViewController.wc_viewDidLoad))
        swizzle(origin: #selector(UIViewController.viewWillAppear(_:)), to: #selector(UIViewController.wc_viewWillAppear(_:)))
        swizzle(origin: #selector(UIViewController.viewDidLayoutSubviews), to: #selector(UIViewController.wc_viewDidLayoutSubviews))
        swizzle(origin: #selector(UIViewController.setNeedsStatusBarAppearanceUpdate), to: #selector(UIViewController.wc_setNeedsStatusBarAppearanceUpdate))
    }()
    
    private static func swizzle(origin: Selector, to swizzled: Selector) {
        if let originMethod = class_getInstanceMethod(UIViewController.self, origin),
            let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzled) {
            method_exchangeImplementations(originMethod, swizzledMethod)
        }
    }
    
    @objc private func wc_viewDidLoad() {
        wc_viewDidLoad()
        
        guard NavigationBar.enabled else { return }
        
        guard let navigationController = navigationController else { return }
        
        navigationController.sendNavigationBarToBack()
        wc_navigationBar.prefersLargeTitles = navigationController.navigationBar.prefersLargeTitles
        
        setupBackBarButtonItem(navigationController)
        
        wc_navigationBar.configure(style: navigationController.wc_style)
        
        view.addSubview(wc_navigationBar)
        
        if let tableViewController = self as? UITableViewController {
            tableViewController.observeContentOffset()
        }
    }
    
    @objc private func wc_viewWillAppear(_ animated: Bool) {
        wc_viewWillAppear(animated)
        
        guard NavigationBar.enabled else { return }
        
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        navigationBar.isHidden = wc_navigationBar.isHidden
        adjustSafeAreaInsets()
        navigationItem.title = wc_navigationItem.title
        navigationBar.largeTitleTextAttributes = wc_navigationBar.largeTitleTextAttributes
        view.bringSubviewToFront(wc_navigationBar)
    }
    
    @objc private func wc_viewDidLayoutSubviews() {
        wc_viewDidLayoutSubviews()
        guard NavigationBar.enabled else { return }
        view.bringSubviewToFront(wc_navigationBar)
    }
    
    @objc private func wc_setNeedsStatusBarAppearanceUpdate() {
        wc_setNeedsStatusBarAppearanceUpdate()
        guard NavigationBar.enabled else { return }
        
        wc_navigationBar.adjustLayout()
        wc_navigationBar.setNeedsLayout()
    }
    
    private func setupBackBarButtonItem(_ navigationController: UINavigationController) {
        let count = navigationController.viewControllers.count
        guard count > 1 else { return }
        
//        let backImage = UIImage.SVGImage(named: "icons_filled_back")
//        let backButton = BackBarButtonItem(style: .image(backImage))
//        backButton.navigationController = navigationController
//        wc_navigationBar.backBarButtonItem = backButton
    }
    
    func adjustSafeAreaInsets() {
        //let height = _navigationBar.additionalView?.frame.height ?? 0
        additionalSafeAreaInsets.top = wc_navigationBar.isHidden
            ? -view.safeAreaInsets.top
            : wc_navigationBar._additionalHeight //+ height
    }
}
