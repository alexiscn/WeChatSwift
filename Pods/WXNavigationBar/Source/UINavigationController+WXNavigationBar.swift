//
//  UINavigationController+WXNavigationBar.swift
//  WXNavigationBar
//
//  Created by xushuifeng on 2020/2/28.
//

import UIKit

fileprivate class _WXNavigationGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    
    fileprivate weak var navigationController: UINavigationController?
    
    fileprivate init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension UINavigationController {
    
    private struct AssociatedKeys {
        static var gestureDelegate = "WXNavigationBar_gestureDelegate"
    }
    
    private var wx_gestureDelegate: _WXNavigationGestureRecognizerDelegate? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.gestureDelegate) as? _WXNavigationGestureRecognizerDelegate
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.gestureDelegate,
                                     newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    static let wx_navswizzle: Void = {
        let cls = UINavigationController.self
        swizzleMethod(cls, #selector(UINavigationController.viewDidLoad), #selector(UINavigationController.mm_viewDidLoad))
        swizzleMethod(cls, #selector(UINavigationController.pushViewController(_:animated:)), #selector(UINavigationController.wx_pushViewController(_:animated:)))
    }()
    
    @objc open func mm_viewDidLoad() {
        
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        wx_gestureDelegate = _WXNavigationGestureRecognizerDelegate(navigationController: self)
        self.interactivePopGestureRecognizer?.delegate = wx_gestureDelegate
        
        mm_viewDidLoad()
    }
    
    @objc private func wx_pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let backImage = viewController.wx_backImage
            let backButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonClicked))
            viewController.navigationItem.leftBarButtonItem = backButtonItem
        }
        
        wx_pushViewController(viewController, animated: animated)
    }
    
    @objc private func backButtonClicked() {
        popViewController(animated: true)
    }
}
