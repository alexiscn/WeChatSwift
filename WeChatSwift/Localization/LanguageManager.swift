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

class LanguageManager {
    
    static let shared = LanguageManager()
    
    var current: AppLanguage {
        get {
            if let list = UserDefaults.standard.value(forKey: "AppleLanguages") as? [String], let lang = list.first {
                return AppLanguage(rawValue: lang) ?? .english
            }
            return .english
        }
        set {
            if newValue == .english {
                UserDefaults.standard.setValue(nil, forKey: "AppleLanguages")
            } else {
                UserDefaults.standard.setValue([newValue.rawValue], forKey: "AppleLanguages")
            }
            Bundle.setLanguage(newValue.rawValue)
        }
    }
    
    private init() { }
    
    func supportedLanguages() -> [AppLanguage] {
        return AppLanguage.allCases
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
        
        /// 回复
        static func reply() -> String { return LocalizedString("Common_Reply") }
        
        /// 重发
        static func resend() -> String { return LocalizedString("Common_Resend") }
        
        /// 重试
        static func retry() -> String { return LocalizedString("Common_Retry") }
        
        /// 返回
        static func `return`() -> String { return LocalizedString("Common_Return") }
        
        /// 保存
        static func save() -> String { return LocalizedString("Common_Save") }
        
        /// 选择
        static func select() -> String { return LocalizedString("Common_Select") }
        
        /// 全选
        static func selectAll() -> String { return LocalizedString("Common_SelectAll") }
        
        /// 发送
        static func send() -> String { return LocalizedString("Common_Send") }
        
        /// 设置
        static func set() -> String { return LocalizedString("Common_Set") }
        
        /// 分享
        static func share() -> String { return LocalizedString("Common_Share") }
        
        /// 跳过
        static func skip() -> String { return LocalizedString("Common_Skip") }
        
        /// 提交
        static func submit() -> String { return LocalizedString("Common_Submit") }
        
        /// 提示
        static func tipTitle() -> String { return LocalizedString("Common_TipTitle") }
        
        /// 撤销
        static func undo() -> String { return LocalizedString("Common_Undo") }
        
        /// 不保存
        static func unSave() -> String { return LocalizedString("Common_UnSave") }
        
        /// 使用
        static func use() -> String { return LocalizedString("Common_Use") }

        /// 请稍候…
        static func wait() -> String { return LocalizedString("Common_Wait") }
        
        /// 是
        static func yes() -> String { return LocalizedString("Common_Yes") }
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
