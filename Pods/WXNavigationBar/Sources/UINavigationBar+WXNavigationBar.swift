//
//  UINavigationBar+WXNavigationBar.swift
//  WXNavigationBar
//
//  Created by xushuifeng on 2020/2/27.
//

import UIKit

typealias NavigationBarFrameUpdatedHandler = (CGRect) -> Void

// Expericemental
extension UINavigationBar {
    
    private struct AssociatedKeys {
        static var frameUpdatedHandler = "WXNavigationBar_frameUpdatedHandler"
    }
    
    static let wx_swizzle: Void = {
        let cls = UINavigationBar.self
        swizzleMethod(cls, #selector(UINavigationBar.layoutSubviews), #selector(UINavigationBar.wx_layoutSubviews))
    }()
    
    var frameUpdatedHandler: NavigationBarFrameUpdatedHandler? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.frameUpdatedHandler) as? NavigationBarFrameUpdatedHandler
        }
        set {
            objc_setAssociatedObject(self,
                                     &AssociatedKeys.frameUpdatedHandler,
                                     newValue,
                                     .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }

    @objc private func wx_layoutSubviews() {
        frameUpdatedHandler?(frame)
        wx_layoutSubviews()
    }
    
}
