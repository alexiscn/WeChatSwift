//
//  MomentCoverCustomizeCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentCoverCustomizeCellNode: ASCellNode {
    
    private let titleNode = ASTextNode()
    
    private let descNode = ASTextNode()
    
    private let arrowNode = ASImageNode()
    
    private let lineNode = ASDisplayNode()
    
    private let source: MomentCoverCustomizeSource
    
    private let isLastCell: Bool
    
    init(source: MomentCoverCustomizeSource, isLastCell: Bool) {
        self.source = source
        self.isLastCell = isLastCell
        super.init()
        automaticallyManagesSubnodes = true
        
        titleNode.attributedText = source.attributedStringForTitle()
        descNode.attributedText = source.attributedStringForDesc()
        arrowNode.image = Constants.arrowImage
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = Colors.white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        titleNode.style.flexGrow = 1.0
        descNode.style.flexGrow = 1.0
        arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
        arrowNode.style.spacingAfter = 20
        
        let height: CGFloat = source.desc == nil ? 44.0: 64.0
        
        var contentElement: ASLayoutElement
        if source.desc == nil {
            
            contentElement = titleNode
        } else {
            let verticalStack = ASStackLayoutSpec.vertical()
            verticalStack.spacing = 4
            verticalStack.style.flexGrow = 1.0
            verticalStack.children = [titleNode, descNode]
            contentElement = verticalStack
        }
        
        contentElement.style.spacingBefore = 20
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.spacing = 16
        stack.alignItems = .center
        stack.children = [contentElement, arrowNode]
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: height)
        
        if isLastCell {
            return ASInsetLayoutSpec(insets: .zero, child: stack)
        } else {
            lineNode.style.preferredSize = CGSize(width: Constants.screenWidth - 20, height: Constants.lineHeight)
            lineNode.style.layoutPosition = CGPoint(x: 20, y: height - Constants.lineHeight)
            return ASAbsoluteLayoutSpec(children: [stack, lineNode])
        }
    }
}
