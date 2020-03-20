//
//  UINavigationBar+WXNavigationBar.swift
//  WXNavigationBar
//
//  Created by xushuifeng on 2020/2/27.
//

import UIKit

typealias NavigationBarFrameDidUpdated = (CGRect) -> Void

extension UINavigationBar {
    
    private struct AssociatedKeys {
        static var frameDidUpdated = "frameDidUpdated"
    }
    
    static let swizzleNavigationBarOnce: Void = {
        let cls = UINavigationBar.self
        swizzleMethod(cls, #selector(UINavigationBar.layoutSubviews), #selector(UINavigationBar.wx_layoutSubviews))
    }()
    
    var frameDidUpdated: NavigationBarFrameDidUpdated? {
        get { return objc_getAssociatedObject(self, &AssociatedKeys.frameDidUpdated) as? NavigationBarFrameDidUpdated }
        set { objc_setAssociatedObject(self, &AssociatedKeys.frameDidUpdated, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    @objc private func wx_layoutSubviews() {
        frameDidUpdated?(frame)
        wx_layoutSubviews()
    }
}
