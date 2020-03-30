//
//  UIApplication+WXNavigationBar.swift
//  WXNavigationBar
//
//  Created by xushuifeng on 2020/3/20.
//

import UIKit

extension UIApplication {
    
    static let runOnce: Void = {
        UINavigationController.swizzleNavigationControllerOnce
        UIViewController.swizzleUIViewControllerOnce
        UINavigationBar.swizzleNavigationBarOnce
    }()
    
// Not working when debuging with Xcode 11.4 on iOS 13.4
//    override open var next: UIResponder? {
//        // Called before applicationDidFinishLaunching
//        UIApplication.runOnce
//        return super.next
//    }
}
