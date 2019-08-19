//
//  UIView+Extensions.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/19.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

extension UIView {
    
    func toImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        var thumb: UIImage? = nil
        if let ctx = UIGraphicsGetCurrentContext() {
            ctx.clear(bounds)
            self.drawHierarchy(in: bounds, afterScreenUpdates: true)
            thumb = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
        return thumb
    }
    
}
