//
//  SettingsTableModel.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/21.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit

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
    case assistant
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
        case .assistant:
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
