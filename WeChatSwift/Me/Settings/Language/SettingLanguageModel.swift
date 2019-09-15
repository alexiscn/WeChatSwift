//
//  SettingLanguageModel.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/9/15.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

class SettingLanguageModel {
    
    var language: Language
    
    var isSelected: Bool = false
    
    init(language: Language) {
        self.language = language
    }
}
