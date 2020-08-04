//
//  ContactTagViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/11.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactTagViewController: ASDKViewController<ASDisplayNode> {
    
    override init() {
        super.init(node: ASDisplayNode())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        navigationItem.title = "设置标签"
        
        let cancelButton = UIBarButtonItem(title: LanguageManager.Common.cancel(), style: .plain, target: self, action: #selector(cancelButtonClicked))
        navigationItem.leftBarButtonItem = cancelButton
        
        let okButton = wc_doneBarButton(title: "确定")
        okButton.addTarget(self, action: #selector(okButtonClicked), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: okButton)
    }
    
}

// MARK: - Event Handlers
extension ContactTagViewController {
    
    @objc private func cancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func okButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
}
