//
//  UIImage+WXActionSheet.swift
//  WXActionSheet
//
//  Created by xu.shuifeng on 2020/7/23.
//

import UIKit

extension UIImage {
    
    class func imageWithColor(_ color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
