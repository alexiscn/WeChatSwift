//
//  MomentGroupTag.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/9/10.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation

enum MomentGroupTagType {
    case `public`
    case secrect
    case allow([Contact])
    case forbidden([Contact])
    
    var title: String {
        switch self {
        case .public:
            return "公开"
        case .secrect:
            return "私密"
        case .allow(_):
            return "部分可见"
        case .forbidden(_):
            return "不给谁看"
        }
    }
    
    var desc: String {
        switch self {
        case .public:
            return "所有朋友可见"
        case .secrect:
            return "仅自己可见"
        case .allow(_):
            return "选中的朋友可见"
        case .forbidden(_):
            return "选中的朋友不可见"
        }
    }
}

class MomentGroupTag {
    
    var type: MomentGroupTagType
    
    var isSelected: Bool
    
    var expanded: Bool = false
    
    init(type: MomentGroupTagType, isSelected: Bool = false) {
        self.type = type
        self.isSelected = isSelected
    }
}
