//
//  ScrollActionSheet.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/27.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

protocol ScrollActionSheetDelegate: class {
    func scrollActionSheetDidPressedItem(_ item: ScrollActionSheetItem)
}

class ScrollActionSheet: UIView {
    
    weak var delegate: ScrollActionSheetDelegate?
    
    private let containerView = UIView()
    private let backgroundView = UIView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    private let cancelButton = UIButton(type: .custom)
    
    private let title: String
    private let cancelButtonTitle: String
    private let items: [ScrollActionSheetItem]
    private let bottomItems: [ScrollActionSheetItem]
    
    init(title: String, items: [ScrollActionSheetItem], bottomItems: [ScrollActionSheetItem] = [], cancelButtonTitle: String = "取消") {
        
        self.title = title
        self.items = items
        self.bottomItems = bottomItems
        self.cancelButtonTitle = cancelButtonTitle
        
        super.init(frame: UIScreen.main.bounds)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show() {
        let windows = UIApplication.shared.windows.filter { NSStringFromClass($0.classForCoder) != "UIRemoteKeyboardWindow" }
        guard let win = windows.last else { return }
        buildUI()
        UIView.animate(withDuration: 0.1, animations: {
            win.addSubview(self)
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.backgroundView.alpha = 1.0
                let y = self.bounds.height - self.containerView.frame.height
                self.containerView.frame.origin = CGPoint(x: 0, y: y)
            }
        }
    }
    
    public func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0.0
            let y = UIScreen.main.bounds.height
            self.containerView.frame.origin = CGPoint(x: 0, y: y)
        }) { _ in
            self.removeFromSuperview()
        }
    }
}

extension ScrollActionSheet {
    
    private func commonInit() {
        backgroundView.frame = bounds
        backgroundView.alpha = 0.0
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.4)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.delegate = self
        backgroundView.addGestureRecognizer(tapGesture)
        addSubview(backgroundView)
        
        containerView.backgroundColor = UIColor(white: 1, alpha: 0.7)
        containerView.layer.cornerRadius = 10.0
        containerView.clipsToBounds = true
        addSubview(containerView)
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: backgroundView)
        if !containerView.frame.contains(point) {
            hide()
        }
    }
    
    private func buildUI() {
        
        var offsetY: CGFloat = 0.0
        
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        titleLabel.frame = CGRect(x: 10, y: 16.0, width: bounds.width - 20, height: 14.0)
        titleLabel.textColor = UIColor(white: 0, alpha: 0.5)
        titleLabel.text = title
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        let topScrollViewFrame = CGRect(x: 0, y: 54, width: bounds.width, height: 108)
        let topScrollView = ScrollActionSheetScrollView(items: items, frame: topScrollViewFrame)
        topScrollView.itemDelegate = delegate
        containerView.addSubview(topScrollView)
        
        offsetY = 54.0 + 108.0
        
        if bottomItems.count > 0 {
            
            let separtorLine = UIView()
            separtorLine.frame = CGRect(x: 12.0, y: offsetY, width: bounds.width - 24.0, height: Constants.lineHeight)
            separtorLine.backgroundColor = UIColor(white: 0, alpha: 0.1)
            containerView.addSubview(separtorLine)
            
            offsetY += 15
            
            let bottomScrollViewFrame = CGRect(x: 0, y: offsetY, width: bounds.width, height: 108.0)
            let bottomScrollView = ScrollActionSheetScrollView(items: bottomItems, frame: bottomScrollViewFrame)
            bottomScrollView.itemDelegate = delegate
            containerView.addSubview(bottomScrollView)
            
            offsetY += 108.0
        }
        
        offsetY += 15.0
        
        let cancelButton = UIButton(type: .custom)
        cancelButton.backgroundColor = .white
        cancelButton.setTitle(cancelButtonTitle, for: .normal)
        cancelButton.setTitleColor(UIColor(white: 0, alpha: 0.9), for: .normal)
        containerView.addSubview(cancelButton)
        cancelButton.frame = CGRect(x: 0, y: offsetY, width: bounds.width, height: 56.0 + Constants.bottomInset)
        cancelButton.addTarget(self, action: #selector(handleCancelButtonClicked), for: .touchUpInside)
        
        offsetY += (56.0 + Constants.bottomInset)
        if Constants.iPhoneX {
            let bottomInset = Constants.bottomInset
            cancelButton.titleEdgeInsets = UIEdgeInsets(top: -bottomInset/2, left: 0, bottom: bottomInset/2, right: 0)
        }
        
        containerView.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: offsetY)
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.frame = containerView.bounds
        containerView.addSubview(blurView)
        containerView.sendSubviewToBack(blurView)
    }
    
    @objc private func handleCancelButtonClicked() {
        hide()
    }
}

// MARK: - UIGestureRecognizerDelegate
extension ScrollActionSheet: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == self.containerView {
            return false
        }
        return true
    }
}
