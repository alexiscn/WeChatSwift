//
//  MomentBackground.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

struct MomentBackgroundGroup {
    var name: String
    var items: [MomentBackground]
    
    func attributedStringForName() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#909090")
        ]
        return NSAttributedString(string: name, attributes: attributes)
    }
}

struct MomentBackground {
    
    var previewURL: URL?
    
    var url: URL?
    
}
