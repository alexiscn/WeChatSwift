//
//  WXActionSheetScrollView.swift
//  WXActionSheet
//
//  Created by xushuifeng on 2020/7/23.
//

import UIKit

class WXActionSheetScrollView: UIScrollView {
    
    weak var itemDelegate: WXScrollActionSheetItemViewDelegate?
    
    init(items: [WXScrollActionSheetItem], frame: CGRect) {
        super.init(frame: frame)
        
        for (index, item) in items.enumerated() {
            let itemView = WXScrollActionSheetItemView(item: item)
            itemView.delegate = itemDelegate
            itemView.frame.origin = CGPoint(x: 68.0 * CGFloat(index), y: 0)
            addSubview(itemView)
        }
        contentSize = CGSize(width: 24 + 68.0 * CGFloat(items.count), height: bounds.height)
        contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        setContentOffset(CGPoint(x: -12, y: 0), animated: false)
        alwaysBounceHorizontal = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func touchesShouldCancel(in view: UIView) -> Bool {
        return view is UIButton
    }
}
