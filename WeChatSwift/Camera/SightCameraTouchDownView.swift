//
//  SightCameraTouchDownView.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/22.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class SightCameraTouchDownView: UIView {
    
    weak var target: NSObject?
    
    var callback: Selector?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
}
