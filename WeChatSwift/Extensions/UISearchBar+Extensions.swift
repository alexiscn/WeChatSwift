//
//  UISearchBar+Extensions.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/20.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    func removeBottomLine() {
        guard let cls = NSClassFromString("UISearchBarBackground") else {
            return
        }
        guard let views = subviews.first?.subviews else {
            return
        }
        for subView in views {
            if subView.isKind(of: cls) {
                subView.removeFromSuperview()
                break
            }
        }
    }
    
    func alignmentCenter() {
        guard let textFiled = value(forKey: "searchField") as? UITextField else {
            return
        }
        let iconWidth = textFiled.leftView?.frame.width ?? 0.0
        let placeholderWidth = textFiled.attributedPlaceholder?.size().width ?? 0.0
        let x = (bounds.width - iconWidth - placeholderWidth)/2.0 - 8.0
        let offset = UIOffset(horizontal: x, vertical: 0)
        setPositionAdjustment(offset, for: .search)
    }
    
    func resetAlignment() {
        setPositionAdjustment(.zero, for: .search)
    }
    
}
