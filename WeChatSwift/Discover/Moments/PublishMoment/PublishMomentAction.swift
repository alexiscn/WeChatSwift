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
    
    func attributedStringForTitle() -> NSAttributedString? {
        guard let title = title else { return nil }
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.9)
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    var topLineSpacingBefore: CGFloat {
        switch self {
        case .location:
            return 36.0
        case .remind:
            return 76.0
        case .permission:
            return 36.0
        default:
            return 0.0
        }
    }
    
    var bottomLineSpacingBefore: CGFloat {
        switch self {
        case .permission:
            return 36.0
        default:
            return 0.0
        }
    }
    
    var bottomLineHidden: Bool { return self != .permission }
}
