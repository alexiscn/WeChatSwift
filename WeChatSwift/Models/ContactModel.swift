//
//  ContactModel.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

struct ContactSection {
    
    var title: String
    
    var models: [ContactModel]
    
}

enum ContactModel {
    
    case newFriends
    case groupChats
    case tags
    case officialAccounts
    case contact(_ user: Contact)
    
    var name: String {
        switch self {
        case .newFriends:
            return "新的朋友"
        case .groupChats:
            return "群聊"
        case .tags:
            return "标签"
        case .officialAccounts:
            return "公众号"
        case .contact(let user):
            return user.name
        }
    }
    
    var image: UIImage? {
        switch self {
        case .newFriends:
            return UIImage(named: "plugins_FriendNotify_36x36_")
        case .groupChats:
            return UIImage(named: "add_friend_icon_addgroup_36x36_")
        case .tags:
            return UIImage(named: "Contact_icon_ContactTag_36x36_")
        case .officialAccounts:
            return UIImage(named: "add_friend_icon_offical_36x36_")
        case .contact(let user):
            return user.avatar
        }
    }
}

extension ContactModel: WCTableCellModel {
    
    var wc_title: String { return name }
    
    var wc_image: UIImage? { return image }
    
    var wc_imageLayoutSize: CGSize { return CGSize(width: 40, height: 40) }
    
    var wc_imageCornerRadius: CGFloat { return 4.0 }
    
    var wc_showArrow: Bool { return false }
}

class Contact {
    
    var name: String = ""
    
    var avatar: UIImage? = nil
}

enum ContactInfo {
    case remark
    case moments
    case more
    case sendMessage
    case voip
    
    var title: String {
        switch self {
        case .remark:
            return "设置备注和标签"
        case .moments:
            return "朋友圈"
        case .more:
            return "更多信息"
        case .sendMessage:
            return "发消息"
        case .voip:
            return "音视频通话"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .sendMessage:
            return UIImage.SVGImage(named: "icons_outlined_chats")
        case .voip:
            return UIImage.SVGImage(named: "icons_outlined_videocall")
        default:
            return nil
        }
    }
}

struct ContactInfoGroup {
    var items: [ContactInfo]
}


struct ContactTag {
    var title: String
    var users: [Contact]
    
    func attributedStringForTitle() -> NSAttributedString {
        let text = "\(title)(\(users.count))"
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#353535")
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    func attributedStringForDesc() -> NSAttributedString {
        let text = users.map { return $0.name }.joined(separator: ",")
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: Colors.DEFAULT_TEXT_GRAY_COLOR
        ]
        return NSAttributedString(string: text, attributes: attributes)
    }
}
