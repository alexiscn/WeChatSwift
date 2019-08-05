//
//  ContactCellNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/13.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactCellNode: ASCellNode {
    
    private let model: ContactModel
    
    private let isLastCell: Bool
    
    private let imageNode = ASImageNode()
    
    private let titleNode = ASTextNode()
    
    private let arrowNode = ASImageNode()
    
    private let lineNode = ASDisplayNode()
    
    init(model: ContactModel, isLastCell: Bool) {
        self.model = model
        self.isLastCell = isLastCell
        super.init()
        
        automaticallyManagesSubnodes = true
        backgroundColor = Colors.white
        
        imageNode.image = model.image
        imageNode.cornerRadius = 4
        imageNode.cornerRoundingType = .clipping
        imageNode.backgroundColor = Colors.white
        
        titleNode.attributedText = NSAttributedString(string: model.name, attributes: [
            .foregroundColor: Colors.black,
            .font: UIFont.systemFont(ofSize: 17)
        ])
        arrowNode.image = UIImage.SVGImage(named: "icons_outlined_arrow")
        arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        imageNode.style.spacingBefore = 16
        imageNode.style.spacingAfter = 16
        imageNode.style.preferredSize = CGSize(width: 40, height: 40)
        
        titleNode.style.flexGrow = 1.0
        titleNode.style.flexShrink = 1.0
        
        arrowNode.style.spacingAfter = 16
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = [imageNode, titleNode, arrowNode]
        
        lineNode.isHidden = isLastCell
        lineNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 72, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: 72, y: 56 - Constants.lineHeight)
        
        let layout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0), child: stack)
        layout.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
        
        return ASAbsoluteLayoutSpec(children: [layout, lineNode])
    }
}
