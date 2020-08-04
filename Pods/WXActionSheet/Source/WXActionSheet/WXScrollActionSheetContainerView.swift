//
//  WXScrollActionSheetContainerView.swift
//  WXActionSheet
//
//  Created by xushuifeng on 2020/7/23.
//

import UIKit

class WXScrollActionSheetContainerView: UIView {
    
    init(scrollView: WXActionSheetScrollView, header: UIView?, footer: UIView?) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
