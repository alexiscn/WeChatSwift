//
//  ChatRoomCellNodeFactory.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

final class ChatRoomCellNodeFactory {
    
    class func node(for message: Message) -> MessageCellNode {
        var contentNode: MessageContentNode
        switch message.content {
        case .text(let txtMsg):
            contentNode = TextContentNode(message: message, text: txtMsg)
        case .image(let imageMsg):
            contentNode = MessageImageContentNode(message: message, imageMsg: imageMsg)
        case .video(let videoMsg):
            contentNode = VideoContentNode(message: message, videoMsg: videoMsg)
        case .emoticon(let emoticonMsg):
            contentNode = EmoticonContentNode(message: message, emoticon: emoticonMsg)
        case .voice(let voiceMsg):
            contentNode = VoiceContentNode(message: message, voiceMsg: voiceMsg)
        case .location(let locationMsg):
            contentNode = LocationContentNode(message: message, locationMsg: locationMsg)
        case .link(let appURL):
            contentNode = AppURLContentNode(message: message, appURL: appURL)
        case .game(let gameMsg):
            contentNode = GameContentNode(message: message, gameMsg: gameMsg)
        default:
            contentNode = UnknownContentNode(message: message)
        }
        return MessageCellNode(message: message, contentNode: contentNode)
    }
    
}
