//
//  LoadingProgressView.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/19.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class LoadingProgressView: UIView, CAAnimationDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
    }
    
}

class LoadingProgressViewLayer: CAShapeLayer {
    
}
