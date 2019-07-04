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
            return ("雷达加朋友", "添加身边的朋友")
        case .faceToFaceGroup:
            return ("面对面建群", "与身边的朋友进入同一个群聊")
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
            return UIImage.SVGImage(named: "icons_filled_radar", fillColor: .white)
        case .faceToFaceGroup:
            return UIImage.SVGImage(named: "icons_filled_group-detail", fillColor: .white)
        case .scan:
            return UIImage.SVGImage(named: "icons_filled_scan", fillColor: .white)
        case .phoneContacts:
            return UIImage.SVGImage(named: "icons_filled_mobile-contacts", fillColor: .white)
        case .officialAccounts:
            return UIImage.SVGImage(named: "icons_filled_official-accounts", fillColor: .white)
        case .enterpriseContacts:
            return UIImage(named: "EnterpriseWeworkMenuIcon_30x30_")
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .radar:
            return Colors.purple
        case .faceToFaceGroup:
            return Colors.brand
        case .scan:
            return Colors.indigo
        case .phoneContacts:
            return Colors.brand
        case .officialAccounts:
            return Colors.indigo
        case .enterpriseContacts:
            return Colors.indigo
        }
    }
}
