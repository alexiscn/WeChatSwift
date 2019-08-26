//
//  MultiSelectContact.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/26.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

struct MultiSelectContactSection {
    
    var title: String
    
    var models: [MultiSelectContact]
    
}

class MultiSelectContact: Contact {
    
    var isSelected: Bool = false
    
    func attributedTextForName() -> NSAttributedString {
        return NSAttributedString(string: name, attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor(white: 0, alpha: 0.9)
        ])
    }
}
