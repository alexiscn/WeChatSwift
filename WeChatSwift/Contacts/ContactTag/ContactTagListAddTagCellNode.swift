//
//  ContactTagListAddTagCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactTagListAddTagCellNode: ASCellNode {
    
    private let iconNode = ASImageNode()
    
    private let textNode = ASTextNode()
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        iconNode.image = UIImage.SVGImage(named: "icons_outlined_addoutline")
        
        textNode.attributedText = NSAttributedString(string: "新建标签", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor(hexString: "#1AAD19")
            ])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        iconNode.style.preferredSize = CGSize(width: 16, height: 16)
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = [iconNode, textNode]
        
        let insets = UIEdgeInsets(top: 22, left: 0, bottom: 22, right: 0)
        return ASInsetLayoutSpec(insets: insets, child: stack)
    }
    
}
