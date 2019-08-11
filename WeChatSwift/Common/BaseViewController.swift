//
//  BaseViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/10.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class BaseViewController: ASViewController<ASDisplayNode> {
    
    internal var navBarBackgroundColor: UIColor? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
//        let titleLabel = UILabel()
//        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//        titleLabel.textColor = UIColor(hexString: "#181818")
//        titleLabel.text = "微信"
//        titleLabel.sizeToFit()
//
//        let titleView = UIView()
//        titleView.frame = CGRect(x: 0, y: 0, width: 1, height: 36)
//        titleView.addSubview(titleLabel)
//
//        titleLabel.frame.origin = CGPoint(x: (1-titleLabel.bounds.width)/2, y: (36 - titleLabel.bounds.height)/2)
//
//        navigationItem.titleView = titleView
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
