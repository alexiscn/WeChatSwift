//
//  Language.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

enum Language: String, CaseIterable, Equatable {
    case simplefiedChinese = "zh-Hans"
    case tranditionalTWChinese = "zh-Tw"
    case tranditionalHKChinese = "zh-HK"
    case japanese = "jp"
    case english = "en"
    case deutsch = "de"
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
    
    static func == (lhs: Language, rhs: Language) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}


