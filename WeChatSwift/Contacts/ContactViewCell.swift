//
//  ContactViewCell.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class ContactViewCell: UITableViewCell {
    
    private let iconView: UIImageView
    
    private let titleLabel: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        iconView = UIImageView()
        iconView.layer.cornerRadius = 4
        iconView.layer.masksToBounds = true
        
        titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = Colors.white
        
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        
        iconView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(36)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(iconView.snp.trailing).offset(16)
        }
        
        accessoryView = UIImageView(image: UIImage.SVGImage(named: "icons_outlined_arrow"))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ model: ContactModel) {
        iconView.image = model.image
        titleLabel.text = model.name
    }
}
