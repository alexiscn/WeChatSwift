//
//  NavigationStyle.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/1.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

public final class NavigationStyle {
    
    public var alpha: CGFloat = 1.0
    
    public var barTintColor: UIColor?
    
    public var tintColor: UIColor? = nil
    
    public var shadowImage: UIImage? = nil
    
    public var isTranslucent: Bool = true
    
    public var barStyle: UIBarStyle = .default
    
    public var statusBarStyle: UIStatusBarStyle = .default
    
    public var additionalHeight: CGFloat = 0.0
    
    var backgroundImage: UIImage?
    
    public func setBackgroundImage(
        _ backgroundImage: UIImage,
        for barPosition: UIBarPosition = .any,
        barMetrics: UIBarMetrics = .default) {
        self.backgroundImage = backgroundImage
    }
}
