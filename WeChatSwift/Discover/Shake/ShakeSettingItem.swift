//
//  ShakeSettingItem.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/8.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

struct ShakeSettingSection {
    var items: [ShakeSettingItem]
}

enum ShakeSettingItem {
    case useDefaultBackground
    case changeBackground
    case enablePlaySound(Bool)
    case sayHello
    case history
    case messageList
    
    var title: String {
        switch self {
        case .useDefaultBackground:
            return "使用默认背景图片"
        case .changeBackground:
            return "换张背景图片"
        case .enablePlaySound(_):
            return "音效"
        case .sayHello:
            return "打招呼的人"
        case .history:
            return "摇到的历史"
        case .messageList:
            return "摇一摇消息"
        }
    }
    
    func attributedStringForTitle() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    var showArrowImage: Bool {
        switch self {
        case .useDefaultBackground, .enablePlaySound(_):
            return false
        default:
            return true
        }
    }
    
    var showSwithButton: Bool {
        switch self {
        case .enablePlaySound(_):
            return true
        default:
            return false
        }
    }
}
