//
//  SessionMoreMenuView.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

struct SessionMoreItem {
    
    var title: String
    
    var icon: String
    
    var action: RelayCommand
}

class SessionMoreMenuView: UIView {
    
    private let backgroundView: UIImageView
    
    private var actions: [RelayCommand] = []
    
    init(frame: CGRect, menus: [SessionMoreItem]) {
        
        backgroundView = UIImageView()
        backgroundView.image = UIImage(named: "MoreFunctionFrame_58x50_")
        
        super.init(frame: frame)
        
        backgroundView.frame = bounds
        addSubview(backgroundView)
        
        let itemHeight = frame.height / CGFloat(menus.count)
        
        for (index, menu) in menus.enumerated() {
            let button = UIButton(type: .custom)
            button.contentHorizontalAlignment = .left
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: -30)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.frame = CGRect(x: 0, y: itemHeight * CGFloat(index), width: bounds.width, height: itemHeight)
            button.tintColor = .white
            button.setImage(UIImage.SVGImage(named: menu.icon, fillColor: .white), for: .normal)
            button.setTitle(menu.title, for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.tag = index
            addSubview(button)
            actions.append(menu.action)
            
            if index != menus.count - 1 {
                let line = UIImageView()
                line.image = UIImage(named: "MoreFunctionFrameLine_120x0_")
                line.frame = CGRect(x: 50, y: itemHeight - LINE_HEIGHT, width: bounds.width - 50, height: LINE_HEIGHT)
                button.addSubview(line)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleTapMenuButton(_ sender: UIButton) {
        let action = actions[sender.tag]
        action()
    }
    
}
