//
//  MomentTableViewCell.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class MomentTableViewCell: UITableViewCell {
    
    private let avatarImageView: UIImageView
    
    private let nameButton: UIButton
    
    private let timeLabel: UILabel
    
    private let moreButton: UIButton
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        avatarImageView = UIImageView()
        avatarImageView.layer.cornerRadius = 6
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        
        let nameButtonBg = UIImage(color: UIColor(hexString: "#888888"))
        nameButton = UIButton()
        nameButton.setTitleColor(Colors.DEFAULT_LINK_COLOR, for: .normal)
        nameButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameButton.setBackgroundImage(nameButtonBg, for: .highlighted)
        nameButton.titleEdgeInsets = UIEdgeInsets.zero
        
        timeLabel = UILabel()
        timeLabel.textColor = Colors.DEFAULT_TEXT_DISABLED_COLOR
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.text = "5小时前"
        
        moreButton = UIButton()
        moreButton.setBackgroundImage(UIImage(named: "AlbumOperateMore_32x20_"), for: .normal)
        moreButton.setBackgroundImage(UIImage(named: "AlbumOperateMoreHL_32x20_"), for: .highlighted)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarImageView)
        
        contentView.addSubview(nameButton)
        
        contentView.addSubview(timeLabel)
        contentView.addSubview(moreButton)
        
        avatarImageView.frame = CGRect(x: 15, y: 20, width: 50, height: 50)
        
        let maxSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        let size = ("丹妮丽丝JPABN" as NSString).boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [.font: UIFont.systemFont(ofSize: 16, weight: .medium)], context: nil).size
        
        nameButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(75)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(size.height)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(moreButton)
            make.leading.equalToSuperview().offset(75)
        }
    
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-15)
            make.height.equalTo(20)
            make.width.equalTo(32)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(moment: Moment) {
        
        let user = AppContext.shared.userProfileService.getUser(with: moment.userID)
        
        let avatar = user?.avatar ?? "DefaultHead_48x48_"
        avatarImageView.image = UIImage(named: avatar)
        nameButton.setTitle(user?.name, for: .normal)
        
    }
}
