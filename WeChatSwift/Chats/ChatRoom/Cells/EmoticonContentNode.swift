//
//  EmoticonContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonContentNode: MessageContentNode {
    
    private let imageNode = ASNetworkImageNode()
    
    init(message: Message, emoticon: EmoticonMessage) {
        
        imageNode.shouldCacheImage = false
        
        super.init(message: message)
        
        addSubnode(imageNode)
        imageNode.url = emoticon.url
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        imageNode.style.preferredSize = CGSize(width: 120, height: 120)
        
        let layout = ASInsetLayoutSpec(insets: .zero, child: imageNode)
        return layout
    }
    
}
