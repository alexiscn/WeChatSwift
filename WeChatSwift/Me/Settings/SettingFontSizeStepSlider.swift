//
//  SettingFontSizeStepSlider.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class SettingFontSizeStepSlider: UIControl {
    
    var scaleTextArray = ["A", "", "", "", "A"]
    
    var scaleTextSoze: [CGFloat] = [16, 17, 18.5, 20, 24.5, 27.5]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func commonInit() {
        
    }
}
