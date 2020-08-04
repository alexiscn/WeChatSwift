//
//  WXActionSheetScrollView.swift
//  WXActionSheet
//
//  Created by xushuifeng on 2020/7/23.
//

import UIKit

@objc protocol WXActionSheetScrollViewDelegate {
    
    @objc optional func customViewForItem(_ item: WXScrollActionSheetItem) -> UIView
}

class WXActionSheetScrollView: UIScrollView {
    
    weak var actionSheetDelegate: WXActionSheetScrollViewDelegate?
    
    func reloadItems(_ items: [WXScrollActionSheetItem], delegate: WXScrollActionSheetItemViewDelegate?) {
        subviews.forEach { $0.removeFromSuperview() }
        
        for item in items {
            let itemView = WXScrollActionSheetIconView(item: item)
            itemView.delegate = delegate
            addSubview(itemView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        return view is UIButton
    }
}
