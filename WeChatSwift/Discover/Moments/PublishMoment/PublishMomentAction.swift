//
//  PublishMomentAction.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/15.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

enum PublishMomentAction {
    case location
    case remind
    case permission
    case share
    
    var iconImage: UIImage? {
        switch self {
        case .location:
            return UIImage.SVGImage(named: "icons_outlined_location")
        case .remind:
            return UIImage.SVGImage(named: "icons_outlined_at")
        case .permission:
            return UIImage.SVGImage(named: "icons_outlined_me")
        default:
            return nil
        }
    }
    
    var title: String? {
        switch self {
        case .location:
            return "所在位置"
        case .remind:
            return "提醒谁看"
        case .permission:
            return "谁可以看"
        default:
            return nil
        }
    }
}
