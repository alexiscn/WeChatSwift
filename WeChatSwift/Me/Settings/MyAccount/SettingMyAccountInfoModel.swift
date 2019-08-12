//
//  SettingMyAccountInfoModel.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/12.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

struct SettingMyAccountInfoSection {
    
    var items: [SettingMyAccountInfoModel]
    
    var footer: String? = nil
    
    init(items: [SettingMyAccountInfoModel]) {
        self.items = items
    }
}

enum SettingMyAccountInfoModel: WCTableCellModel {
    case wechatId
    case phoneNumber
    case wechatPassword
    case voicePassword
    case emergencyContact
    case deviceManagement
    case moreSecuritySettings
    case freezeAccount
    case securityCenter
    
    var wc_title: String {
        switch self {
        case .wechatId:
            return "微信号"
        case .phoneNumber:
            return "手机号"
        case .wechatPassword:
            return "微信密码"
        case .voicePassword:
            return "声音锁"
        case .emergencyContact:
            return "应急联系人"
        case .deviceManagement:
            return "登录设备管理"
        case .moreSecuritySettings:
            return "更多安全设置"
        case .freezeAccount:
            return "帮朋友冻结微信"
        case .securityCenter:
            return "微信安全中心"
        }
    }
}
