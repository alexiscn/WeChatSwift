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
