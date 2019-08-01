//
//  UITableViewController+Navigation.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/1.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

extension UITableViewController {
    
    private struct AssociatedKeys {
        static var observation = "AssociatedKeys_observation"
    }
    
    private var observation: NSKeyValueObservation {
        if let observation = objc_getAssociatedObject(
            self,
            &AssociatedKeys.observation)
            as? NSKeyValueObservation {
            return observation
        }
        
        let observation = tableView.observe(
            \.contentOffset,
            options: .new) { [weak self] tableView, change in
                guard let `self` = self else { return }
                
                self.view.bringSubviewToFront(self.wc_navigationBar)
                self.wc_navigationBar.frame.origin.y = tableView.contentOffset.y + UIApplication.shared.statusBarFrame.maxY
        }
        
        objc_setAssociatedObject(
            self,
            &AssociatedKeys.observation,
            observation,
            .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        return observation
    }
    
    func observeContentOffset() {
        wc_navigationBar.automaticallyAdjustsPosition = false
        
        _ = observation
    }
}
