//
//  MMNavigationController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/1.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class MMNavigationController: UINavigationController, UINavigationControllerDelegate {
    
    var shouldAddFakeNavigationBar = false
    
    override init(rootViewController: UIViewController) {
        super.init(navigationBarClass: MMNavigationBar.classForCoder(), toolbarClass: nil)
        self.setViewControllers([rootViewController], animated: false)
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.isTranslucent = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        super.setNavigationBarHidden(hidden, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        
        if viewControllers.count > 1, let currentVC = viewControllers.last {
            let previousVC = viewControllers[viewControllers.count - 2]
            
            if !currentVC.useFakeNavigationBar && !previousVC.useFakeNavigationBar {
                shouldAddFakeNavigationBar = false
            } else {
                shouldAddFakeNavigationBar = true
            }
        }
        
        return super.popViewController(animated: animated)
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return nil
    }
    
    func layoutViewForBar() {
        
    }
}
