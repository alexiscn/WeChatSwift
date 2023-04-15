//
//  RefreshTableHeaderView.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/13.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

enum RefreshState {
    case pulling
    case normal
    case loading
}

protocol RefreshTableHeaderViewDelegate: class {
    func refreshTableHeaderViewDidTriggerRefresh(_ headerView: RefreshTableHeaderView)
}

class RefreshTableHeaderView: UIView {
    
    weak var delegate: RefreshTableHeaderViewDelegate?
    
    init(frame: CGRect, arrowImage: UIImage, textColor: UIColor) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func refreshScrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
}
