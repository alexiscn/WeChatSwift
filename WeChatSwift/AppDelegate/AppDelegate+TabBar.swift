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
        chatsVC.tabBarItem.title = LanguageManager.shared.getLocalizedString("TabBar_MainFrameTitle")
        chatsVC.tabBarItem.tag = 0
        
        contactsVC.tabBarItem.selectedImage = HomeTab.contacts.selectedImage
        contactsVC.tabBarItem.image = HomeTab.contacts.image
        contactsVC.tabBarItem.title = LanguageManager.shared.getLocalizedString("TabBar_ContactsTitle")
        contactsVC.tabBarItem.tag = 1
        
        discoverVC.tabBarItem.selectedImage = HomeTab.discover.selectedImage
        discoverVC.tabBarItem.image = HomeTab.discover.image
        discoverVC.tabBarItem.title = LanguageManager.shared.getLocalizedString("TabBar_FindFriendTitle")
        discoverVC.tabBarItem.tag = 2
        
        meVC.tabBarItem.selectedImage = HomeTab.me.selectedImage
        meVC.tabBarItem.image = HomeTab.me.image
        meVC.tabBarItem.title = LanguageManager.shared.getLocalizedString("TabBar_MoreTitle")
        meVC.tabBarItem.tag = 3
        
        tabBarVC = ASTabBarController()
        let chatNav = MMNavigationController(rootViewController: chatsVC)
        let contactsNav = MMNavigationController(rootViewController: contactsVC)
        let discoverNav = MMNavigationController(rootViewController: discoverVC)
        let meNav = MMNavigationController(rootViewController: meVC)
        
        let viewControllers = [chatNav, contactsNav, discoverNav, meNav]
        tabBarVC.viewControllers = viewControllers
        for vc in [chatsVC, contactsVC, discoverVC, meVC] {
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

