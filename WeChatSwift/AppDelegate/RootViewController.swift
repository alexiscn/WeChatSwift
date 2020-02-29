//
//  RootViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/12/26.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class RootViewController: ASTabBarController {

    private var chatsVC: SessionViewController!
    
    private var contactsVC: ContactsViewController!
    
    private var discoverVC: DiscoverViewController!
    
    private var meVC: MeViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ASDisableLogging()
        
        // Do any additional setup after loading the view.
        chatsVC = SessionViewController()
        chatsVC.tabBarItem.selectedImage = HomeTab.chats.selectedImage
        chatsVC.tabBarItem.image = HomeTab.chats.image
        chatsVC.tabBarItem.title = LocalizedString("TabBar_MainFrameTitle")
        chatsVC.tabBarItem.tag = 0

        contactsVC = ContactsViewController()
        contactsVC.tabBarItem.selectedImage = HomeTab.contacts.selectedImage
        contactsVC.tabBarItem.image = HomeTab.contacts.image
        contactsVC.tabBarItem.title = LocalizedString("TabBar_ContactsTitle")
        contactsVC.tabBarItem.tag = 1

        discoverVC = DiscoverViewController()
        discoverVC.tabBarItem.selectedImage = HomeTab.discover.selectedImage
        discoverVC.tabBarItem.image = HomeTab.discover.image
        discoverVC.tabBarItem.title = LocalizedString("TabBar_FindFriendTitle")
        discoverVC.tabBarItem.tag = 2

        meVC = MeViewController()
        meVC.tabBarItem.selectedImage = HomeTab.me.selectedImage
        meVC.tabBarItem.image = HomeTab.me.image
        meVC.tabBarItem.title = LocalizedString("TabBar_MoreTitle")
        meVC.tabBarItem.tag = 3
        
        tabBar.unselectedItemTintColor = UIColor(hexString: "#181818")
        let controllers = [chatsVC, contactsVC, discoverVC, meVC]
        controllers.forEach { $0?.tabBarItem.setTitleTextAttributes([
            .font: UIFont.systemFont(ofSize: 9.5)
        ], for: .normal) }
        
        let chatNav = UINavigationController(rootViewController: chatsVC)
        let contactsNav = UINavigationController(rootViewController: contactsVC)
        let discoverNav = UINavigationController(rootViewController: discoverVC)
        let meNav = UINavigationController(rootViewController: meVC)
        
        viewControllers = [chatNav, contactsNav, discoverNav, meNav]
        tabBar.tintColor = Colors.tintColor
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(UIImage.imageFromColor(.clear), for: .normal, barMetrics: .default)
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
