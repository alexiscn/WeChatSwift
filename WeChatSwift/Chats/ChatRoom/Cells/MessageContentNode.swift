//
//  MessageContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

public class MessageContentNode: ASDisplayNode {
    
    let message: Message
    
    public init(message: Message) {
        self.message = message
        super.init()
    }
    
}
