//
//  PublishMomentCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/15.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class PublishMomentCellNode: ASCellNode {
    
    private let iconNode = ASImageNode()
    
    private let titleNode = ASTextNode()
    
    private let arrowNode = ASImageNode()
    
    private let topLineNode = ASDisplayNode()
    
    private let bottomLineNode = ASDisplayNode()
    
    private let action: PublishMomentAction
    
    init(action: PublishMomentAction) {
        self.action = action
        super.init()
        automaticallyManagesSubnodes = true
        
        iconNode.image = action.iconImage
        titleNode.attributedText = action.attributedStringForTitle()
        arrowNode.image = Constants.arrowImage
        
        topLineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
        
        bottomLineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
        bottomLineNode.isHidden = action.bottomLineHidden
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        iconNode.style.preferredSize = CGSize(width: 24, height: 24)
        iconNode.style.spacingBefore = 36.0
        
        arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
        arrowNode.style.spacingAfter = 36.0
        
        titleNode.style.flexGrow = 1.0
        titleNode.style.spacingBefore = 16
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56.0)
        stack.alignItems = .center
        stack.children = [iconNode, titleNode, arrowNode]
        
        topLineNode.style.preferredSize = CGSize(width: constrainedSize.max.width - action.topLineSpacingBefore - 30.0, height: Constants.lineHeight)
        topLineNode.style.layoutPosition = CGPoint(x: action.topLineSpacingBefore, y: 0)
        
        bottomLineNode.style.preferredSize = CGSize(width: constrainedSize.max.width - action.bottomLineSpacingBefore - 30.0, height: Constants.lineHeight)
        bottomLineNode.style.layoutPosition = CGPoint(x: action.bottomLineSpacingBefore, y: 56.0 - Constants.lineHeight)
        
        let layout = ASAbsoluteLayoutSpec(children: [topLineNode, stack, bottomLineNode])
        layout.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56.0)
        return layout
    }
    
}
