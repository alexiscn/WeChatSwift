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

class Contact {
    
    var name: String = ""
    
    var avatar: UIImage? = nil
}
