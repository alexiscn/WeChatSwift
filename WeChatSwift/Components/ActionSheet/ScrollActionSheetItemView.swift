//
//  ScrollActionSheetItemView.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/27.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class ScrollActionSheetItemView: UIView {
    
    weak var delegate: ScrollActionSheetDelegate?
    
    private let iconButton: UIButton
    
    private let titleLabel: UILabel
    
    private let item: ScrollActionSheetItem
    
    init(item: ScrollActionSheetItem) {
        self.item = item
        
        iconButton = UIButton(type: .custom)
        iconButton.frame = CGRect(x: 0, y: 0, width: 56.0, height: 56.0)
        iconButton.setImage(item.iconImage, for: .normal)
        iconButton.setBackgroundImage(UIImage.as_imageNamed("Action_Button_56x56_"), for: .normal)
        iconButton.setBackgroundImage(UIImage.as_imageNamed("Action_Tap_56x56_"), for: .highlighted)
        
        titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 0, y: 64.0, width: 56.0, height: 12.0)
        titleLabel.font = UIFont.systemFont(ofSize: 10)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor(white: 0, alpha: 0.5)
        titleLabel.text = item.title
        
        super.init(frame: CGRect(origin: .zero, size: CGSize(width: 56.0, height: 98.0)))
        
        addSubview(iconButton)
        addSubview(titleLabel)
        
        iconButton.addTarget(self, action: #selector(handleIconButtonClicked), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleIconButtonClicked() {
        delegate?.scrollActionSheetDidPressedItem(item)
    }
}
