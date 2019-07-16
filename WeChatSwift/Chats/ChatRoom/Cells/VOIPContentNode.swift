//
//  VOIPContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class VOIPContentNode: MessageContentNode {
    
    private let bubbleNode = ASImageNode()
    
    private let iconNode = ASImageNode()
    
    private let textNode = ASImageNode()
    
    override init(message: Message) {
        super.init(message: message)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASLayoutSpec()
    }
    
}
