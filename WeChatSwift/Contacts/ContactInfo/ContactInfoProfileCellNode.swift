//
//  ContactInfoProfileCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/30.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactInfoProfileCellNode: ASCellNode {
    
    private let contact: ContactModel
    
    private let avatarNode = ASImageNode()
    
    private let nicknameNode = ASTextNode()
    private let wechatIDNode = ASTextNode()
    private let regionNode = ASTextNode()
    
    init(contact: ContactModel) {
        self.contact = contact
        super.init()
        automaticallyManagesSubnodes = true
        
        avatarNode.image = contact.image
        avatarNode.backgroundColor = Colors.white
        avatarNode.cornerRoundingType = .clipping
        avatarNode.cornerRadius = 6
        
        let nameAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .medium),
            NSAttributedString.Key.foregroundColor: Colors.black
        ]
        nicknameNode.attributedText = NSAttributedString(string: contact.name, attributes: nameAttributes)
        
        let wechatIDAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.5)
        ]
        wechatIDNode.attributedText = NSAttributedString(string: "微信号：", attributes: wechatIDAttributes)
        
        regionNode.attributedText = NSAttributedString(string: "国家：", attributes: wechatIDAttributes)
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = Colors.white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        avatarNode.style.preferredSize = CGSize(width: 64.0, height: 64.0)
        
        let vertical = ASStackLayoutSpec.vertical()
        vertical.spacing = 3.0
        vertical.children = [nicknameNode, wechatIDNode, regionNode]
        
        let horizontal = ASStackLayoutSpec.horizontal()
        horizontal.spacing = 16.0
        horizontal.children = [avatarNode, vertical]
        
        let insets = UIEdgeInsets(top: 10, left: 16, bottom: 28, right: 16)
        return ASInsetLayoutSpec(insets: insets, child: horizontal)
    }
    
}
