//
//  AppURLContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class AppURLContentNode: MessageContentNode {
    
    private let titleNode = ASTextNode()
    
    private let subTitleNode = ASTextNode()
    
    private let thumbNode = ASImageNode()
    
    init(message: Message, appURL: AppURLMessage) {
        
        titleNode.maximumNumberOfLines = 2
        subTitleNode.maximumNumberOfLines = 2
        
        super.init(message: message)
        
        titleNode.attributedText = appURL.attributedStringForTitle()
        subTitleNode.attributedText = appURL.attributedStringForSubTitle()
        thumbNode.image = appURL.thumbImage
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let vertical = ASStackLayoutSpec.vertical()
        
        titleNode.style.flexGrow = 1.0
        titleNode.style.flexShrink = 1.0
        
        subTitleNode.style.flexGrow = 1.0
        subTitleNode.style.flexShrink = 1.0
        
        thumbNode.style.preferredSize = CGSize(width: 45.0, height: 45.0)
        
        let bottom = ASStackLayoutSpec.horizontal()
        bottom.children = [subTitleNode, thumbNode]
        
        vertical.children = [titleNode, bottom]
        
        vertical.style.preferredSize = CGSize(width: 255, height: 110)
        return vertical
    }
    
}
