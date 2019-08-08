//
//  AppDelegate+TabBar.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import SVGKit

extension AppDelegate {
    
    func setupTaBar() {
        ASDisableLogging()
        
        chatsVC.tabBarItem.selectedImage = HomeTab.chats.selectedImage
        chatsVC.tabBarItem.image = HomeTab.chats.image
        chatsVC.tabBarItem.title = "微信"
        chatsVC.tabBarItem.tag = 0
        
        contactsVC.tabBarItem.selectedImage = HomeTab.contacts.selectedImage
        contactsVC.tabBarItem.image = HomeTab.contacts.image
        contactsVC.tabBarItem.title = "通讯录"
        contactsVC.tabBarItem.tag = 1
        
        discoverVC.tabBarItem.selectedImage = HomeTab.discover.selectedImage
        discoverVC.tabBarItem.image = HomeTab.discover.image
        discoverVC.tabBarItem.title = "发现"
        discoverVC.tabBarItem.tag = 2
        
        meVC.tabBarItem.selectedImage = HomeTab.me.selectedImage
        meVC.tabBarItem.image = HomeTab.me.image
        meVC.tabBarItem.title = "我"
        meVC.tabBarItem.tag = 3
        
        tabBarVC = ASTabBarController()
        let chatNav = navigationController(with: chatsVC)
        let contactsNav = navigationController(with: contactsVC)
        let discoverNav = navigationController(with: discoverVC)
        let meNav = navigationController(with: meVC)
        
        let viewControllers = [chatNav, contactsNav, discoverNav, meNav]
        tabBarVC.viewControllers = viewControllers
        for vc in viewControllers {
            vc.tabBarItem.setTitleTextAttributes([
                .foregroundColor: Colors.tintColor,
                .font: UIFont.systemFont(ofSize: 10.5, weight: .thin)], for: .selected)
            vc.tabBarItem.setTitleTextAttributes([
                .foregroundColor: Colors.black,
                .font: UIFont.systemFont(ofSize: 10.5, weight: .thin)], for: .normal)
        }
          
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(UIImage.imageFromColor(.clear), for: .normal, barMetrics: .default)
        
        window?.rootViewController = tabBarVC
    }
    
    func navigationController(with rootViewController: UIViewController) -> UINavigationController {
        let navigationController = SFNavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.isTranslucent = false
        let backgroundImage = UIImage.imageFromColor(Colors.DEFAULT_BACKGROUND_COLOR)
        navigationController.navigationBar.setBackgroundImage(backgroundImage, for: .default)
        navigationController.navigationBar.backIndicatorImage = UIImage.SVGImage(named: "icons_outlined_back")
        navigationController.navigationBar.backIndicatorTransitionMaskImage = UIImage.SVGImage(named: "icons_outlined_back")
        return navigationController
    }
}

class SFNavigationController: ASNavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}

enum HomeTab: String {
    case chats
    case contacts
    case discover
    case me
    
    var selectedImage: UIImage? {
        get {
            let name = "icons_filled_\(rawValue)"
            return UIImage.SVGImage(named: name, fillColor: Colors.tintColor)
        }
    }
    
    var image: UIImage? {
        get {
            let name = "icons_outlined_\(rawValue)"
            return UIImage.SVGImage(named: name, fillColor: UIColor.black)
        }
    }
}

