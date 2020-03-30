//
//  WXColor.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2020/3/22.
//  Copyright © 2020 alexiscn. All rights reserved.
//

import UIKit

// TODO: Adpat dark mode
extension UIColor {
    
    struct wx {
        
        static var isDark: Bool {
            return UIScreen.main.traitCollection.userInterfaceStyle == .dark
        }
        
        static var background: UIColor {
            return isDark ? .black: .white
        }
        
    }
    
}
