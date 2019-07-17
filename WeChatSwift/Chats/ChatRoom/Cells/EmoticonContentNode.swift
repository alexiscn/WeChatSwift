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
        super.init(message: message)
        
        addSubnode(imageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let layout = ASInsetLayoutSpec(insets: .zero, child: imageNode)
        layout.style.preferredSize = CGSize(width: 240, height: 240)
        return layout
    }
    
}
