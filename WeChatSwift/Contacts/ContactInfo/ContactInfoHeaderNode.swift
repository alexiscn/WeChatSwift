//
//  ContactInfoHeaderNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/30.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactInfoHeaderNode: ASDisplayNode {
    
    private let contact: Contact
    private let avatarNode = ASNetworkImageNode()
    private let nicknameNode = ASTextNode()
    private let genderNode = ASImageNode()
    private let wechatIDNode = ASTextNode()
    private let regionNode = ASTextNode()
    private let lineNode = ASDisplayNode()
    
    init(contact: Contact) {
        self.contact = contact
        super.init()
        automaticallyManagesSubnodes = true
        
        avatarNode.url = contact.avatarURL
        avatarNode.cornerRoundingType = .precomposited
        avatarNode.cornerRadius = 6
        
        let nameAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22, weight: .medium),
            NSAttributedString.Key.foregroundColor: Colors.black
        ]
        nicknameNode.attributedText = NSAttributedString(string: contact.name, attributes: nameAttributes)
        
        let genderImage = contact.gender == .male ? "Contact_Male_18x18_" : "Contact_Female_18x18_"
        genderNode.image = UIImage(named: genderImage)
        
        let wechatIDAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.5)
        ]
        wechatIDNode.attributedText = NSAttributedString(string: "微信号：" + contact.wxid, attributes: wechatIDAttributes)
        
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
        
        genderNode.style.preferredSize = CGSize(width: 18, height: 18)
        
        let nameStack = ASStackLayoutSpec.horizontal()
        nameStack.alignItems = .center
        nameStack.spacing = 6
        nameStack.children = [nicknameNode, genderNode]
        
        let vertical = ASStackLayoutSpec.vertical()
        vertical.spacing = 3.0
        vertical.style.spacingAfter = 16
        vertical.children = [nameStack, wechatIDNode, regionNode]
        
        let horizontal = ASStackLayoutSpec.horizontal()
        horizontal.spacing = 16.0
        horizontal.children = [avatarNode, vertical]
        horizontal.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 105)
        
        lineNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 16, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: 16, y: 105 - Constants.lineHeight)
        
        return ASAbsoluteLayoutSpec(children: [horizontal, lineNode])
    }
    
}
