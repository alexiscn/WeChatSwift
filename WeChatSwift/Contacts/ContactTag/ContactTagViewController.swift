//
//  ContactTagViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/11.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactTagViewController: ASViewController<ASDisplayNode> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "设置标签"
        
        let okButton = wc_doneBarButton(title: "确定")
        okButton.addTarget(self, action: #selector(okButtonClicked), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: okButton)
    }
    
}

// MARK: - Event Handlers
extension ContactTagViewController {
    
    @objc private func okButtonClicked() {
        
    }
    
}
