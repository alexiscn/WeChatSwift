//
//  AddContactSource.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/4.
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
            return (LocalizedString("FF_Entry_QRCode_InAdd"), LocalizedString("FF_Entry_QRCode_InAdd_Detail"))
        case .phoneContacts:
            return (LocalizedString("FF_Entry_AddFriendList"), LocalizedString("FF_Entry_AddFriendList_Detail"))
        case .officialAccounts:
            return (LocalizedString("FF_Entry_StarList"), LocalizedString("FF_Entry_StarList_Detail"))
        case .enterpriseContacts:
            return (LocalizedString("FF_Entry_AddFriendList_OpenIM"), LocalizedString("FF_Entry_AddFriendList_OpenIM_Detail"))
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
