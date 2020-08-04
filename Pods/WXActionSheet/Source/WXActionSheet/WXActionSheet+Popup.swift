//
//  WXActionSheet+Popup.swift
//  WXActionSheet
//
//  Created by xushuifeng on 2020/7/23.
//

import UIKit

public extension WXActionSheet {
    
    static func show(_ contentView: UIView) {
        
        let windows = UIApplication.shared.windows.filter { NSStringFromClass($0.classForCoder) != "UIRemoteKeyboardWindow" }
        guard let win = windows.last else { return }
        
        let popover = WXActionSheetPopup(contentView: contentView)
        popover.onTap = {
            hide(contentView)
        }
        
        UIView.animate(withDuration: 0.05, animations: {
            win.addSubview(popover)
        }) { _ in
            UIView.animate(withDuration: 0.25) {
                popover.backgroundView.alpha = 1.0
                
                let y = popover.bounds.height - popover.contentView.bounds.height
                popover.contentView.frame.origin = CGPoint(x: 0, y: y)
            }
        }
    }
    
    static func hide(_ contentView: UIView) {
        guard let popup = contentView.superview as? WXActionSheetPopup else {
            return
        }
        UIView.animate(withDuration: 0.25, animations: {
            popup.backgroundView.alpha = 0.0
            let y = popup.bounds.height
            popup.contentView.frame.origin = CGPoint(x: 0, y: y)
        }) { _ in
            popup.removeFromSuperview()
        }
    }
}

class WXActionSheetPopup: UIView {
    
    var onTap: (() -> Void)?
    
    let backgroundView: UIView
    
    let contentView: UIView
    
    init(contentView: UIView) {
        
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        backgroundView.alpha = 0.0
        
        self.contentView = contentView
        let frame = UIScreen.main.bounds
        
        super.init(frame: frame)
        
        addSubview(backgroundView)
        addSubview(contentView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        self.addGestureRecognizer(tap)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.frame = self.bounds
        contentView.frame = CGRect(x: 0,
                                   y: self.bounds.height,
                                   width: contentView.frame.width,
                                   height: contentView.frame.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func onTap(_ recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: self)
        if !contentView.frame.contains(point) {
            onTap?()
        }
    }
}
