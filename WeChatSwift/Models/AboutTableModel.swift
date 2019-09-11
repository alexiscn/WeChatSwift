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
            return LocalizedString("Setting_Score_ScoreWeixin")
        case .introduction:
            return LocalizedString("Whatsnew_text_AboutVersion")
        case .report:
            return LocalizedString("Setting_Expose")
        case .updateVersion:
            return LocalizedString("Setting_Other_Update_Version")
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
