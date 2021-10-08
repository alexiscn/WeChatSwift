//
//  WXActionSheet.swift
//  WXActionSheetDemo
//
//  Created by xu.shuifeng on 2018/12/26.
//  Copyright © 2018 shuifeng.me. All rights reserved.
//

import UIKit

let LineHeight: CGFloat = 1.0/UIScreen.main.scale

public class WXActionSheet: UIView {
    
    public var style: WXActionSheetStyle = {
        if #available(iOS 13, *) {
            return .system
        } else {
            return .light
        }
    }()
    
    public var titleView: UIView?
    
    public var roundTopCorners: Bool = true
    
    private let containerView = UIView()
    
    private let backgroundView = UIView()
    
    private var items: [WXActionSheetItem] = []
    
    private var cancelButtonTitle: String?
    
    public init(cancelButtonTitle: String? = nil) {
        let frame = UIScreen.main.bounds
        super.init(frame: frame)
        self.cancelButtonTitle = cancelButtonTitle
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func show() {
        let windows = UIApplication.shared.windows.filter { NSStringFromClass($0.classForCoder) != "UIRemoteKeyboardWindow" }.reversed()
        guard let win = windows.first(where: { $0.isKeyWindow }) else {
            return
        }
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
    
    func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0.0
            let y = UIScreen.main.bounds.height
            self.containerView.frame.origin = CGPoint(x: 0, y: y)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    public func add(_ item: WXActionSheetItem) {
        items.append(item)
    }
}


// MARK: - Private Methods
extension WXActionSheet {
    
    private func commonInit() {
        backgroundView.frame = bounds
        backgroundView.alpha = 0.0
        addSubview(backgroundView)
        
        addSubview(containerView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        tapGesture.delegate = self
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: backgroundView)
        if !containerView.frame.contains(point) {
            hide()
        }
    }
    
    private func buildUI() {
        
        // used to calculate container's height
        var y: CGFloat = 0.0
        
        if let titleView = titleView {
            titleView.backgroundColor = style.appearance.buttonNormalBackgroundColor
            titleView.frame = CGRect(origin: .zero, size: CGSize(width: bounds.width, height: titleView.frame.height))
            containerView.addSubview(titleView)
            y = titleView.frame.height + LineHeight
        }
        
        if let cancelTitle = cancelButtonTitle, !items.contains(where: { $0.type == .cancel }) {
            items.append(WXActionSheetItem(title: cancelTitle, handler: nil, type: .cancel))
        }
        
        let highlightBGImage = UIImage.imageWithColor(style.appearance.buttonHighlightBackgroundColor)
        let normalBGImage = UIImage.imageWithColor(style.appearance.buttonNormalBackgroundColor)
        
        let x = bounds.minX
        let width = bounds.width
        var height = style.appearance.buttonHeight
        
        for (index, item) in items.enumerated() {
            
            height = item.desc == nil ? style.appearance.buttonHeight: 62.0
            let isLastItem = index == items.count - 1
            let itemView = actionItemView(item: item, at: index, isLastItem: isLastItem, backgroundImage: normalBGImage, highlightBackgroundImage: highlightBGImage)
            if isLastItem {
                if item.type == .cancel {
                    let separator = UIView(frame: CGRect(x: 0, y: y , width: width, height: 7.0))
                    separator.backgroundColor = style.appearance.separatorColor
                    containerView.addSubview(separator)
                    y += separator.bounds.height
                }
                height = style.appearance.buttonHeight + safeInsets.bottom
            }
            
            itemView.frame = CGRect(x: x, y: y, width: width, height: height)
            containerView.addSubview(itemView)
            y += height
            
            if !isLastItem {
                let line = UIView()
                line.frame = CGRect(x: x, y: y, width: width, height: LineHeight)
                line.backgroundColor = style.appearance.separatorLineColor
                containerView.addSubview(line)
                y += LineHeight
            }
        }
        
        backgroundView.backgroundColor = style.appearance.dimmingBackgroundColor
        containerView.backgroundColor = style.appearance.containerBackgroundColor
        containerView.frame = CGRect(x: x, y: bounds.height, width: width, height: y)
        
        if roundTopCorners {
            containerView.layer.cornerRadius = 15
            containerView.layer.masksToBounds = true
            containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        if style.appearance.enableBlurEffect {
            let effectView = UIVisualEffectView(effect: style.appearance.effect)
            effectView.frame = containerView.bounds
            containerView.addSubview(effectView)
            containerView.sendSubviewToBack(effectView)
        }
    }
    
    fileprivate func actionItemView(item: WXActionSheetItem, at index: Int, isLastItem: Bool, backgroundImage: UIImage?, highlightBackgroundImage: UIImage?) -> UIView {
        
        if item.desc == nil {
            let button = UIButton(type: .custom)
            button.tag = index
            button.backgroundColor = .clear
            button.setBackgroundImage(backgroundImage, for: .normal)
            button.setBackgroundImage(highlightBackgroundImage, for: .highlighted)
            button.setTitle(item.title, for: .normal)
            button.setImage(item.iconImage, for: .normal)
            button.imageEdgeInsets = item.imageEdgeInsets
            button.titleEdgeInsets = isLastItem ? UIEdgeInsets(top: -safeInsets.bottom/2, left: 0, bottom: safeInsets.bottom/2, right: 0) : item.titleEdgeInsets
            button.titleLabel?.font = item.font
            let titleColor: UIColor
            if item.type == .destructive {
                titleColor = style.appearance.destructiveButtonTitleColor
            } else {
                titleColor = item.titleColor ?? style.appearance.buttonTitleColor
            }
            button.setTitleColor(titleColor, for: .normal)
            button.addTarget(self, action: #selector(handleButtonTapped(_:)), for: .touchUpInside)
            return button
        } else {
            let view = UIView()
            let button = UIButton()
            button.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 62)
            button.tag = index
            button.addTarget(self, action: #selector(handleButtonTapped(_:)), for: .touchUpInside)
            button.setBackgroundImage(backgroundImage, for: .normal)
            button.setBackgroundImage(highlightBackgroundImage, for: .highlighted)
            
            let titleLabel = UILabel()
            titleLabel.textAlignment = .center
            titleLabel.text = item.title
            titleLabel.textColor = item.titleColor
            titleLabel.font = UIFont.systemFont(ofSize: 18)
            titleLabel.frame = CGRect(x: 0, y: 12, width: bounds.width, height: 22)
            
            let descLabel = UILabel()
            descLabel.textAlignment = .center
            descLabel.text = item.desc
            descLabel.textColor = item.descColor ?? style.appearance.titleColor
            descLabel.font = UIFont.systemFont(ofSize: 12)
            descLabel.frame = CGRect(x: 0, y: 36, width: bounds.width, height: 15)
            
            view.addSubview(button)
            view.addSubview(titleLabel)
            view.addSubview(descLabel)
            return view
        }
    }
    
    fileprivate var safeInsets: UIEdgeInsets {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
    
    @objc private func handleButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        
        hide()
        
        let item = items[index]
        item.handler?(self)
    }
}

// MARK: - UIGestureRecognizerDelegate
extension WXActionSheet: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == self.containerView {
            return false
        }
        return true
    }
}
