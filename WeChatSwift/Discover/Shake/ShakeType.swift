//
//  ShakeType.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/8.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

enum ShakeType: String {
    case people
    case music
    case tv
    
    var image: UIImage? {
        let name = "Shake_icon_\(self.rawValue)_38x34_"
        return UIImage(named: name)
    }
    
    var highlightImage: UIImage? {
        let name = "Shake_icon_\(self.rawValue)HL_38x34_"
        return UIImage(named: name)
    }
    
    var title: String {
        switch self {
        case .people:
            return "人"
        case .music:
            return "歌曲"
        case .tv:
            return "电视"
        }
    }
    
    func attributedStringForTitleNormal() -> NSAttributedString {
        return NSAttributedString(string: title, attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor(hexString: "#B2B2B2")
            ])
    }
    
    func attributedStringForTitleSelected() -> NSAttributedString {
        return NSAttributedString(string: title, attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: Colors.Brand
            ])
    }
}
