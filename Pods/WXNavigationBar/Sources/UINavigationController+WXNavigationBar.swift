//
//  UINavigationController+WXNavigationBar.swift
//  WXNavigationBar
//
//  Created by xushuifeng on 2020/2/28.
//

import UIKit

extension UINavigationController {
    
    private struct AssociatedKeys {
        static var gestureDelegate = "gestureDelegate"
        static var fullscreenPopGestureDelegate = "fullscreenPopGestureDelegate"
        static var fullscreenPopGestureRecognizer = "fullscreenPopGestureRecognizer"
        static var enableWXNavigationBar = "enableWXNavigationBar"
    }
    
    private var wx_gestureDelegate: WXNavigationGestureRecognizerDelegate? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.gestureDelegate) as? WXNavigationGestureRecognizerDelegate }
        set { objc_setAssociatedObject(self, &AssociatedKeys.gestureDelegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    private var wx_fullscreenPopGestureDelegate: WXFullscreenPopGestureRecognizerDelegate {
        if let delegate = objc_getAssociatedObject(self, &AssociatedKeys.fullscreenPopGestureDelegate) as? WXFullscreenPopGestureRecognizerDelegate {
            return delegate
        }
        let delegate = WXFullscreenPopGestureRecognizerDelegate(navigationController: self)
        objc_setAssociatedObject(self,
                                 &AssociatedKeys.fullscreenPopGestureDelegate,
                                 delegate,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return delegate
    }
    
    open var wx_fullscreenPopGestureRecognizer: UIPanGestureRecognizer {
        if let fullscreenPopGR = objc_getAssociatedObject(self, &AssociatedKeys.fullscreenPopGestureRecognizer) as? UIPanGestureRecognizer {
            return fullscreenPopGR
        }
        let fullscreenPopGR = UIPanGestureRecognizer()
        fullscreenPopGR.maximumNumberOfTouches = 1
        objc_setAssociatedObject(self,
                                 &AssociatedKeys.fullscreenPopGestureRecognizer,
                                 fullscreenPopGR,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return fullscreenPopGR
    }
    
    /// Enable WXNavigationBar on UINavigationController, `true` by default.
    /// You can use this property to specify special navigationController to not use WXNavigationBar.
    /// eg:
    /// let rootViewController = RootViewController()
    /// let rootNav = FLNavigationController(rootViewController: rootViewController)
    /// rootNav.wx_enableWXNavigationBar = false
    /// present(rootNav, animated: true)
    @objc open var wx_enableWXNavigationBar: Bool {
        get { return (objc_getAssociatedObject(self, &AssociatedKeys.enableWXNavigationBar) as? Bool) ?? true }
        set { objc_setAssociatedObject(self, &AssociatedKeys.enableWXNavigationBar, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    static let swizzleNavigationControllerOnce: Void = {
        let cls = UINavigationController.self
        swizzleMethod(cls, #selector(UINavigationController.pushViewController(_:animated:)), #selector(UINavigationController.wx_pushViewController(_:animated:)))
        swizzleMethod(cls, #selector(UINavigationController.setViewControllers(_:animated:)), #selector(UINavigationController.wx_setViewControllers(_:animated:)))
    }()
    
    func configureNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        wx_gestureDelegate = WXNavigationGestureRecognizerDelegate(navigationController: self)
        interactivePopGestureRecognizer?.delegate = wx_gestureDelegate
    }
    
    @objc private func wx_pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
            let backButtonItem: UIBarButtonItem
            if let customView = viewController.wx_backButtonCustomView {
                backButtonItem = UIBarButtonItem(customView: customView)
                let tap = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
                customView.isUserInteractionEnabled = true
                customView.addGestureRecognizer(tap)
            } else {
                let backImage = viewController.wx_backImage
                backButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonClicked))
            }
            viewController.navigationItem.leftBarButtonItem = backButtonItem
        }
        
        if viewController.wx_fullScreenInteractivePopEnabled {
            enableFullscreenPopGesture()
        }
        
        wx_pushViewController(viewController, animated: animated)
    }
    
    @objc private func wx_setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        
        if viewControllers.count > 1 {
            for (index, viewController) in viewControllers.enumerated() {
                if index != 0 {
                    viewController.hidesBottomBarWhenPushed = true
                    
                    let backButtonItem: UIBarButtonItem
                    if let customView = viewController.wx_backButtonCustomView {
                        backButtonItem = UIBarButtonItem(customView: customView)
                        let tap = UITapGestureRecognizer(target: self, action: #selector(backButtonClicked))
                        customView.isUserInteractionEnabled = true
                        customView.addGestureRecognizer(tap)
                    } else {
                        let backImage = viewController.wx_backImage
                        backButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonClicked))
                    }
                    viewController.navigationItem.leftBarButtonItem = backButtonItem
                }
                
                if viewController.wx_fullScreenInteractivePopEnabled {
                    enableFullscreenPopGesture()
                }
            }
        }
        
        wx_setViewControllers(viewControllers, animated: animated)
        
    }
    
    private func enableFullscreenPopGesture() {
        guard let gestureRecognizers = interactivePopGestureRecognizer?.view?.gestureRecognizers else {
            return
        }
        if !gestureRecognizers.contains(wx_fullscreenPopGestureRecognizer),
            let targets = interactivePopGestureRecognizer?.value(forKey: "targets") as? NSArray,
            let internalTarget = (targets.firstObject as? NSObject)?.value(forKey: "target") {
            let internalAction = NSSelectorFromString("handleNavigationTransition:")
            wx_fullscreenPopGestureRecognizer.delegate = wx_fullscreenPopGestureDelegate
            wx_fullscreenPopGestureRecognizer.addTarget(internalTarget, action: internalAction)
            interactivePopGestureRecognizer?.isEnabled = false
            interactivePopGestureRecognizer?.view?.addGestureRecognizer(wx_fullscreenPopGestureRecognizer)
        }
    }
    
    @objc private func backButtonClicked() {
        topViewController?.wx_backButtonClicked()
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
}

fileprivate class WXNavigationGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    
    fileprivate weak var navigationController: UINavigationController?
    
    fileprivate init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigationController = navigationController else {
            return true
        }
        if let topViewController = navigationController.viewControllers.last {
            if topViewController.wx_disableInteractivePopGesture {
                return false
            }
        }
        return true
    }
}

/// https://github.com/forkingdog/FDFullscreenPopGesture
fileprivate class WXFullscreenPopGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    
    fileprivate weak var navigationController: UINavigationController?
    
    fileprivate init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard let navigationController = navigationController,
            let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        
        // Ignore when no view controller is pushed into the navigation stack.
        if navigationController.viewControllers.count <= 1 {
            return false
        }
        
        // Ignore when the active view controller doesn't allow interactive pop.
        if let topViewController = navigationController.viewControllers.last {
            if !topViewController.wx_fullScreenInteractivePopEnabled {
                return false
            }
        }
        
        // Ignore when the beginning location is beyond max allowed initial distance to left edge.
        if let topViewController = navigationController.viewControllers.last {
            let beganPoint = gestureRecognizer.location(in: gestureRecognizer.view)
            let maxAllowedDistance = topViewController.wx_interactivePopMaxAllowedDistanceToLeftEdge
            if maxAllowedDistance > 0 && beganPoint.x > maxAllowedDistance {
                return false
            }
        }

        // Ignore pan gesture when the navigation controller is currently in transition.
        let isTransitioning = navigationController.value(forKey: "_isTransitioning") as? Bool ?? false
        if isTransitioning {
            return false
        }

        // Prevent calling the handler when the gesture begins in an opposite direction.
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view)
        let isLeftToRight = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
        let multiplier: CGFloat = isLeftToRight ? 1: -1
        if translation.x * multiplier <= 0 {
            return false
        }
        return true
    }
}
