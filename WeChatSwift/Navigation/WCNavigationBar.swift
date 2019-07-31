//
//  WCNavigationBar.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/31.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

public class WCNavigationBar: UINavigationBar {
    
    /// Enable WCNavigationBar
    public static var enabled = false
    
    public var automaticallyAdjustsPosition = true
    
    /// Additional height for navigation bar
    public var additionalHeight: CGFloat = 0.0 {
        didSet {
            if !prefersLargeTitles {
                frame.size.height = barHeight + additionalHeight
            }
            viewController?.adjustSafeAreaInsets()
        }
    }
    
    public var isShadowHidden: Bool = false {
        didSet { backgroundView?.clipsToBounds = isShadowHidden }
    }
    
    public override var isHidden: Bool {
        didSet { viewController?.adjustSafeAreaInsets() }
    }
    
    public override var alpha: CGFloat {
        get { return super.alpha }
        set { backgroundView?.alpha = newValue }
    }
    
    public override var backgroundColor: UIColor? {
        get { return super.backgroundColor }
        set { barTintColor = newValue }
    }
    
    public override var prefersLargeTitles: Bool {
        get { return super.prefersLargeTitles }
        set {
            super.prefersLargeTitles = newValue
            viewController?.navigationItem.largeTitleDisplayMode = newValue ? .always: .never
        }
    }
    
    public override var largeTitleTextAttributes: [NSAttributedString.Key : Any]? {
        get { return super.largeTitleTextAttributes }
        set {
            super.largeTitleTextAttributes = newValue
            viewController?.navigationController?.navigationBar.largeTitleTextAttributes = newValue
        }
    }

    private var _contentView: UIView?
    private var contentView: UIView? {
        if let contentView = _contentView { return contentView }
        _contentView = subviews.filter { String(describing: $0.classForCoder) == "_UINavigationBarContentView" }.first
        return _contentView
    }
    
    private var backgroundView: UIView? { return subviews.first }
    
    private var realNavigationBar: UINavigationBar? { return viewController?.navigationController?.navigationBar }
    
    private var barHeight: CGFloat { return realNavigationBar?.frame.height ?? 44.0 }
    
    weak var viewController: UIViewController?
    
    convenience init(viewController: UIViewController) {
        self.init()
        self.viewController = viewController
        setItems([viewController.wc_navigationItem], animated: false)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
     
        if let background = backgroundView {
            background.alpha = 1.0
            background.clipsToBounds = isShadowHidden
            background.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        }
        adjustLayoutMargins()
    }
    
    func adjustLayout() {
        guard let navigationBar = viewController?.navigationController?.navigationBar else { return }
        
        if automaticallyAdjustsPosition {
            frame = navigationBar.frame
            if prefersLargeTitles {
                frame.origin.y = 0 //TODO
            }
        } else {
            frame.size = navigationBar.frame.size
        }
    }
    
    private func adjustLayoutMargins() {
        
    }
}

extension UIViewController {

    private struct AssociatedKeys {
        static var navigationBar = "AssociatedKeys_navigationBar"
        static var navigationItem = "AssociatedKeys_AssociatedKeys"
    }
    
    var wc_navigationBar: WCNavigationBar {
        if let bar = objc_getAssociatedObject(self, &AssociatedKeys.navigationBar) as? WCNavigationBar {
            return bar
        }
        let bar = WCNavigationBar(viewController: self)
        objc_setAssociatedObject(self, &AssociatedKeys.navigationBar, bar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return bar
    }
    
    var wc_navigationItem: UINavigationItem {
        if let item = objc_getAssociatedObject(self, &AssociatedKeys.navigationItem) as? UINavigationItem {
            return item
        }
        let item = UINavigationItem()
        item.title = navigationItem.title
        item.prompt = navigationItem.prompt
        
        objc_setAssociatedObject(self, &AssociatedKeys.navigationItem, item, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return item
    }
    
}

extension UIApplication {
    
    private static let navigationSetup: Void = {
        UIViewController.methodSwizzling
    }()
    
    open override var next: UIResponder? {
        UIApplication.navigationSetup
        return super.next
    }
}


extension UIViewController {
    
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
        
        guard WCNavigationBar.enabled else { return }
        
        guard let navigationController = navigationController else { return }
        
        navigationController.sendNavigationBarToBack()
        wc_navigationBar.prefersLargeTitles = navigationController.navigationBar.prefersLargeTitles
        
        view.addSubview(wc_navigationBar)
    }
    
    @objc private func wc_viewWillAppear(_ animated: Bool) {
        wc_viewWillAppear(animated)
        
        guard WCNavigationBar.enabled else { return }
        
        guard let navigationBar = navigationController?.navigationBar else { return }
        
        navigationBar.isHidden = wc_navigationBar.isHidden
        adjustSafeAreaInsets()
        navigationItem.title = wc_navigationItem.title
        navigationBar.largeTitleTextAttributes = wc_navigationBar.largeTitleTextAttributes
        view.bringSubviewToFront(wc_navigationBar)
    }
    
    @objc private func wc_viewDidLayoutSubviews() {
        wc_viewDidLayoutSubviews()
        guard WCNavigationBar.enabled else { return }
        view.bringSubviewToFront(wc_navigationBar)
    }
    
    @objc private func wc_setNeedsStatusBarAppearanceUpdate() {
        wc_setNeedsStatusBarAppearanceUpdate()
        guard WCNavigationBar.enabled else { return }
        
        wc_navigationBar.adjustLayout()
        wc_navigationBar.setNeedsLayout()
    }
    
    func adjustSafeAreaInsets() {
        
    }
}


