//
//  AddContactSource.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

enum AddContactSource {
    case radar
    case faceToFaceGroup
    case scan
    case phoneContacts
    case officialAccounts
    case enterpriseContacts
    
    var titles: (String, String) {
        switch self {
        case .radar:
            return (LocalizedString("RadarSearch_Cell"), LocalizedString("RadarSearch_Cell_Detail"))
        case .faceToFaceGroup:
            return (LocalizedString("RadarSearch_CreateRoom_Title"), LocalizedString("RadarSearch_CreateRoomCell_FindFriend_Detail"))
        case .scan:
            return ("扫一扫", "扫描二维码名片")
        case .phoneContacts:
            return ("手机联系人", "添加通讯录中的朋友")
        case .officialAccounts:
            return ("公众号", "获取更多资讯和服务")
        case .enterpriseContacts:
            return ("企业微信联系人", "通过手机号搜索企业微信用户")
        }
    }
    
    var image: UIImage? {
        switch self {
        case .radar:
            return UIImage(named: "add_friend_icon_reda_36x36_")
        case .faceToFaceGroup:
            return UIImage(named: "add_friend_icon_addgroup_36x36_")
        case .scan:
            return UIImage(named: "add_friend_icon_scanqr_36x36_")
        case .phoneContacts:
            return UIImage(named: "add_friend_icon_contacts_36x36_")
        case .officialAccounts:
            return UIImage(named: "add_friend_icon_offical_36x36_")
        case .enterpriseContacts:
            return UIImage(named: "add_friend_icon_search_wework_40x40_")
        }
    }
    
    func attributedStringForTitle(_ title: String) -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#181818")
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func attributedStringForDesc(_ desc: String) -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#808080")
        ]
        return NSAttributedString(string: desc, attributes: attributes)
    }
}
