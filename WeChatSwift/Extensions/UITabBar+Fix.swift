//
//  UITabBar+Fix.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/7.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

extension UIView {
    
    private static let swizzleTabBarButtonFrame: Void = {
        guard #available(iOS 12.1, *) else { return }
        guard let cls = NSClassFromString("UITabBarButton") else { return }
        let originalSelector = #selector(setter: UIView.frame)
        let swizzledSelector = #selector(UIView.wc_setFrame)
        guard let originalMethod = class_getInstanceMethod(cls, originalSelector),
            let swizzledMethod = class_getInstanceMethod(cls, swizzledSelector) else {
            return
        }
        let isSuccess = class_addMethod(cls,
                                       originalSelector,
                                       method_getImplementation(swizzledMethod),
                                       method_getTypeEncoding(swizzledMethod))
        if (isSuccess) {
            class_replaceMethod(cls,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }()
    
    @objc func wc_setFrame(frame: CGRect) {
        var newFrame: CGRect = frame
        if !self.frame.isEmpty {
            guard !newFrame.isEmpty else {
                return
            }
            newFrame.size.height = newFrame.size.height > 48.0 ? newFrame.size.height : 48.0
        }
        self.wc_setFrame(frame: newFrame)
    }
    
    class func fixTabBarButtonFrame() {
        UIView.swizzleTabBarButtonFrame
    }
}
