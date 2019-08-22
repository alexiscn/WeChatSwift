//
//  UISearchBar+Extensions.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/20.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

extension UISearchBar {
    
    func alignmentCenter() {
        guard let textFiled = value(forKey: "searchField") as? UITextField else {
            return
        }
        let iconWidth = textFiled.leftView?.frame.width ?? 0.0
        let placeholderWidth = textFiled.attributedPlaceholder?.size().width ?? 0.0
        let x = (bounds.width - iconWidth - placeholderWidth - 8.0)/2.0 - 12
        let offset = UIOffset(horizontal: x, vertical: 0)
        setPositionAdjustment(offset, for: .search)
    }
    
    func resetAlignment() {
        setPositionAdjustment(.zero, for: .search)
    }
    
}
