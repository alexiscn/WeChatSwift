//
//  MMNavigationController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/6.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import AsyncDisplayKit

/// Port from QMUI
/// https://github.com/tencent/QMUI_iOS

class MMNavigationController: ASNavigationController, UIGestureRecognizerDelegate, MM_viewWillAppearNotifyDelegate {
    
    private var delegator: _MMNavigationControllerDelegator!
    private var viewControllerPopping: UIViewController?
    private var isViewControllerTransiting: Bool = false
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        commonInit()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        delegator = _MMNavigationControllerDelegator()
        delegator._navigationController = self
        self.delegate = delegator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.addTarget(self, action: #selector(handleInteractiveGestureRecognizer(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if viewControllers.count < 2 {
            return super.popViewController(animated: animated)
        }
        var viewController = self.topViewController
        
        viewControllerPopping = viewController
        if animated {
            self.viewControllerPopping?.mm_viewWillAppearNotifyDelegate = self
            self.isViewControllerTransiting = true
        }
        
        let viewControllerTransitionDelegate = viewController as? MMNavigationControllerTransitionDelegate
        viewControllerTransitionDelegate?.willPopInNavigationController?(animated)
        viewController = super.popViewController(animated: animated)
        viewControllerTransitionDelegate?.didPopInNavigationController?(animated)
        return viewController
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if self.topViewController == viewController {
            return super.popToViewController(viewController, animated: animated)
        }
        
        viewControllerPopping = self.topViewController
        if animated {
            self.viewControllerPopping?.mm_viewWillAppearNotifyDelegate = self
            self.isViewControllerTransiting = true
        }
        let poppedViewControllers = super.popToViewController(viewController, animated: animated)
        return poppedViewControllers
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        // 在配合 tabBarItem 使用的情况下，快速重复点击相同 item 可能会重复调用 popToRootViewControllerAnimated:，而此时其实已经处于 rootViewController 了，就没必要继续走后续的流程，否则一些变量会得不到重置。
        if self.topViewController == self.viewControllers.first {
            return nil
        }
        self.viewControllerPopping = self.topViewController
        if animated {
            self.viewControllerPopping?.mm_viewWillAppearNotifyDelegate = self
            self.isViewControllerTransiting = true
        }
        
        for i in (1 ..< (self.viewControllers.count)).reversed() {
            let viewControllerPopping = self.viewControllers[i]
            let viewControllerPoppingTransitionDelegate = viewControllerPopping as? MMNavigationControllerTransitionDelegate
            // 只有当前可视的那个 viewController 的 animated 是跟随参数走的，其他 viewController 由于不可视，不管参数的值为多少，都认为是无动画地 pop
            let isAnimated = i == self.viewControllers.count - 1
            viewControllerPoppingTransitionDelegate?.willPopInNavigationController?(isAnimated)
        }
        
        let poppedViewControllers = super.popToRootViewController(animated: animated)
        
        for i in (0 ..< (self.viewControllers.count)).reversed() {
            let viewControllerPopping = self.viewControllers[i]
            let viewControllerPoppingTransitionDelegate = viewControllerPopping as? MMNavigationControllerTransitionDelegate
            // 只有当前可视的那个 viewController 的 animated 是跟随参数走的，其他 viewController 由于不可视，不管参数的值为多少，都认为是无动画地 pop
            let isAnimated = i == self.viewControllers.count - 1
            viewControllerPoppingTransitionDelegate?.didPopInNavigationController?(isAnimated)
        }
        
        return poppedViewControllers
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
//        let topViewController = self.topViewController
//
//        let viewControllersPopping = self.viewControllers
        
        // TODO
        
        super.setViewControllers(viewControllers, animated: animated)
        
        // TODO
    
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if isViewControllerTransiting {
            return
        }
        
        if self.presentedViewController == nil && animated {
            isViewControllerTransiting = true
        }
        
        let currentViewController = self.topViewController
        if currentViewController != nil {
            currentViewController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        super.pushViewController(viewController, animated: animated)
        
        if viewControllers.contains(viewController) {
            isViewControllerTransiting = false
        }
    }
    
    @objc private func handleInteractiveGestureRecognizer(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let state = gestureRecognizer.state
        
        var viewControllerWillDisappear = self.viewControllerPopping
        var viewControllerWillAppear = self.topViewController
        
        viewControllerWillDisappear?.mm_poppingByInteractivePopGestureRecognizer = true
        viewControllerWillDisappear?.mm_willAppearByInteractivePopGestureRecognizer = false
        
        viewControllerWillAppear?.mm_poppingByInteractivePopGestureRecognizer = false
        viewControllerWillAppear?.mm_willAppearByInteractivePopGestureRecognizer = true
        
        if state == .began {
            DispatchQueue.main.async {
                viewControllerWillDisappear?.mm_navigationControllerPopGestureRecognizerChanging = true
                viewControllerWillAppear?.mm_navigationControllerPopGestureRecognizerChanging = true
            }
        } else if state.rawValue > UIGestureRecognizer.State.changed.rawValue {
            viewControllerWillDisappear?.mm_navigationControllerPopGestureRecognizerChanging = false
            viewControllerWillAppear?.mm_navigationControllerPopGestureRecognizerChanging = false
        }
        
        if state == .ended {
            if (self.topViewController?.view.superview?.frame.minX ?? 0.0) < 0 {
                viewControllerWillDisappear = self.topViewController
                viewControllerWillAppear = self.viewControllerPopping
                print("手势返回放弃了")
            } else {
                print("执行手势返回")
            }
        }
        
        let viewControllerWillDisappearTransitionDelegate = viewControllerWillDisappear as? MMNavigationControllerTransitionDelegate
        viewControllerWillDisappearTransitionDelegate?.navigationController?(self, poppingByInteractiveGestureRecognizer: gestureRecognizer, viewControllerWillDisppear: viewControllerWillDisappear, viewControllerWillAppear: viewControllerWillAppear)
        
        let viewControllerWillAppearTransitionDelegate = viewControllerWillAppear as? MMNavigationControllerTransitionDelegate
        viewControllerWillAppearTransitionDelegate?.navigationController?(self, poppingByInteractiveGestureRecognizer: gestureRecognizer, viewControllerWillDisppear: viewControllerWillDisappear, viewControllerWillAppear: viewControllerWillAppear)
    }
    
    override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    func mm_viewControllerDidInvokeViewWillAppear(_ viewController: UIViewController) {
        viewController.mm_viewWillAppearNotifyDelegate = nil
        // TODO:
//        if let poppingViewController = self.viewControllerPopping {
//            delegator.navigationController(self, willShow: poppingViewController, animated: true)
//        }
        viewControllerPopping = nil
        isViewControllerTransiting = false
    }
}


protocol MM_viewWillAppearNotifyDelegate: class {
    func mm_viewControllerDidInvokeViewWillAppear(_ viewController: UIViewController)
}

extension UIViewController {
    
    var mm_navigationControllerPopGestureRecognizerChanging: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.navigationControllerPopGestureRecognizerChanging) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &AssociatedKeys.navigationControllerPopGestureRecognizerChanging, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var mm_poppingByInteractivePopGestureRecognizer: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.poppingByInteractivePopGestureRecognizer) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &AssociatedKeys.poppingByInteractivePopGestureRecognizer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    var mm_willAppearByInteractivePopGestureRecognizer: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.willAppearByInteractivePopGestureRecognizer) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &AssociatedKeys.willAppearByInteractivePopGestureRecognizer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    weak var mm_viewWillAppearNotifyDelegate: MM_viewWillAppearNotifyDelegate? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.viewWillAppearNotifyDelegate) as? MM_viewWillAppearNotifyDelegate }
        set { objc_setAssociatedObject(self, &AssociatedKeys.viewWillAppearNotifyDelegate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

struct AssociatedKeys {
    
    static var viewWillAppearNotifyDelegate = "viewWillAppearNotifyDelegates"
    static var navigationControllerPopGestureRecognizerChanging = "navigationControllerPopGestureRecognizerChanging"
    static var poppingByInteractivePopGestureRecognizer = "poppingByInteractivePopGestureRecognizer"
    static var willAppearByInteractivePopGestureRecognizer = "illAppearByInteractivePopGestureRecognizer"
    
    static var lockTransitionNavigationBar = "lockTransitionNavigationBar"
    static var transitionNavigationBar = "transitionNavigationBar"
    static var originContainerViewBackgroundColor = "originContainerViewBackgroundColor"
    static var prefersNavigationBarBackgroundViewHidden = "prefersNavigationBarBackgroundViewHidden"
    
}

extension UIView {
    var mm_visible: Bool {
        if self.isHidden || self.alpha < 0.01 {
            return false
        }
        if self.window != nil {
            return true
        }
        return false // TODO
    }
}
