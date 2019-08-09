//
//  SettingsTableModel.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/21.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

struct SettingsTableGroupModel {
    var models: [SettingsTableModel]
}

struct SettingsTableModel {
    var type: SettingsType
    
    var title: String
    
    var value: String? = nil
    
    init(type: SettingsType, title: String) {
        self.type = type
        self.title = title
    }
    
    func attributedStringForTitle() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.9)
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func attributedStringForValue() -> NSAttributedString? {
        guard let value = value else { return nil }
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.5)
        ]
        return NSAttributedString(string: value, attributes: attributes)
    }
}

extension SettingsTableModel: WCTableCellModel {
    
    var wc_title: String { return title }
    
    var wc_image: UIImage? { return nil }
    
    var wc_accessoryNode: ASDisplayNode? {
        guard let value = value else { return nil }
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.5)
        ]
        let textNode = ASTextNode()
        textNode.attributedText = NSAttributedString(string: value, attributes: attributes)
        return textNode
    }
}

enum SettingsType {
    case accountAndSecurity
    case newMessageNotification
    case privacy
    case general
    case helpAndFeedback
    case about
    case plugins
    case switchAccount
    case logout
}


struct SettingGeneralGroup {
    var items: [SettingGeneral]
}

enum SettingGeneral {
    case language
    case font
    case backgroundImage
    case emoticon
    case files
    case earmode
    case discover
    case plugins
    case backup
    case storage
    case clearChatHistory
    
    var title: String {
        switch self {
        case .language:
            return "多语言"
        case .font:
            return "字体"
        case .backgroundImage:
            return "聊天背景"
        case .emoticon:
            return "我的表情"
        case .files:
            return "照片、视频和文件"
        case .earmode:
            return "听筒模式"
        case .discover:
            return "发现页管理"
        case .plugins:
            return "辅助功能"
        case .backup:
            return "聊天记录备份与迁移"
        case .storage:
            return "存储空间"
        case .clearChatHistory:
            return "清空聊天记录"
        }
    }
    
    func attributedStringForTitle() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.9)
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
}

extension SettingGeneral: WCTableCellModel {
    
    var wc_image: UIImage? { return nil }
    
    var wc_title: String { return title }
    
    var wc_showSwitch: Bool {
        return self == .earmode
    }
    
    var wc_switchValue: Bool {
        return true
    }
}


struct SettingPluginSection {
    var title: String
    var items: [SettingPluginItem]
}

enum SettingPluginItem: WCTableCellModel {
    case groupMessageAssistant
    case news
    case weSport
    case qqMail
    
    var wc_title: String {
        switch self {
        case .groupMessageAssistant:
            return "群发助手"
        case .news:
            return "腾讯新闻"
        case .weSport:
            return "微信运动"
        case .qqMail:
            return "QQ邮箱提醒"
        }
    }
    
    var wc_image: UIImage? {
        switch self {
        case .groupMessageAssistant:
            return UIImage(named: "Plugins_groupsms_29x29_")
        case .news:
            return UIImage(named: "Plugins_News_29x29_")
        case .weSport:
            return UIImage(named: "Plugins_WeSport_29x29_")
        case .qqMail:
            return UIImage(named: "Plugins_QQMail_29x29_")
        }
    }
}


struct SettingAutoDownloadSection {
    var title: String
    var items: [SettingAutoDownloadModel]
}

enum SettingAutoDownloadModel: WCTableCellModel {
    case automaticallyDownload(Bool)
    case photoSaveToPhone(Bool)
    case videoSaveToPhone(Bool)
    case automaticallyPlayWWAN(Bool)
    
    var wc_title: String {
        switch self {
        case .automaticallyDownload(_):
            return "自动下载"
        case .photoSaveToPhone(_):
            return "照片"
        case .videoSaveToPhone(_):
            return "视频"
        case .automaticallyPlayWWAN(_):
            return "移动网络下视频自动播放"
        }
    }
    
    var wc_showSwitch: Bool {
        return true
    }
    
    var wc_switchValue: Bool {
        switch self {
        case .automaticallyDownload(let isOn):
            return isOn
        case .photoSaveToPhone(let isOn):
            return isOn
        case .videoSaveToPhone(let isOn):
            return isOn
        case .automaticallyPlayWWAN(let isOn):
            return isOn
        }
    }
}
