//
//  StorageUsageLoadingView.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/19.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class StorageUsageLoadingView: UIView {
    
    private let indicatorView = UIActivityIndicatorView(style: .gray)
    
    private let subTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        subTitleLabel.text = "正在计算存储空间，可能需要较长的时间，请稍等"
        subTitleLabel.font = UIFont.systemFont(ofSize: 14)
        subTitleLabel.textColor = UIColor(hexString: "#7F7F7F")
        subTitleLabel.textAlignment = .center
        
        addSubview(indicatorView)
        addSubview(subTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        indicatorView.frame = CGRect(x: (bounds.width - 20)/2.0, y: 60, width: 20, height: 20)
        subTitleLabel.frame = CGRect(x: 24, y: 96.0, width: bounds.width - 48, height: 17)
    }
    
}
