//
//  MomentCellNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/10.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentCellNode: ASCellNode {
    
    private let moment: Moment
    
    private let avatarNode: ASImageNode
    
    private let nameNode: ASButtonNode
    
    private var textNode: ASTextNode?
    
    private var bodyNode: ASDisplayNode?
    
    private let timeNode: ASTextNode
    
    private var sourceNode: ASButtonNode?
    
    private let moreNode: ASButtonNode
    
    private var commentNode: ASDisplayNode?
    
    init(moment: Moment) {
        self.moment = moment
        
        avatarNode = ASImageNode()
        avatarNode.style.preferredSize = CGSize(width: 40, height: 40)
        
        nameNode = ASButtonNode()
        
        textNode = ASTextNode()
        
        timeNode = ASTextNode()
        
        moreNode = ASButtonNode()
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        let timeNodeAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: Colors.DEFAULT_TEXT_DISABLED_COLOR,
            .font: UIFont.systemFont(ofSize: 13)
        ]
        timeNode.attributedText = NSAttributedString(string: "5小时前", attributes: timeNodeAttributes)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let rightStack = ASStackLayoutSpec.vertical()
        rightStack.children = [nameNode]
        
        if let textNode = textNode {
            rightStack.children?.append(textNode)
        }
        
        let footerStack = ASStackLayoutSpec.horizontal()
        let footerSpacer = ASLayoutSpec()
        footerSpacer.style.flexShrink = 1.0
        var footerElements: [ASLayoutElement] = []
        footerElements.append(timeNode)
        if let node = sourceNode {
            footerElements.append(node)
        }
        footerElements.append(footerSpacer)
        footerElements.append(moreNode)
        footerStack.children = footerElements
        rightStack.children?.append(footerStack)
        
        let layoutSpec = ASStackLayoutSpec.horizontal()
        layoutSpec.children = [avatarNode, rightStack]
        return layoutSpec
    }
}

extension MomentCellNode {
    class WebpageContentNode: ASDisplayNode {
        
    }
}
