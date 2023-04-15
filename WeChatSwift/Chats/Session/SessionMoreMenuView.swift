//
//  SessionMoreMenuView.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

struct SessionMoreItem {
    
    var type: MoreItemType
    
    var title: String
    
    var icon: String
    
    enum MoreItemType {
        case groupChats
        case addFriends
        case scan
        case money
    }
}

protocol SessionMoreMenuViewDelegate {
    func moreMenuView(_ menu: SessionMoreMenuView, didTap item: SessionMoreItem)
}

class SessionMoreMenuView: UIView {
    
    var delegate: SessionMoreMenuViewDelegate?
    
    private let backgroundView: UIImageView
    
    private let containerView: UIView
    
    private let menus: [SessionMoreItem]
    
    init(itemHeight: CGFloat, itemWidth: CGFloat, menus: [SessionMoreItem]) {
        
        self.menus = menus
        
        backgroundView = UIImageView()
        backgroundView.image = UIImage(named: "MoreFunctionFrame_58x50_")
        
        containerView = UIView()
        
        var buttons: [UIButton] = []
        for (index, menu) in menus.enumerated() {
            let menuIcon = UIImage.SVGImage(named: menu.icon, fillColor: .white)
            let button = UIButton(type: .custom)
            button.contentHorizontalAlignment = .left
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: -30)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.frame = CGRect(x: 0, y: itemHeight * CGFloat(index), width: itemWidth, height: itemHeight)
            button.tintColor = .white
            button.setImage(menuIcon, for: .normal)
            button.setImage(menuIcon, for: .highlighted)
            button.setBackgroundImage(UIImage(color: UIColor(hexString: "#000000", alpha: 0.3)), for: .highlighted)
            button.setTitle(menu.title, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.tag = index
            containerView.addSubview(button)
            
            if index != menus.count - 1 {
                let line = UIImageView()
                line.image = UIImage(named: "MoreFunctionFrameLine_120x0_")
                line.frame = CGRect(x: 50, y: itemHeight - Constants.lineHeight, width: itemWidth - 50, height: Constants.lineHeight)
                button.addSubview(line)
            }
            buttons.append(button)
        }
        containerView.frame = CGRect(x: 0, y: 5, width: itemWidth, height: itemHeight * CGFloat(menus.count))
        
        let frame = CGRect(x: 0, y: 0, width: itemWidth, height: containerView.frame.maxY)
        
        super.init(frame: frame)
        
        backgroundView.frame = bounds
        addSubview(backgroundView)
        addSubview(containerView)
        
        buttons.forEach { $0.addTarget(self, action: #selector(handleTapMenuButton(_:)), for: .touchUpInside) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleTapMenuButton(_ sender: UIButton) {
        let item = menus[sender.tag]
        delegate?.moreMenuView(self, didTap: item)
    }
    
}
