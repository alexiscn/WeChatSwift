//
//  ScrollActionSheet.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/27.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class ScrollActionSheet: UIView {
    
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
    
    private func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0.0
            let y = UIScreen.main.bounds.height
            self.containerView.frame.origin = CGPoint(x: 0, y: y)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    public func reloadItems() {
        
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
        
        let topScrollView = ScrollActionSheetScrollView(items: items)
        topScrollView.itemDelegate = self
        topScrollView.frame = CGRect(x: 0, y: 54, width: bounds.width, height: 108)
        containerView.addSubview(topScrollView)
        
        offsetY = 54.0 + 108.0
        
        if bottomItems.count > 0 {
            
            let sep = UIView()
            sep.frame = CGRect(x: 12.0, y: offsetY, width: bounds.width - 24.0, height: Constants.lineHeight)
            sep.backgroundColor = UIColor(white: 0, alpha: 0.1)
            containerView.addSubview(sep)
            
            offsetY += 15
            
            let bottomScrollView = ScrollActionSheetScrollView(items: bottomItems)
            bottomScrollView.itemDelegate = self
            bottomScrollView.frame = CGRect(x: 0, y: offsetY, width: bounds.width, height: 108.0)
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

// MARK: - ScrollActionSheetItemViewDelegate
extension ScrollActionSheet: ScrollActionSheetItemViewDelegate {
    
    func scrollActionSheetItemViewDidPressed(_ item: ScrollActionSheetItem) {
        
    }
}
