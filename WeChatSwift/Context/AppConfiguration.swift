//
//  AppConfiguration.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/9/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

enum AppConfiguration: String {
    case debug
    case inhouse
    case release
    
    static func current() -> AppConfiguration {
        #if DEBUG
        return .debug
        #elseif INHOUSE
        return .inhouse
        #else
        return .release
        #endif
    }

}
