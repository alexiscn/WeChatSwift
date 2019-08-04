//
//  UserSettings.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import MMKV

class UserSettings {
    
    private let mmkv: MMKV
    
    init(userID: String) {
        let basePath = NSHomeDirectory().appending("/Documents/\(userID)/mmkv")
        MMKV.setMMKVBasePath(basePath)
        mmkv = MMKV(mmapID: userID)!
    }
    
}
