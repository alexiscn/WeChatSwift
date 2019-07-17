//
//  DiscoverCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/12.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class DiscoverCellNode: ASCellNode {
    
    private let model: DiscoverModel
    
    private let imageNode = ASImageNode()
    
    private let titleNode = ASTextNode()
    
    private let badgeNode = BadgeNode()
    
    private let arrowNode = ASImageNode()
    
    init(model: DiscoverModel) {
        self.model = model
        super.init()
        
        automaticallyManagesSubnodes = true
        backgroundColor = Colors.white
        imageNode.image = model.image
        titleNode.attributedText = model.attributedStringForTitle()
        arrowNode.image = UIImage.SVGImage(named: "icons_outlined_arrow")
        arrowNode.style.preferredSize = CGSize(width: 12, height: 12)
        if model.unreadCount > 0 {
            badgeNode.update(count: model.unreadCount, showDot: false)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        imageNode.style.spacingBefore = 16
        imageNode.style.spacingAfter = 16
        imageNode.style.preferredSize = CGSize(width: 24, height: 24)
        
//        titleNode.style.flexGrow = 1.0
//        titleNode.style.flexShrink = 1.0
        titleNode.style.spacingAfter = 8
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        spacer.style.flexShrink = 1.0
        
        arrowNode.style.spacingAfter = 16
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        if model.unreadCount > 0 {
            badgeNode.style.preferredSize = CGSize(width: 30, height: 30)
            stack.children = [imageNode, titleNode, badgeNode, spacer, arrowNode]
        } else {
            stack.children = [imageNode, titleNode, spacer, arrowNode]
        }
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0), child: stack)
    }
}
