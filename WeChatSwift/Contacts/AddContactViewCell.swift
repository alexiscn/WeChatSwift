//
//  AddContactViewCell.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class AddContactViewCell: UITableViewCell {
    
    private let iconButton: UIButton
    
    private let titleLabel: UILabel
    
    private let subTitleLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        iconButton = UIButton(type: .custom)
        iconButton.isUserInteractionEnabled = false
        iconButton.contentEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        
        titleLabel = UILabel()
        titleLabel.textColor = Colors.DEFAULT_TEXT_COLOR
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        
        subTitleLabel = UILabel()
        subTitleLabel.textColor = Colors.DEFAULT_TEXT_GRAY_COLOR
        subTitleLabel.font = UIFont.systemFont(ofSize: 13)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.white
        
        contentView.addSubview(iconButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        
        iconButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-9)
            make.leading.equalTo(iconButton.snp.trailing).offset(16)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
        }
        
        accessoryView = UIImageView(image: UIImage.SVGImage(named: "icons_outlined_arrow"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ model: AddContactSource) {
        iconButton.setImage(model.image, for: .normal)
        iconButton.setBackgroundImage(UIImage.imageFromColor(model.backgroundColor), for: .init())
        titleLabel.text = model.titles.0
        subTitleLabel.text = model.titles.1
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        backgroundColor = highlighted ? Colors.highlightBackgroundColor: .white
    }
}
