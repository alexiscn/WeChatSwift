//
//  String+Extensions.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2020/8/6.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

extension String {
    
    func boundingSize(with maxSize: CGSize, font: UIFont) -> CGSize {
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        return (self as NSString).boundingRect(with: maxSize, options: options, attributes: [
            .font: font
            ], context: nil).size
    }
    
}
