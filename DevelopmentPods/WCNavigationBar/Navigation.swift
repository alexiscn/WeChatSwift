//
//  Navigation.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/1.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

public struct Navigation<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

extension Navigation where Base: UIViewController {
    
    var bar: NavigationBar { return base.wc_navigationBar }
    
    var item: UINavigationItem { return base.wc_navigationItem }
}

public protocol NavigationCompatible {
    
    associatedtype CompatibleType
    
    var navigation: CompatibleType { get }
}

public extension NavigationCompatible {
    
    var navigation: Navigation<Self> {
        return Navigation(self)
    }
}

extension UIViewController: NavigationCompatible {}


extension Navigation where Base: UINavigationController {
    var style: NavigationStyle {
        return base.wc_style
    }
}
