//
//  Message.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

class Message {
    
    var messageID: String = ""
    
    var content: MessageContent = .none
}


enum MessageContent {
    case none
    case text(String)
    case media
    case link(URL)
    
    var sessionContent: String {
        switch self {
        case .text(let body):
            return body
        case .media:
            return "[图片]"
        default:
            return ""
        }
    }
}
