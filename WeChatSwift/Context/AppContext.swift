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
    
    let name: String
    
    let me: MockData.User
    
    let userSettings: UserSettings
    
    let momentCoverManager: MomentCoverManager
    
    private init() {
        me = MockFactory.shared.user(with: "10001")!
        userID = me.identifier
        name = me.name
        userSettings = UserSettings(userID: userID)
        momentCoverManager =  MomentCoverManager(userID: userID)
    }
    
    var userProfileService = UserProfileService()
    
    var emoticonMgr = EmoticonManager()
    
    func doHeavySetup() {
        DispatchQueue.global(qos: .background).async {
            self.emoticonMgr.setup()
        }
    }
}
