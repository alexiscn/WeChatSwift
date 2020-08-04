//
//  WXScrollActionSheetItem.swift
//  WXActionSheet
//
//  Created by xushuifeng on 2020/6/19.
//

import UIKit

@objc public class WXScrollActionSheetItem: NSObject {
    
    public let identifier: String
    
    public var title: String
    
    public var titleColor: UIColor? = nil
    
    public var iconImage: UIImage?
    
    public var alpha: CGFloat = 1.0
    
    public var userInfo: [String: Any] = [:]
    
    public init(identifier: String, title: String, iconImage: UIImage?) {
        self.identifier = identifier
        self.title = title
        self.iconImage = iconImage
    }
}
