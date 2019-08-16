//
//  AppLanguage.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

enum AppLanguage: CaseIterable {
    case simplefiedChinese
    case tranditionalTWChinese
    case tranditionalHKChinese
    case japanese
    case english
    case deutsch
    case southKorea
    
    var title: String {
        switch self {
        case .simplefiedChinese:
            return "简体中文"
        case .tranditionalTWChinese:
            return "繁體中文（台灣）"
        case .tranditionalHKChinese:
            return "繁體中文（香港）"
        case .southKorea:
            return "한국어"
        case .japanese:
            return "日本語"
        case .english:
            return "English"
        case .deutsch:
            return "Deutsch"
        }
    }
}

struct LanguageModel {
    
    var language: AppLanguage
    
    var isSelected: Bool
    
}
