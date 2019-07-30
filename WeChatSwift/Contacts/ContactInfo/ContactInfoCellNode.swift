//
//  ContactInfoCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/30.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactInfoCellNode: ASCellNode {
    
    private let titleNode = ASTextNode()
    
    private let arrowNode = ASImageNode()
    
    init(info: ContactInfo) {
        super.init()
        automaticallyManagesSubnodes = true
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: Colors.DEFAULT_TEXT_COLOR
        ]
        titleNode.attributedText = NSAttributedString(string: info.title, attributes: attributes)
        arrowNode.image = UIImage.SVGImage(named: "icons_outlined_arrow")
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = Colors.white
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
