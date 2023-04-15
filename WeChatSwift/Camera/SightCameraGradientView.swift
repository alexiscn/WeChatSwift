//
//  SightCameraGradientView.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/22.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class SightCameraGradientView: UIView {
    
    private let gradientLayer: CAGradientLayer
    
    override init(frame: CGRect) {
        
        gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.colors = [
            UIColor(red: 0.0156863, green: 0, blue: 0.0235294, alpha: 0.66).cgColor,
            UIColor(red: 0.0156863, green: 0, blue: 0.0235294, alpha: 0.88).cgColor
        ]
        gradientLayer.type = .axial
        
        super.init(frame: frame)
        
        layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
    }
}
