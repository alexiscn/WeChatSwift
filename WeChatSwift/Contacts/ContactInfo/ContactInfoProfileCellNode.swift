//
//  ContactInfoProfileCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/30.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactInfoProfileCellNode: ASCellNode {
    
    private let contact: Contact
    private let isLastCell: Bool
    
    private let avatarNode = ASImageNode()
    
    private let nicknameNode = ASTextNode()
    private let wechatIDNode = ASTextNode()
    private let regionNode = ASTextNode()
    private let lineNode = ASDisplayNode()
    
    init(contact: Contact, isLastCell: Bool) {
        self.contact = contact
        self.isLastCell = isLastCell
        super.init()
        automaticallyManagesSubnodes = true
        
        avatarNode.image = contact.avatar
        avatarNode.cornerRoundingType = .precomposited
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
        
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = Colors.white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        avatarNode.style.preferredSize = CGSize(width: 64.0, height: 64.0)
        avatarNode.style.spacingBefore = 21
        
        let vertical = ASStackLayoutSpec.vertical()
        vertical.spacing = 3.0
        vertical.style.spacingAfter = 16
        vertical.children = [nicknameNode, wechatIDNode, regionNode]
        
        let horizontal = ASStackLayoutSpec.horizontal()
        horizontal.spacing = 16.0
        horizontal.children = [avatarNode, vertical]
        horizontal.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 108)
        
        lineNode.isHidden = isLastCell
        lineNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 16, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: 16, y: 108 - Constants.lineHeight)
        
        return ASAbsoluteLayoutSpec(children: [horizontal, lineNode])
    }
    
}
