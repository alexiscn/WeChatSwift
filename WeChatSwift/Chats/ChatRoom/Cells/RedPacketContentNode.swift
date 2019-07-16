//
//  RedPacketContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class RedPacketContentNode: MessageContentNode {
    
    private let bubbleNode = ASImageNode()
    
    private let iconNode = ASImageNode()
    
    private let titleNode = ASTextNode()
    
    override init(message: Message) {
        super.init(message: message)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASLayoutSpec()
    }
}
