//
//  ContactSettingModel.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/11.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

struct ContactSettingSection {
    var title: String?
    var items: [ContactSettingModel]
}

enum ContactSettingModel: WCTableCellModel {
    case remakAndTag
    case recommendToFriend
    case markAsStarFriend(Bool)
    case momentForbidden(Bool)
    case momentIgnore(Bool)
    case addToBlackList(Bool)
    case report
    case delete
    
    var wc_title: String {
        switch self {
        case .remakAndTag:
            return "设置备注和标签"
        case .recommendToFriend:
            return "把她推荐给朋友"
        case .markAsStarFriend(_):
            return "设为星标朋友"
        case .momentForbidden(_):
            return "不让她看"
        case .momentIgnore(_):
            return "不看她"
        case .addToBlackList(_):
            return "加入黑名单"
        case .report:
            return "投诉"
        case .delete:
            return "删除"
        }
    }
    
    var wc_showSwitch: Bool {
        switch self {
        case .markAsStarFriend(_), .momentForbidden(_), .momentIgnore(_), .addToBlackList(_):
            return true
        default:
            return false
        }
    }
    
    var wc_switchValue: Bool {
        switch self {
        case .markAsStarFriend(let isOn):
            return isOn
        case .momentForbidden(let isOn):
            return isOn
        case .momentIgnore(let isOn):
            return isOn
        case .addToBlackList(let isOn):
            return isOn
        default:
            return false
        }
    }
    
    var wc_cellStyle: WCTableCellStyle {
        switch self {
        case .delete:
            return .destructiveButton
        default:
            return .default
        }
    }
}
