//
//  WCNavigationController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/23.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import AsyncDisplayKit

/*
class WCNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage.imageFromColor(Colors.DEFAULT_BACKGROUND_COLOR)
        
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        navigationBar.setBackgroundImage(backgroundImage, for: .default)
        navigationBar.backIndicatorImage = UIImage.SVGImage(named: "icons_outlined_back")
        navigationBar.backIndicatorTransitionMaskImage = UIImage.SVGImage(named: "icons_outlined_back")
    }
}

fileprivate class MMNavigationGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    fileprivate weak var navigationController: MMNavigationController?
    fileprivate init(navigationController: MMNavigationController) {
        self.navigationController = navigationController
    }
}

//ASNavigationController
class MMNavigationController: UINavigationController {
    
    private var gestureDelegate: MMNavigationGestureRecognizerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        gestureDelegate = MMNavigationGestureRecognizerDelegate(navigationController: self)
        self.interactivePopGestureRecognizer?.delegate = gestureDelegate
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let backButtonItem = UIBarButtonItem(image: Constants.backImage, style: .plain, target: self, action: #selector(backButtonClicked))
            viewController.navigationItem.leftBarButtonItem = backButtonItem
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func backButtonClicked() {
        popViewController(animated: true)
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
*/
