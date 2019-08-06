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
    
    private let lineNode = ASDisplayNode()
    
    private let isLastCell: Bool
    
    init(info: ContactInfo, isLastCell: Bool) {
        self.isLastCell = isLastCell
        super.init()
        automaticallyManagesSubnodes = true
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: Colors.DEFAULT_TEXT_COLOR
        ]
        titleNode.attributedText = NSAttributedString(string: info.title, attributes: attributes)
        arrowNode.image = UIImage.SVGImage(named: "icons_outlined_arrow")
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = Colors.white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
        titleNode.style.spacingBefore = 16
        arrowNode.style.spacingAfter = 16
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = [titleNode, spacer, arrowNode]
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
        
        lineNode.isHidden = isLastCell
        lineNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 16, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: 16, y: 56 - Constants.lineHeight)
        
        return ASAbsoluteLayoutSpec(children: [stack, lineNode])
    }
}
