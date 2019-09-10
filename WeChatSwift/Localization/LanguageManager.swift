//
//  LanguageManager.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/9/10.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

fileprivate var bundleKey: UInt8 = 0

enum Language: String, CaseIterable {
    case none
    case en = "en"
    case zhHans = "zh-Hans"
}

class LanguageManager {
    
    static let shared = LanguageManager()
    
    var current: Language {
        get {
            if let list = UserDefaults.standard.value(forKey: "AppleLanguages") as? [String], let lang = list.first {
                return Language(rawValue: lang) ?? .none
            }
            return .none
        }
        set {
            if newValue == .none {
                UserDefaults.standard.setValue(nil, forKey: "AppleLanguages")
            } else {
                UserDefaults.standard.setValue([newValue.rawValue], forKey: "AppleLanguages")
            }
        }
    }
    
    private init() { }
    
    func supportedLanguages() -> [Language] {
        return Language.allCases
    }
}

fileprivate class LanguageBundle: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String, let bundle = Bundle(path: path) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}

fileprivate extension Bundle {
    class func setLanguage(_ code: String) {
        defer {
            object_setClass(Bundle.main, LanguageBundle.self)
        }
        let path = Bundle.main.path(forResource: code, ofType: "lproj")
        objc_setAssociatedObject(Bundle.main, &bundleKey, path, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}
