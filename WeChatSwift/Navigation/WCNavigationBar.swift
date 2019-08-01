//
//  WCNavigationBar.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/31.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import AsyncDisplayKit

public struct Navigation<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

extension Navigation where Base: UIViewController {
    
    var bar: WCNavigationBar {
        return base.wc_navigationBar
    }
    
    var item: UINavigationItem {
        return base.wc_navigationItem
    }
}

public protocol NavigationCompatible {
    
    associatedtype CompatibleType
    
    var navigation: CompatibleType { get }
}

public extension NavigationCompatible {
    
    var navigation: Navigation<Self> {
        return Navigation(self)
    }
}

extension UIViewController: NavigationCompatible {}

public class WCNavigationBar: UINavigationBar {
    
    /// Enable WCNavigationBar
    public static var enabled = false {
        didSet {
            UIViewController.methodSwizzling
        }
    }
    
    public var automaticallyAdjustsPosition = true
    
    /// Additional height for navigation bar
    public var additionalHeight: CGFloat = 0.0 {
        didSet {
            frame.size.height = barHeight + _additionalHeight
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
    
    public var backBarButtonItem: BackBarButtonItem? {
        didSet {
            backBarButtonItem?.navigationController = viewController?.navigationController
            viewController?.wc_navigationItem.leftBarButtonItem = backBarButtonItem
        }
    }

    private var _contentView: UIView?
    private var contentView: UIView? {
        if let contentView = _contentView { return contentView }
        _contentView = subviews.filter { String(describing: $0.classForCoder) == "_UINavigationBarContentView" }.first
        return _contentView
    }
    
    private var backgroundView: UIView? { return subviews.first }
    
    private var realNavigationBar: UINavigationBar? { return viewController?.navigationController?.navigationBar ?? viewController?.navigationController?.navigationBar }
    
    private var barHeight: CGFloat { return realNavigationBar?.frame.height ?? 44.0 }
    
    var _additionalHeight: CGFloat { return prefersLargeTitles ? 0: additionalHeight }
    
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
            let maxY = UIApplication.shared.statusBarFrame.maxY
            background.frame = CGRect(x: 0, y: -maxY, width: bounds.width, height: bounds.height + maxY)
            adjustLayoutMargins()
        }
    }
    
    func adjustLayout() {
        guard let navigationBar = realNavigationBar else { return }
        
        if automaticallyAdjustsPosition {
            frame = navigationBar.frame
            if prefersLargeTitles {
                frame.origin.y = UIApplication.shared.statusBarFrame.maxY
            }
        } else {
            frame.size = navigationBar.frame.size
        }
        frame.size.height = navigationBar.frame.height + additionalHeight
        print(frame)
    }
    
    private func adjustLayoutMargins() {
        layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        contentView?.frame.origin.y = prefersLargeTitles ? 0: additionalHeight
        //contentView?.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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

//extension UIApplication {
//
//    private static let navigationSetup: Void = {
//        if WCNavigationBar.enabled {
//            UIViewController.methodSwizzling
//        }
//    }()
//
//    open override var next: UIResponder? {
//        UIApplication.navigationSetup
//        return super.next
//    }
//}


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
        print(self)
        
        guard WCNavigationBar.enabled else { return }
        
        guard let navigationController = navigationController else { return }
        
        navigationController.sendNavigationBarToBack()
        wc_navigationBar.prefersLargeTitles = navigationController.navigationBar.prefersLargeTitles
        
        setupBackBarButtonItem(navigationController)
        
        wc_navigationBar.isTranslucent = true
        
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
    
    private func setupBackBarButtonItem(_ navigationController: UINavigationController) {
        let count = navigationController.viewControllers.count
        guard count > 1 else { return }
        
        let backImage = UIImage.SVGImage(named: "icons_filled_back")
        let backButton = BackBarButtonItem(style: .image(backImage))
        backButton.navigationController = navigationController
        wc_navigationBar.backBarButtonItem = backButton
    }
    
    func adjustSafeAreaInsets() {
        //let height = _navigationBar.additionalView?.frame.height ?? 0
        additionalSafeAreaInsets.top = wc_navigationBar.isHidden
            ? -view.safeAreaInsets.top
            : wc_navigationBar._additionalHeight //+ height
    }
}


public class BackBarButtonItem: UIBarButtonItem {
    
    public enum BarButtonStyle {
        case title(String?)
        case image(UIImage?)
        case custom(UIButton)
    }
    
    weak var navigationController: UINavigationController?
    
    public convenience init(style: BarButtonStyle) {
        let action = #selector(barButtonTapped)
        switch style {
        case .title(let title):
            self.init(title: title, style: .plain, target: nil, action: action)
            self.target = self
        case .image(let image):
            self.init(image: image, style: .plain, target: nil, action: action)
            self.target = self
        case .custom(let button):
            self.init(customView: button)
            button.addTarget(self, action: action, for: .touchUpInside)
        }
    }
    
    @objc private func barButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
}


extension UITableViewController {
    
    private struct AssociatedKeys {
        static var observation = "AssociatedKeys_observation"
    }
    
    private var observation: NSKeyValueObservation {
        if let observation = objc_getAssociatedObject(
            self,
            &AssociatedKeys.observation)
            as? NSKeyValueObservation {
            return observation
        }
        
        let observation = tableView.observe(
        \.contentOffset,
        options: .new) { [weak self] tableView, change in
            guard let `self` = self else { return }
            
            self.view.bringSubviewToFront(self.wc_navigationBar)
            self.wc_navigationBar.frame.origin.y = tableView.contentOffset.y + UIApplication.shared.statusBarFrame.maxY
        }
        
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.observation,
            observation,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return observation
    }
    
    func observeContentOffset() {
        wc_navigationBar.automaticallyAdjustsPosition = false
        
        _ = observation
    }
}
