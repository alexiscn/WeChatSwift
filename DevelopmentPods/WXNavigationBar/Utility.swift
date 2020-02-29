//
//  Utility.swift
//  WXNavigationBar
//
//  Created by xushuifeng on 2020/2/23.
//

import Foundation



func swizzleMethod(_ cls: AnyClass, _ originSelector: Selector, _ newSelector: Selector) {
    guard let oriMethod = class_getInstanceMethod(cls, originSelector),
        let newMethod = class_getInstanceMethod(cls, newSelector) else {
            return
    }
    
    let isAddedMethod = class_addMethod(cls, originSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))
    if isAddedMethod {
        class_replaceMethod(cls, newSelector, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod))
    } else {
        method_exchangeImplementations(oriMethod, newMethod)
    }
}

class Utility {
    
    static var bundle: Bundle? = {
        let current = Bundle(for: Utility.self)
        if let path = current.path(forResource: "Resources", ofType: "bundle") {
            return Bundle(path: path)
        }
        return nil
    }()
    
    class func image(named name: String) -> UIImage? {
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
    static var navigationBarHeight: CGFloat {
        let top = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0
        return top > 0 ? 88.0 : 64.0
    }
}
