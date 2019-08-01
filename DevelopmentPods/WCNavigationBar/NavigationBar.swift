//
//  NavigationBar.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/31.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

public class NavigationBar: UINavigationBar {
    
    /// Enable NavigationBar
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
    
    private var realNavigationBar: UINavigationBar? { return viewController?.navigationController?.navigationBar }
    
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
    }
    
    private func adjustLayoutMargins() {
        layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        contentView?.frame.origin.y = prefersLargeTitles ? 0: additionalHeight
        //contentView?.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func configure(style: NavigationStyle) {
        alpha = style.alpha
        isTranslucent = style.isTranslucent
        barTintColor = style.barTintColor
        tintColor = style.tintColor
        
        shadowImage = style.shadowImage
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
