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
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
        
        editNameNode.delegate = self
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        editNameNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 40, height: 56)
        let insets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        return ASInsetLayoutSpec(insets: insets, child: editNameNode)
    }
    
}
