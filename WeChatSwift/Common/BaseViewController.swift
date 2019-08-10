//
//  BaseViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/10.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class BaseViewController: ASViewController<ASDisplayNode> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func titleLabel(_ title: String) -> UILabel {
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleLabel.textColor = UIColor(hexString: "#181818")
        titleLabel.text = title
        return titleLabel
    }
    
    func setNavigationBarTitle(_ title: String) {
        navigationItem.titleView = titleLabel(title)
    }
}
