//
//  AboutTableModel.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/21.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

enum AboutTableModel: CaseIterable {
    case review
    case introduction
    case report
    case updateVersion
    
    var title: String {
        switch self {
        case .review:
            return "去评分"
        case .introduction:
            return "功能介绍"
        case .report:
            return "投诉"
        case .updateVersion:
            return "版本更新"
        }
    }
    
    func attributedString() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.9)
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
}
