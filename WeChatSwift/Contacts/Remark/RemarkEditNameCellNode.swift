//
//  RemarkEditNameCellNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/11.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class RemarkEditNameCellNode: ASCellNode, ASEditableTextNodeDelegate {
    
    private let editNameNode = ASEditableTextNode()
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        editNameNode.textContainerInset = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 0)
        editNameNode.typingAttributes = [
            NSAttributedString.Key.font.rawValue: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor.rawValue: UIColor.black
        ]
        editNameNode.attributedPlaceholderText = NSAttributedString(string: "添加备注名", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.1)
            ])
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return editNameNode.resignFirstResponder()
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
        
        editNameNode.delegate = self
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        editNameNode.style.preferredSize = CGSize(width: Constants.screenWidth - 40, height: 56)
        let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return ASInsetLayoutSpec(insets: insets, child: editNameNode)
    }
    
}
