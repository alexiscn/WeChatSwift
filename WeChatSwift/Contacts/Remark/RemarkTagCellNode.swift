//
//  RemarkTagCellNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/11.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class RemarkTagCellNode: ASCellNode {
    
    private let placeholderNode = ASTextNode()
    
    private let arrowNode = ASImageNode()
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        placeholderNode.attributedText = NSAttributedString(string: "通过标签给联系人进行分类", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor(hexString: "#DDDDDD")
            ])
        
        arrowNode.image = Constants.arrowImage
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        placeholderNode.style.spacingBefore = 20
        placeholderNode.style.flexGrow = 1.0
        arrowNode.style.spacingAfter = 20
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = [placeholderNode, arrowNode]
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
        
        return stack
    }
}
