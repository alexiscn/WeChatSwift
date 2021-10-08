//
//  SettingPrivacyModel.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

struct SettingPrivacySection {
    var header: String?
    var items: [SettingPrivacyModel]
    var footer: String?
    
    var heightForHeader: CGFloat = 8.0
    
    var heightForFooter: CGFloat = 8.0
    
    init(header: String?, items: [SettingPrivacyModel], footer: String?) {
        self.header = header
        self.items = items
        self.footer = footer
        
        
        if let header = header {
            let maxSize = CGSize(width: Constants.screenWidth - 32, height: .greatestFiniteMagnitude)
            let size = header.boundingSize(with: maxSize, font: UIFont.systemFont(ofSize: 14))
            heightForHeader = size.height + 12
        }
        
        if let footer = footer {
            let maxSize = CGSize(width: Constants.screenWidth - 32, height: .greatestFiniteMagnitude)
            let size = footer.boundingSize(with: maxSize, font: UIFont.systemFont(ofSize: 14))
            heightForFooter = size.height + 12
        }
    }
}

enum SettingPrivacyModel: WCTableCellModel {
    case enableVerifyWhenAddMe(Bool)
    case wayToAddMe
    case enableAdressbookContacts(Bool)
    case blacklist
    case momentForbidden
    case momentIgnore
    case momentTime(String)
    case momentAllowStranger(Bool)
    case momentUpdateNotify(Bool)
    case authorization
    
    var wc_title: String {
        switch self {
        case .enableVerifyWhenAddMe(_):
            return "加我为朋友时需要验证"
        case .wayToAddMe:
            return "添加我的方式"
        case .enableAdressbookContacts(_):
            return "向我推荐通讯录好友"
        case .blacklist:
            return "通讯录黑名单"
        case .momentForbidden:
            return "不让他(她)看"
        case .momentIgnore:
            return "不看他(她)"
        case .momentTime(_):
            return "允许朋友查看朋友圈的范围"
        case .momentAllowStranger(_):
            return "允许陌生人查看十条朋友圈"
        case .momentUpdateNotify(_):
            return "朋友圈更新提醒"
        case .authorization:
            return "授权管理"
        }
    }
    
    var wc_showSwitch: Bool {
        switch self {
        case .enableVerifyWhenAddMe(_):
            return true
        case .enableAdressbookContacts(_):
            return true
        case .momentAllowStranger(_):
            return true
        case .momentUpdateNotify(_):
            return true
        default:
            return false
        }
    }
    
    var wc_switchValue: Bool {
        switch self {
        case .enableVerifyWhenAddMe(let isOn):
            return isOn
        case .enableAdressbookContacts(let isOn):
            return isOn
        case .momentAllowStranger(let isOn):
            return isOn
        case .momentUpdateNotify(let isOn):
            return isOn
        default:
            return false
        }
    }
}
