//
//  UIApplication+WXNavigationBar.swift
//  WXNavigationBar
//
//  Created by xushuifeng on 2020/3/20.
//

import UIKit

extension UIApplication {
    
    private static let runOnce: Void = {
        UINavigationController.swizzleNavigationControllerOnce
        UIViewController.swizzleUIViewControllerOnce
        UINavigationBar.swizzleNavigationBarOnce
    }()
    
    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        UIApplication.runOnce
        return super.next
    }
}
