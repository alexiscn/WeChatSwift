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

/// https://github.com/forkingdog/FDFullscreenPopGesture
fileprivate class _WXFullscreenPopGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    
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
            if !topViewController.wx_interactivePopEnabled {
                return false
            }
        }
        
        // Ignore when the beginning location is beyond max allowed initial distance to left edge.
        if let topViewController = navigationController.viewControllers.last {
            let beganPoint = gestureRecognizer.location(in: gestureRecognizer.view)
            let maxAllowedInitialDistance = topViewController.wx_interactivePopMaxAllowedInitialDistanceToLeftEdge
            if maxAllowedInitialDistance > 0 && beganPoint.x > maxAllowedInitialDistance {
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

extension UINavigationController {
    
    private struct AssociatedKeys {
        static var gestureDelegate = "WXNavigationBar_gestureDelegate"
        static var fullscreenPopGestureDelegate = "WXNavigationBar_fullscreenPopGestureDelegate"
        static var fullscreenPopGestureRecognizer = "WXNavigationBar_fullscreenPopGestureRecognizer"
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
    
    private var wx_fullscreenPopGestureDelegate: _WXFullscreenPopGestureRecognizerDelegate {
        if let fullscreenPopGestureDelegate = objc_getAssociatedObject(self, &AssociatedKeys.fullscreenPopGestureDelegate) as? _WXFullscreenPopGestureRecognizerDelegate {
            return fullscreenPopGestureDelegate
        }
        let fullscreenPopGestureDelegate = _WXFullscreenPopGestureRecognizerDelegate(navigationController: self)
        objc_setAssociatedObject(self,
                                 &AssociatedKeys.fullscreenPopGestureDelegate,
                                 fullscreenPopGestureDelegate,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return fullscreenPopGestureDelegate
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
    
    static let wx_navswizzle: Void = {
        let cls = UINavigationController.self
        swizzleMethod(cls, #selector(UINavigationController.pushViewController(_:animated:)), #selector(UINavigationController.wx_pushViewController(_:animated:)))
        //swizzleMethod(cls, #selector(UINavigationController.popViewController(animated:)), <#T##newSelector: Selector##Selector#>)
    }()
    
    func configureNavigationBar() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        wx_gestureDelegate = _WXNavigationGestureRecognizerDelegate(navigationController: self)
        interactivePopGestureRecognizer?.delegate = wx_gestureDelegate
    }
    
    @objc private func wx_pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            let backImage = viewController.wx_backImage
            let backButtonItem = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonClicked))
            viewController.navigationItem.leftBarButtonItem = backButtonItem
        }
        
        if viewController.wx_interactivePopEnabled {
            enableFullscreenPopGesture()
        }
        
        wx_pushViewController(viewController, animated: animated)
    }
    
    private func enableFullscreenPopGesture() {
        if let gestureRecognizers = interactivePopGestureRecognizer?.view?.gestureRecognizers {
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
    }
    
    @objc private func backButtonClicked() {
        popViewController(animated: true)
    }
    
    open override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
}
