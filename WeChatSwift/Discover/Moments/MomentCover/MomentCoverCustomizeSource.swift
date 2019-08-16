//
//  MomentCoverCustomizeSource.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

struct MomentCoverCustomizeSection {
    var items: [MomentCoverCustomizeSource]
}

enum MomentCoverCustomizeSource {
    case albumPhoto
    case takePhoto
    case chooseFromWorks
    
    var title: String {
        switch self {
        case .albumPhoto:
            return "从手机中选择"
        case .takePhoto:
            return "拍一张"
        case .chooseFromWorks:
            return "摄影师作品"
        }
    }
    
    var desc: String? {
        switch self {
        case .chooseFromWorks:
            return "从 Kravanjia 的作品中挑选图片"
        default:
            return nil
        }
    }
    
    func attributedStringForTitle() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: Colors.black
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
    
    func attributedStringForDesc() -> NSAttributedString? {
        guard let desc = desc else { return nil }
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#737373")
        ]
        return NSAttributedString(string: desc, attributes: attributes)
    }
}
