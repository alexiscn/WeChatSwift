//
//  MomentOperationMenuView.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class MomentOperationMenuView: UIView {
    
    private let likeButton: UIButton
    private let commentButton: UIButton
    
    override init(frame: CGRect) {
        
        likeButton = UIButton()
        
        commentButton = UIButton()
        
        super.init(frame: frame)
        
        addSubview(likeButton)
        addSubview(commentButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
