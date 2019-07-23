//
//  WCTabBarItem.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class WCTabBarItem: UITabBarItem {
    
    var contentView: WCTabBarContentView?
    
    override var title: String? { didSet { contentView?.title = title } }
    
    override var image: UIImage? { didSet { contentView?.image = image } }
    
    override var selectedImage: UIImage? { didSet { contentView?.selectedImage = selectedImage } }
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

class WCTabBarContentView: UIView {
    
    var title: String?
    
    var image: UIImage?
    
    var selectedImage: UIImage?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
