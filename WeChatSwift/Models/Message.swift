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
import PINRemoteImage

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
    
    func attributedStringForTime() -> NSAttributedString? {
        guard let timeString = _formattedTime else { return nil }
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.4)
        ]
        return NSAttributedString(string: timeString, attributes: attributes)
    }
}


public enum MessageContent {
    case none
    case text(String)
    case image(ImageMessage)
    case location(LocationMessage)
    case media
    case link(AppURLMessage)
    case voice(VoiceMessage)
    case redPacket(RedPacketMessage)
    case emoticon(EmoticonMessage)
    
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

public struct VoiceMessage {
    
    var duration: Int = 1
    
    func attributedStringForDuration() -> NSAttributedString {
        let attributes = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
        NSAttributedString.Key.foregroundColor: Colors.DEFAULT_TEXT_COLOR
        ]
        let text = String(format: "%d\"", duration)
        return NSAttributedString(string: text, attributes: attributes)
    }
}

public struct RedPacketMessage {
    
    var title: String
    
    var amount: Float
}

public struct AppURLMessage {
    
    var URL: URL?
    
    var title: String?
    
    var subTitle: String?
    
    var thumbImage: UIImage?
    
    func attributedStringForTitle() -> NSAttributedString? {
        guard let title = title else { return nil }
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: Colors.black
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func attributedStringForSubTitle() -> NSAttributedString? {
        guard let subTitle = subTitle else { return nil }
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: Colors.DEFAULT_TEXT_GRAY_COLOR
        ]
        return NSAttributedString(string: subTitle, attributes: attributes)
        
    }
}

public struct LocationMessage {
    
    var coordinate: CLLocationCoordinate2D
    
    var thumbImage: UIImage?
    
    var title: String?
    
    var subTitle: String?
    
    func attributedStringForTitle() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: Colors.DEFAULT_TEXT_COLOR
        ]
        return NSAttributedString(string: "望京SOHOT2", attributes: attributes)
    }
    
    func attributedStringForDesc() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: Colors.DEFAULT_TEXT_GRAY_COLOR
        ]
        return NSAttributedString(string: "北京市朝阳区阜通东大街", attributes: attributes)
    }
}

public struct EmoticonMessage {
    var md5: String
    var packageID: String
    
    var url: URL? {
        let folder = NSHomeDirectory().appending("/Documents/emoticons/pics/")
        let filename = folder.appending("\(md5).pic")
        return URL(fileURLWithPath: filename)
    }
}
