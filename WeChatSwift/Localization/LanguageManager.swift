//
//  LanguageManager.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/9/10.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

fileprivate var bundleKey: UInt8 = 0

func LocalizedString(_ key: String) -> String {
    return LanguageManager.shared.getLocalizedString(key)
}

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
    
    func getLocalizedString(_ key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
    
    struct Common {
        
        static func add() -> String { return LocalizedString("Common_Add") }
        
        static func all() -> String { return LocalizedString("Common_All") }
        
        static func allow() -> String { return LocalizedString("Common_Allow") }
        
        static func call() -> String { return LocalizedString("Common_Call") }
        
        static func cancel() -> String { return LocalizedString("Common_Cancel") }
        
        static func clearAll() -> String { return LocalizedString("Common_ClearAll") }
        
        static func close() -> String { return LocalizedString("Common_Close") }
        
        static func commit() -> String { return LocalizedString("Common_Commit") }
        
        static func confirm() -> String { return LocalizedString("Common_Confirm") }

        static func `continue`() -> String { return LocalizedString("Common_Continue") }
        
        static func copyLink() -> String { return LocalizedString("Common_CopyLink") }
        
        static func debug() -> String { return LocalizedString("Common_Debug") }
        
        static func defaultLoadingText() -> String { return LocalizedString("Common_DefaultLoadingText") }
        
        static func delete() -> String { return LocalizedString("Common_Delete") }
        
        static func deleteAll() -> String { return LocalizedString("Common_DeleteAll") }
        
        static func deleting() -> String { return LocalizedString("Common_Deleting") }
        
        static func disAllowed() -> String { return LocalizedString("Common_DisAllowed") }
        
        static func done() -> String { return LocalizedString("Common_Done") }
        
        static func download() -> String { return LocalizedString("Common_Download") }
        
        static func edit() -> String { return LocalizedString("Common_Edit") }
        
        static func errorNetwork() -> String { return LocalizedString("Common_Error_Network") }
        
        static func exit() -> String { return LocalizedString("Common_Exit") }
        
        static func forward() -> String { return LocalizedString("Common_Forward") }
        
        static func freeForSale() -> String { return LocalizedString("Common_FreeForSale") }

        static func IKnow() -> String { return LocalizedString("Common_I_Know") }
        
        static func know() -> String { return LocalizedString("Common_Know") }
        
        static func list() -> String { return LocalizedString("Common_List") }
        
        static func lookDetail() -> String { return LocalizedString("Common_Look_Detail") }
        
        static func memoryWarning() -> String { return LocalizedString("Common_MemoryWarning") }
        
        static func more() -> String { return LocalizedString("Common_More") }
        
        static func nextStep() -> String { return LocalizedString("Common_NextStep") }
        
        static func no() -> String { return LocalizedString("Common_No") }
        
        static func notSelectAll() -> String { return LocalizedString("Common_Not_SelectAll") }
        
        static func noTitle() -> String { return LocalizedString("Common_NoTitle") }
        
        static func oOfficialNickName() -> String { return LocalizedString("Common_OfficialNickName") }
        
        static func ok() -> String { return LocalizedString("Common_OK") }
        
        static func productName() -> String { return LocalizedString("Common_ProductName") }
        
        static func refresh() -> String { return LocalizedString("Common_Refresh") }
//
//        "Common_Reply" = "回复";
//
//        "Common_Resend" = "重发";
//
//        "Common_Retry" = "重试";
//
//        "Common_Return" = "返回";
//
//        "Common_Save" = "保存";
//
//        "Common_Select" = "选择";
//
//        "Common_SelectAll" = "全选";
//
//        "Common_Send" = "发送";
//
//        "Common_Set" = "设置";
//
//        "Common_Share" = "分享";
//
//        "Common_Skip" = "跳过";
//
//        "Common_Submit" = "提交";
//
//        "Common_TipTitle" = "提示";
//
//        "Common_TipTitle_WenXing" = "提示";
//
//        "Common_Undo" = "撤销";
//
//        "Common_UnSave" = "不保存";
//
//        "Common_Use" = "使用";
//
//        "Common_Wait" = "请稍候…";
//
//        "Common_Yes" = "是";
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
