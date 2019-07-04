//
//  SessionViewCell.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class SessionViewCell: UITableViewCell {
    
    private let avatarImageView: UIImageView
    
    private let redDotView: UIImageView
    
    private let titleLabel: UILabel
    
    private let subTitleLabel: UILabel
    
    private let timeLabel: UILabel
    
    private let muteIconView: UIImageView
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        avatarImageView = UIImageView()
        avatarImageView.layer.cornerRadius = 4
        avatarImageView.layer.masksToBounds = true
        
        redDotView = UIImageView()
        redDotView.image = UIImage.SVGImage(named: "ui-resources_badge_dot")
        
        titleLabel = UILabel()
        titleLabel.textColor = Colors.black
        titleLabel.font = UIFont.systemFont(ofSize: 15.5)
        
        subTitleLabel = UILabel()
        subTitleLabel.font = UIFont.systemFont(ofSize: 14)
        subTitleLabel.textColor = UIColor(hexString: "9A9B9C") //Colors.DEFAULT_TEXT_DISABLED_COLOR
        
        timeLabel = UILabel()
        timeLabel.text = "16:42"
        timeLabel.font = UIFont.systemFont(ofSize: 11)
        timeLabel.textColor = Colors.DEFAULT_TEXT_DISABLED_COLOR
        
        muteIconView = UIImageView()
        muteIconView.image = UIImage.SVGImage(named: "icons_outlined_mute")
        muteIconView.isHidden = true
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(muteIconView)
        
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(48)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView).offset(2)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview()
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-40)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ session: Session) {
        titleLabel.text = session.name
        subTitleLabel.text = session.content
        if let avatar = session.avatar {
            avatarImageView.image = UIImage(named: avatar)
        }
    }
}
