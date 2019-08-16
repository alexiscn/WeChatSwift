//
//  StorageUsageDetail.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

struct StorageUsageDetail {
    
    var title: String
    
    var desc: String
    
    var totalSize: Int
    
    var action: StorageUsageDetailAction
    
}


enum StorageUsageDetailAction {
    case clean
    case manage
}
