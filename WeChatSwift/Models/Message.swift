//
//  Message.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import WCDBSwift

public class Message: TableCodable {
    
    public enum CodingKeys: String, CodingTableKey {
        public typealias Root = Message
        public static let objectRelationalMapping = TableBinding(CodingKeys.self)
        
        case msgID = "msgID"
        
        public static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
            return [
                msgID: ColumnConstraintBinding(isPrimary: true)
            ]
        }
    }
    
    var msgID: String = ""
    
    var chatID: String = ""
    
    var senderID: String = ""
    
    var content: MessageContent = .none
    
    var time: Int = 0
    
    var _formattedTime: String?
}

public extension Message {
    
    var isOutgoing: Bool { return senderID == AppContext.current.userID }
    
}


public enum MessageContent {
    case none
    case text(String)
    case image(ImageMessage)
    case location(CLLocation)
    case media
    case link(URL)
    case audio(AudioMessage)
    
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

public struct ImageMessage {
    
    var url: URL? = nil
    
    var image: UIImage? = nil
    
    var size: CGSize = .zero
    
    public init(image: UIImage?, size: CGSize) {
        self.image = image
        self.size = size
    }
    
    public init(url: URL?, size: CGSize) {
        self.url = url
        self.size = size
    }
}

public struct AudioMessage {
    
    var duration: Int = 1
    
}
