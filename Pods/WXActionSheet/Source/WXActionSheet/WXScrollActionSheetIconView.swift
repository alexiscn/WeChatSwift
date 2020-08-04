//
//  WXScrollActionSheetIconView.swift
//  WXActionSheet
//
//  Created by xushuifeng on 2020/7/23.
//

import UIKit

public class WXScrollActionSheetIconView: WXScrollActionSheetItemView {
    
    private let titleLabel: UILabel
    
    private let iconButton: UIButton
    
    public init(item: WXScrollActionSheetItem) {
        
        titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.textColor = item.titleColor
        titleLabel.font = UIFont.systemFont(ofSize: 11)
        
        iconButton = UIButton(type: .custom)
        
        super.init(frame: .zero)
        self.item = item
        addSubview(titleLabel)
        addSubview(iconButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reload(item: WXScrollActionSheetItem) {
        
    }
    
}
