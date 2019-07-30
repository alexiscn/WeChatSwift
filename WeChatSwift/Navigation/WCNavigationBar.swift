//
//  WCNavigationBar.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/31.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

public class WCNavigationBar: UINavigationBar {
    
    weak var controller: UIViewController?
    
    convenience init(controller: UIViewController) {
        self.init()
        self.controller = controller
    }
}

struct AssociatedKeys {
    static var navigationBar = "AssociatedKeys_navigationBar"
    static var navigationItem = "AssociatedKeys_AssociatedKeys"
}

extension UIViewController {
    
    var wc_navigationBar: WCNavigationBar {
        if let bar = objc_getAssociatedObject(self, &AssociatedKeys.navigationBar) as? WCNavigationBar {
            return bar
        }
        let bar = WCNavigationBar(controller: self)
        objc_setAssociatedObject(self, &AssociatedKeys.navigationBar, bar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return bar
    }
    
    var wc_navigationItem: UINavigationItem {
        if let item = objc_getAssociatedObject(self, &AssociatedKeys.navigationItem) as? UINavigationItem {
            return item
        }
        let item = UINavigationItem()
        item.title = navigationItem.title
        item.prompt = navigationItem.prompt
        
        objc_setAssociatedObject(self, &AssociatedKeys.navigationItem, item, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return item
    }
    
}
