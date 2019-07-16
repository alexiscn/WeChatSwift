//
//  MiniProgramContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MiniProgramContentNode: MessageContentNode {
    
    private let bubbleNode = ASImageNode()
    
    private let appIconNode = ASImageNode()
    
    private let appNameNode = ASTextNode()
    
    private let textNode = ASTextNode()
    
    private let imageNode = ASImageNode()
    
    private let miniLogoNode = ASImageNode()
    
    private let miniTextNode = ASTextNode()
    
    override init(message: Message) {
        super.init(message: message)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let layout = ASStackLayoutSpec.vertical()
        
        let header = ASStackLayoutSpec.horizontal()
        header.children = [appIconNode, appNameNode]
        
        let footer = ASStackLayoutSpec.horizontal()
        footer.children = [miniLogoNode, miniTextNode]
        
        layout.children = [header, textNode, imageNode, footer]
        
        return ASInsetLayoutSpec(insets: .zero, child: layout)
    }
}
