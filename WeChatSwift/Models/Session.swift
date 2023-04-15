//
//  Session.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import WCDBSwift

public class Session {
    
    var sessionID: String
    
    var name: String
    
    var avatarImage: UIImage?
    
    var avatar: URL?
    
    var content: String? = nil
    
    var unreadCount: Int = 0
    
    var showUnreadAsRedDot = false
    
    var stickTop: Bool = false
    
    var muted: Bool = false
    
    var showDrafts: Bool {
        return draft != nil
    }
    
    var draft: String? = nil

    var forceNotify: Bool = false
    
    var chatBackground: String? = nil
    
    public init(sessionID: String, name: String) {
        self.sessionID = sessionID
        self.name = name
    }
}

extension Session {
    
    func attributedStringForTitle() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15.5),
            .foregroundColor: Colors.black
        ]
        return NSAttributedString(string: name, attributes: attributes)
    }
    
    func attributedStringForSubTitle() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(hexString: "9B9B9B")
        ]
        return NSAttributedString(string: content ?? "", attributes: attributes)
    }
    
    func attributedStringForTime() -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 11),
            .foregroundColor: Colors.DEFAUTL_TABLE_INTROL_COLOR
        ]
        return NSAttributedString(string: "12:40", attributes: attributes)
    }
}
