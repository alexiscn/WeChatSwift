//
//  ScrollActionSheetScrollView.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/27.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class ScrollActionSheetScrollView: UIScrollView {
    
    weak var itemDelegate: ScrollActionSheetItemViewDelegate?
    
    init(items: [ScrollActionSheetItem]) {
        super.init(frame: .zero)
        
        for (index, item) in items.enumerated() {
            let itemView = ScrollActionSheetItemView(item: item)
            itemView.delegate = itemDelegate
            itemView.frame.origin = CGPoint(x: 68.0 * CGFloat(index), y: 0)
            addSubview(itemView)
        }
        contentSize = CGSize(width: 12 + 68.0 * CGFloat(items.count), height: 108)
        contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
