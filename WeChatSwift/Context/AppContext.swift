//
//  AppContext.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

class AppContext {
    
    static let current = AppContext()
    
    let userID: String
    
    let userSettings: UserSettings
    
    private init() {
        userID = MockFactory.shared.users.first!.identifier
        userSettings = UserSettings(userID: userID)
    }
    
    var userProfileService = UserProfileService()
    
    var emoticonMgr = EmoticonManager()
    
    func doHeavySetup() {
        DispatchQueue.global(qos: .background).async {
            self.emoticonMgr.setup()
        }
    }
}
