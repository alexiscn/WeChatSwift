//
//  SessionViewCell.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class SessionViewCell: UITableViewCell {
    
    private let iconView: UIImageView
    
    private let redDotView: UIView
    
    private let titleLabel: UILabel
    
    private let subTitleLabel: UILabel
    
    private let timeLabel: UILabel
    
    private let muteIconView: UIImageView
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        iconView = UIImageView()
        iconView.layer.cornerRadius = 4
        
        redDotView = UIView()
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        
        subTitleLabel = UILabel()
        subTitleLabel.font = UIFont.systemFont(ofSize: 12)
        
        timeLabel = UILabel()
        
        muteIconView = UIImageView()
        muteIconView.image = UIImage.SVGImage(named: "icons_outlined_mute")
        muteIconView.isHidden = true
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(muteIconView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
