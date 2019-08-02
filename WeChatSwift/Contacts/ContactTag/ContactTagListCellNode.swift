//
//  ContactTagListCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactTagListCellNode: ASCellNode {
    
    private let titleNode = ASTextNode()
    
    private let descNode = ASTextNode()
    
    private let lineNode = ASDisplayNode()
    
    init(tag: ContactTag) {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        titleNode.attributedText = tag.attributedStringForTitle()
        descNode.attributedText = tag.attributedStringForDesc()
        lineNode.backgroundColor = UIColor(white: 0, alpha: 0.15)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [titleNode, descNode]
        
        return stack
    }
}


