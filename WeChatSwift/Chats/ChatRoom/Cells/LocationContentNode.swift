//
//  LocationContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class LocationContentNode: MessageContentNode {
    
    private let bubbleNode = ASImageNode()
    
    private let loadingNode = ASImageNode()
    
    private let titleNode = ASTextNode()
    
    private let descNode = ASTextNode()
    
    private let hairlineNode = ASDisplayNode()
    
    private let thumbNode = ASImageNode()
    
    init(message: Message, locationMsg: LocationMessage) {
        super.init(message: message)
        
        automaticallyManagesSubnodes = true
        
        titleNode.maximumNumberOfLines = 1
        descNode.maximumNumberOfLines = 1
        
        titleNode.attributedText = locationMsg.attributedStringForTitle()
        descNode.attributedText = locationMsg.attributedStringForDesc()
        thumbNode.image = locationMsg.thumbImage
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let layout = ASStackLayoutSpec.vertical()
        
        titleNode.style.spacingBefore = 12
        titleNode.style.spacingAfter = 12
        titleNode.style.preferredSize = CGSize(width: 231, height: 20)
        
        descNode.style.spacingBefore = 12
        descNode.style.spacingAfter = 12
        descNode.style.preferredSize = CGSize(width: 231, height: 15)
        
        let topStack = ASStackLayoutSpec.vertical()
        topStack.style.flexGrow = 1.0
        topStack.style.flexShrink = 1.0
        topStack.children = [titleNode, descNode]
        
        hairlineNode.style.preferredSize = CGSize(width: 255, height: Constants.lineHeight)
        thumbNode.style.preferredSize = CGSize(width: 255, height: 95)
        layout.children = [topStack, hairlineNode, thumbNode]
        
        return layout
    }
}
