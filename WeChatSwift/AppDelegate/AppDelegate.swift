//
//  AppDelegate.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/3.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import SnapKit
import AsyncDisplayKit
import FLEX
import WXNavigationBar

typealias RelayCommand = () -> Void

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var rootViewController: RootViewController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        rootViewController = RootViewController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
        if #available(iOS 13, *) {
            
        } else {
          injectLongPressGestureToStatusBar()
        }
        AppContext.current.doHeavySetup()
        
        UIView.fixTabBarButtonFrame()
        return true
    }
    
    private func injectLongPressGestureToStatusBar() {
        if let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow {
            let statusBar = statusBarWindow.subviews.first
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressStatusBar(_:)))
            statusBar?.addGestureRecognizer(longPress)
        }
    }
    
    @objc private func handleLongPressStatusBar(_ gesture: UILongPressGestureRecognizer) {
        if AppConfiguration.current() == .debug && gesture.state == .began {
            FLEXManager.shared()?.showExplorer()
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

