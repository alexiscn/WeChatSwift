//
//  ScrollActionSheetScrollView.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/27.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class ScrollActionSheetScrollView: UIScrollView {
    
    weak var itemDelegate: ScrollActionSheetDelegate?
    
    init(items: [ScrollActionSheetItem], frame: CGRect) {
        super.init(frame: frame)
        
        for (index, item) in items.enumerated() {
            let itemView = ScrollActionSheetItemView(item: item)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
