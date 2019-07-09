//
//  VideoContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class VideoContentNode: MessageContentNode {
    
    var videoNode: ASImageNode = ASImageNode()
    
    override init(message: Message) {
        super.init(message: message)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASLayoutSpec()
    }
    
}
