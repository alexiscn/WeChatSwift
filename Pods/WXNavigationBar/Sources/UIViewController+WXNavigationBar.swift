//
//  UIViewController+WXNavigationBar.swift
//  WXNavigationBar
//
//  Created by xushuifeng on 2020/2/23.
//

import UIKit

/// Exentsions that handle navigation bar
extension UIViewController {
    
    private struct AssociatedKeys {
        static var navigationBar = "navigationBar"
        static var navigationBarBackgroundColor = "navigationBarBackgroundColor"
        static var navigationBarBackgroundImage = "navigationBarBackgroundImage"
        
        static var barBarTintColor = "barBarTintColor"
        static var barTintColor = "barTintColor"
        static var titleTextAttributes = "titleTextAttributes"
        static var useSystemBlurNavBar = "useSystemBlurNavBar"
        static var shadowImage = "shadowImage"
        static var shadowImageTintColor = "shadowImageTintColor"
        static var backButtonCustomView = "backButtonCustomView"
        static var backImage = "backImage"
        
        static var disableInteractivePopGesture = "disableInteractivePopGesture"
        static var fullScreenInteractiveEnabled = "fullScreenInteractivePopEnabled"
        static var interactivePopMaxAllowedDistanceToLeftEdge = "interactivePopMaxAllowedDistanceToLeftEdge"
        static var automaticallyHideWXNavBarInChildViewController = "automaticallyHideWXNavBarInChildViewController"
        
        // For internal usage
        static var viewWillDisappear = "viewWillDisappear"
    }
    
    /// Fake NavigationBar.
    /// Layout inside view controller, below the actual navigation bar which is transparent
    open var wx_navigationBar: WXNavigationBar {
        if let bar = objc_getAssociatedObject(self, &AssociatedKeys.navigationBar) as? WXNavigationBar {
            return bar
        }
        let bar = WXNavigationBar(frame: .zero)
        objc_setAssociatedObject(self, &AssociatedKeys.navigationBar, bar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return bar
    }
    
    /// Background color of fake NavigationBar
    /// Default color is UIColor(white: 237.0/255, alpha: 1.0)
    @objc open var wx_navigationBarBackgroundColor: UIColor? {
        if let color = objc_getAssociatedObject(self, &AssociatedKeys.navigationBarBackgroundColor) as? UIColor {
            return color
        }
        let color = WXNavigationBar.NavBar.backgroundColor
        objc_setAssociatedObject(self, &AssociatedKeys.navigationBarBackgroundColor, color, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return color
    }
    
    /// Background Image for Navigation Bar in View Controller
    @objc open var wx_navigationBarBackgroundImage: UIImage? {
        if let backgroundImage = objc_getAssociatedObject(self, &AssociatedKeys.navigationBarBackgroundImage) as? UIImage {
            return backgroundImage
        }
        let backgroundImage = WXNavigationBar.NavBar.backgroundImage
        objc_setAssociatedObject(self, &AssociatedKeys.navigationBarBackgroundImage, backgroundImage, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return backgroundImage
    }
    
    /// Use the system blured navigation bar.
    /// Set to `true` if your want the syatem navigation bar
    @objc open var wx_useSystemBlurNavBar: Bool {
        if let useSystemBlurNavBar = objc_getAssociatedObject(self, &AssociatedKeys.useSystemBlurNavBar) as? Bool {
            return useSystemBlurNavBar
        }
        let useSystemBlurNavBar = false
        objc_setAssociatedObject(self, &AssociatedKeys.useSystemBlurNavBar, useSystemBlurNavBar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return useSystemBlurNavBar
    }
    
    /// Bar tint color of navigationbar
    @objc open var wx_barBarTintColor: UIColor? {
        if let barBarTintColor = objc_getAssociatedObject(self, &AssociatedKeys.barBarTintColor) as? UIColor {
            return barBarTintColor
        }
        let barBarTintColor: UIColor? = nil
        objc_setAssociatedObject(self, &AssociatedKeys.barBarTintColor, barBarTintColor, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return barBarTintColor
    }
    
    /// Tint color of navigationbar
    @objc open var wx_barTintColor: UIColor? {
        if let barTintColor = objc_getAssociatedObject(self, &AssociatedKeys.barTintColor) as? UIColor {
            return barTintColor
        }
        let barTintColor = WXNavigationBar.NavBar.tintColor
        objc_setAssociatedObject(self, &AssociatedKeys.barTintColor, barTintColor, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return barTintColor
    }
    
    /// Title text attributes of navigationbar
    @objc open var wx_titleTextAttributes: [NSAttributedString.Key: Any]? {
        if let attributes = objc_getAssociatedObject(self, &AssociatedKeys.titleTextAttributes) as? [NSAttributedString.Key: Any] {
            return attributes
        }
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
        objc_setAssociatedObject(self, &AssociatedKeys.titleTextAttributes, attributes, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return attributes
    }
    
    /// ShadowImage of Navigation Bar
    @objc open var wx_shadowImage: UIImage? {
        if let shadowImage = objc_getAssociatedObject(self, &AssociatedKeys.shadowImage) as? UIImage {
            return shadowImage
        }
        let shadowImage = WXNavigationBar.NavBar.shadowImage
        objc_setAssociatedObject(self, &AssociatedKeys.shadowImage, shadowImage, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return shadowImage
    }
    
    /// Use `wx_shadowImageTintColor` to create shadowImage. The default value is nil.
    /// Note: if `wx_shadowImageTintColor` is set, `wx_shadowImage` will be ignored.
    @objc open var wx_shadowImageTintColor: UIColor? {
        if let shadowImageTintColor = objc_getAssociatedObject(self, &AssociatedKeys.shadowImageTintColor) as? UIColor {
            return shadowImageTintColor
        }
        let shadowImageTintColor: UIColor? = nil
        objc_setAssociatedObject(self, &AssociatedKeys.shadowImageTintColor, shadowImageTintColor, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return shadowImageTintColor
    }

    /// NavigationBar back image
    @objc open var wx_backImage: UIImage? {
        if let backImage = objc_getAssociatedObject(self, &AssociatedKeys.backImage) as? UIImage {
            return backImage
        }
        let backImage = WXNavigationBar.NavBar.backImage
        objc_setAssociatedObject(self, &AssociatedKeys.backImage, backImage, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return backImage
    }
    
    /// A custom view for back button. eg: you can create a label to display the back button.
    @objc open var wx_backButtonCustomView: UIView? {
        if let backButtonCustomView = objc_getAssociatedObject(self, &AssociatedKeys.backButtonCustomView) as? UIView {
            return backButtonCustomView
        }
        let backButtonCustomView = WXNavigationBar.NavBar.backButtonCustomView
        objc_setAssociatedObject(self, &AssociatedKeys.backButtonCustomView, backButtonCustomView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return backButtonCustomView
    }
    
    /// A Boolean value indicating whether interactive pop gesture is disbabled. `false` by default.
    @objc open var wx_disableInteractivePopGesture: Bool {
        if let disableInteractivePopGesture = objc_getAssociatedObject(self, &AssociatedKeys.disableInteractivePopGesture) as? Bool {
            return disableInteractivePopGesture
        }
        let disableInteractivePopGesture = false
        objc_setAssociatedObject(self, &AssociatedKeys.disableInteractivePopGesture, disableInteractivePopGesture, .OBJC_ASSOCIATION_ASSIGN)
        return disableInteractivePopGesture
    }
    
    /// A Boolean value indicating whether fullscreen pop gesture is enabled.
    /// The default value of this property is `WXNavigationBar.NavBar.fullscreenPopGestureEnabled`.
    @objc open var wx_fullScreenInteractivePopEnabled: Bool {
        if let fullScreenInteractivePopEnabled = objc_getAssociatedObject(self, &AssociatedKeys.fullScreenInteractiveEnabled) as? Bool {
            return fullScreenInteractivePopEnabled
        }
        let fullScreenInteractivePopEnabled = WXNavigationBar.NavBar.fullscreenPopGestureEnabled
        objc_setAssociatedObject(self,
                                 &AssociatedKeys.fullScreenInteractiveEnabled,
                                 fullScreenInteractivePopEnabled,
                                 .OBJC_ASSOCIATION_ASSIGN)
        return fullScreenInteractivePopEnabled
    }
    
    /// The initial distance to left edge allow to interactive pop gesture.
    /// 0 by default, which means no limit.
    @objc open var wx_interactivePopMaxAllowedDistanceToLeftEdge: CGFloat {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.interactivePopMaxAllowedDistanceToLeftEdge) as? CGFloat ?? 0.0 }
        set { objc_setAssociatedObject(self, &AssociatedKeys.interactivePopMaxAllowedDistanceToLeftEdge, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    /// A Boolean value indicating whether hide     `WXNavigationBar` in Chid View Controller. By default is `true`.
    /// Note: `WXNavigationBar` should be managed by the parent view controller.
    @objc open var wx_automaticallyHideWXNavBarInChildViewController: Bool {
        if let hide = objc_getAssociatedObject(self, &AssociatedKeys.automaticallyHideWXNavBarInChildViewController) as? Bool {
            return hide
        }
        let automaticallyHideWXNavBarInChildViewController = true
        objc_setAssociatedObject(self,
                                 &AssociatedKeys.automaticallyHideWXNavBarInChildViewController,
                                 automaticallyHideWXNavBarInChildViewController,
                                 .OBJC_ASSOCIATION_ASSIGN)
        return automaticallyHideWXNavBarInChildViewController
    }
}

// MARK: - Private Work
extension UIViewController {
    
    private var wx_viewWillDisappear: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.viewWillDisappear) as? Bool ?? false }
        set { objc_setAssociatedObject(self, &AssociatedKeys.viewWillDisappear, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    static let swizzleUIViewControllerOnce: Void = {
        let cls = UIViewController.self
        swizzleMethod(cls, #selector(UIViewController.viewDidLoad), #selector(UIViewController.wx_viewDidLoad))
        swizzleMethod(cls, #selector(UIViewController.viewWillAppear(_:)), #selector(UIViewController.wx_viewWillAppear(_:)))
        swizzleMethod(cls, #selector(UIViewController.viewDidAppear(_:)), #selector(UIViewController.wx_viewDidAppear(_:)))
        swizzleMethod(cls, #selector(UIViewController.viewWillDisappear(_:)), #selector(UIViewController.wx_viewWillDisappear(_:)))
    }()
    
    @objc private func wx_viewDidLoad() {
        if navigationController != nil && navigationController!.wx_enableWXNavigationBar {
            navigationController?.configureNavigationBar()
            // configure fake navigationBar
            wx_navigationBar.backgroundColor = wx_navigationBarBackgroundColor
            wx_navigationBar.shadowImageView.image = wx_shadowImage
            if let color = wx_shadowImageTintColor {
                wx_navigationBar.shadowImageView.image = Utility.imageFrom(color: color)
            }
            wx_navigationBar.backgroundImageView.image = wx_navigationBarBackgroundImage
            wx_navigationBar.frame = CGRect(x: 0,
                                            y: 0,
                                            width: view.bounds.width,
                                            height: Utility.navigationBarHeight)
            wx_navigationBar.enableBlurEffect(wx_useSystemBlurNavBar)
            
            // Fix when the view of ViewController is UIScrollView.
            // wx_navigationBar will layout strange when the root view is UIScrollView.
            // So we add wx_navigationBar to navigationController
            if view is UIScrollView {
                navigationController?.view.insertSubview(wx_navigationBar, at: 1)
            } else {
                view.addSubview(wx_navigationBar)
            }
            
            // When view controller is child view controller, automatically hide wx_navigationBar.
            if let parent = parent, !(parent is UINavigationController)  && wx_automaticallyHideWXNavBarInChildViewController {
                wx_navigationBar.isHidden = true
            }
        }
        
        wx_viewDidLoad()
    }
    
    @objc private func wx_viewWillAppear(_ animated: Bool) {
        if navigationController != nil && navigationController!.wx_enableWXNavigationBar {
            navigationController?.navigationBar.barTintColor = wx_barBarTintColor
            navigationController?.navigationBar.tintColor = wx_barTintColor
            navigationController?.navigationBar.titleTextAttributes = wx_titleTextAttributes
            view.bringSubviewToFront(wx_navigationBar)
            
            navigationController?.navigationBar.frameDidUpdated = { [weak self] frame in
                guard let self = self else { return }
                // Avoid navigationBar frame updated when swipe back from view controller
                // with large title mode to view controller with normal navigationBar
                if self.wx_viewWillDisappear {
                    return
                }
                let newFrame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height + frame.origin.y)
                self.wx_navigationBar.frame = newFrame
            }
        }
        wx_viewWillDisappear = false
        wx_viewWillAppear(animated)
    }
    
    @objc private func wx_viewWillDisappear(_ animated: Bool) {
        wx_viewWillDisappear = true
        wx_viewWillDisappear(animated)
    }
    
    @objc private func wx_viewDidAppear(_ animated: Bool) {
        if let navigationController = self.navigationController, navigationController.wx_enableWXNavigationBar {
            let interactivePopGestureRecognizerEnabled = navigationController.viewControllers.count > 1
            navigationController.interactivePopGestureRecognizer?.isEnabled = interactivePopGestureRecognizerEnabled
        }
        wx_viewDidAppear(animated)
    }
    
    
    /// Do additional logics when user tap back button.
    /// Note: if your override this function. Do not call super.wx_backButtonClicked() and manage `popViewController` yourself.
    @objc open func wx_backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
}
