//
//  SightCameraRecordView.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/22.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import UIKit

class SightCameraRecordView: UIView {
 
    private let innerDot: UIView
    
    private let outerDot: UIView
    
    private let outerDotBackground: UIView
    
    private let outerDotBlurBackground: UIView
    
    override init(frame: CGRect) {
        
        innerDot = UIView()
        innerDot.backgroundColor = .white
        innerDot.layer.cornerRadius = 27
        innerDot.layer.masksToBounds = true
        innerDot.frame = CGRect(x: 10, y: 10, width: 54.0, height: 54.0)
        
        outerDot = UIView()
        outerDot.clipsToBounds = true
        outerDot.layer.cornerRadius = 37
        outerDot.layer.masksToBounds = true
        outerDot.frame = CGRect(x: 0, y: 0, width: 74.0, height: 74.0)
        
        outerDotBackground = UIView()
        outerDotBackground.frame = CGRect(x: 0, y: 0, width: 120.0, height: 120.0)
        outerDotBackground.backgroundColor = UIColor(hexString: "#D8D8D8")
        
        outerDotBlurBackground = UIView()
        outerDotBlurBackground.frame = CGRect(x: 0, y: 0, width: 120.0, height: 120.0)
        
        let blur = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blur.frame = outerDotBlurBackground.bounds
        outerDotBlurBackground.addSubview(blur)
        
        super.init(frame: frame)
        
        outerDot.addSubview(outerDotBackground)
        outerDot.addSubview(outerDotBlurBackground)
        addSubview(outerDot)
        addSubview(innerDot)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func beginFrameAnimation(fromRect: CGRect, toRect: CGRect) {
        
    }
    
    func beginRadiusAnimation(fromAngle: Double, toAngle: Double) {
        
    }
    
    func beginTransitionAnimation() {
        
    }
}
