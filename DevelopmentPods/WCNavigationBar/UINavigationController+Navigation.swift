//
//  UINavigationController+Navigation.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/1.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    var wc_style: NavigationStyle {
        if let style = objc_getAssociatedObject(self, &NavigationConstants.Keys.navigationStyle) as? NavigationStyle {
            return style
        }
        let style = NavigationStyle()
        objc_setAssociatedObject(self, &NavigationConstants.Keys.navigationStyle, style, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return style
    }
    
    //    @_dynamicReplacement(for: viewDidLoad())
    //    func wc_viewDidLoad() {
    //    }
    
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard NavigationBar.enabled else { return }
        sendNavigationBarToBack()
        
        guard let bar = topViewController?.wc_navigationBar else { return }
        isNavigationBarHidden = false
        navigationBar.isHidden = bar.isHidden
        bar.adjustLayout()
        topViewController?.adjustSafeAreaInsets()
    }
    
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard NavigationBar.enabled else { return }
        if let tabBarController = topViewController as? UITabBarController {
            tabBarController.selectedViewController?.wc_navigationBar.adjustLayout()
        } else {
            topViewController?.wc_navigationBar.adjustLayout()
        }
    }
    
    func sendNavigationBarToBack() {
        navigationBar.tintColor = .clear
        if navigationBar.shadowImage == nil {
            let image = UIImage()
            navigationBar.setBackgroundImage(image, for: .default)
            navigationBar.shadowImage = image
            navigationBar.backIndicatorImage = image
            navigationBar.backIndicatorTransitionMaskImage = image
        }
        view.sendSubviewToBack(navigationBar)
    }
}
