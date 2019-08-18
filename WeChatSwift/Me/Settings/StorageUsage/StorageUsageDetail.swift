//
//  StorageUsageDetail.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

struct StorageUsageDetail {
    
    var title: String
    
    var desc: String
    
    var totalSize: Int
    
    var action: StorageUsageDetailAction
    
}


enum StorageUsageDetailAction {
    case clean
    case manage
    
    var title: String {
        switch self {
        case .clean:
            return "清理"
        case .manage:
            return "管理"
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .clean:
            return UIColor.white
        case .manage:
            return Colors.Brand_90
        }
    }
    
    var backgroundImage: UIImage? {
        switch self {
        case .clean:
            return UIImage.as_resizableRoundedImage(withCornerRadius: 4, cornerColor: nil, fill: Colors.Brand)
        case .manage:
            return UIImage.as_resizableRoundedImage(withCornerRadius: 4, cornerColor: nil, fill: Colors.DEFAULT_BACKGROUND_COLOR)
        }
    }
    
    var highlightBackgroundImage: UIImage? {
        switch self {
        case .clean:
            return UIImage.as_resizableRoundedImage(withCornerRadius: 4, cornerColor: nil, fill: Colors.Brand_80)
        case .manage:
            return UIImage.as_resizableRoundedImage(withCornerRadius: 4, cornerColor: nil, fill: UIColor(hexString: "#EDEDED", alpha: 0.8))
        }
    }
    
    func attributedText() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium),
            NSAttributedString.Key.foregroundColor: titleColor
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
}
