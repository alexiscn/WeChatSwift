//
//  ContactInfoViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactInfoViewController: ASViewController<ASTableNode> {
    
    private let contact: ContactModel
    
    private var dataSource: [ContactInfo] = []
    
    init(contact: ContactModel) {
        self.contact = contact
        super.init(node: ASTableNode(style: .grouped))
        
        node.dataSource = self
        node.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ContactInfoViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let block: ASCellNodeBlock = {
            return ASCellNode()
        }
        return block
    }
}

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
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        avatarNode.style.preferredSize = CGSize(width: 64.0, height: 64.0)
        
        let vertical = ASStackLayoutSpec.vertical()
        vertical.spacing = 3.0
        vertical.children = [nicknameNode, wechatIDNode, regionNode]
        
        let horizontal = ASStackLayoutSpec.horizontal()
        horizontal.children = [avatarNode, vertical]
        
        return ASInsetLayoutSpec(insets: .zero, child: horizontal)
    }
    
}

class ContactInfoCellNode: ASCellNode {
    
    private let titleNode = ASTextNode()
    
    private let arrowNode = ASImageNode()
    
    init(info: ContactInfo) {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.children = [titleNode, spacer, arrowNode]
        
        let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        return ASInsetLayoutSpec(insets: insets, child: stack)
    }
}

class ContactInfoButtonCellNode: ASCellNode {
    
    private let buttonNode = ASButtonNode()
    
    init(info: ContactInfo) {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: buttonNode)
    }
}

enum ContactInfo {
    case profile
    case remark
    case moments
    case more
    case sendMessage
    case voip
}
