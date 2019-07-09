//
//  ChatRoomCellNodeFactory.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

final class ChatRoomCellNodeFactory {
    
    class func node(for message: Message) -> MessageCellNode {
        var contentNode: MessageContentNode
        switch message.content {
        case .text(_):
            contentNode = TextContentNode(message: message)
        case .image(_):
            contentNode = ImageContentNode(message: message)
        default:
            contentNode = UnknownContentNode(message: message)
        }
        return MessageCellNode(message: message, contentNode: contentNode)
    }
    
}
