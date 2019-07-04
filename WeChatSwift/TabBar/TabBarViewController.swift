//
//  TabBarViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private var chatsBarItem: UIBarButtonItem?
    private var contactsBarItem: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatsBarItem = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_addoutline"), style: .done, target: self, action: #selector(handleRightBarButtonTapped(_:)))
        contactsBarItem = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_addfriends"), style: .done, target: self, action: #selector(handleRightBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = chatsBarItem
        navigationItem.title = "微信"
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        switch item.tag {
        case 0:
            navigationItem.title = "微信"
            navigationItem.rightBarButtonItem = chatsBarItem
        case 1:
            navigationItem.title = "通讯录"
            navigationItem.rightBarButtonItem = contactsBarItem
        case 2:
            navigationItem.title = "发现"
            navigationItem.rightBarButtonItem = nil
        case 3:
            navigationItem.title = nil
            navigationItem.rightBarButtonItem = nil
        default:
            navigationItem.title = nil
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension TabBarViewController {
    
    @objc private func handleRightBarButtonTapped(_ sender: Any) {
        if selectedIndex == 1 {
            let controller = AddContactViewController()
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
