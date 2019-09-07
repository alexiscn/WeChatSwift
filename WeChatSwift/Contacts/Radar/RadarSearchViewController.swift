//
//  RadarSearchViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/9/7.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class RadarSearchViewController: ASViewController<ASDisplayNode> {
    
    private let backgroundNode = ASImageNode()
    
    private let radarLightNode = ASImageNode()
    
    private let myAvatarNode = ASImageNode()
    
    private let closeButtonNode = ASButtonNode()
    
    init() {
        super.init(node: ASDisplayNode())
        
        backgroundNode.image = UIImage(named: "SkyBg01_320x490_")
        backgroundNode.frame = node.bounds
        node.addSubnode(backgroundNode)
        
        radarLightNode.image = UIImage(named: "Radar_Scan_light_615x615_")
        node.addSubnode(radarLightNode)
        node.addSubnode(closeButtonNode)
        
        let closeText = NSAttributedString(string: "取消", attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
            .foregroundColor: UIColor.white
        ])
        closeButtonNode.setAttributedTitle(closeText, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        backgroundNode.frame = node.bounds
        
        radarLightNode.frame = CGRect(x: (node.bounds.width - 615)/2.0, y: (node.bounds.height - 615)/2.0, width: 615, height: 615)
        closeButtonNode.frame = CGRect(x: 15, y: 30, width: 49, height: 60)
        
        let closeButtonImageView = UIImageView(image: UIImage(named: "LineBigbuttonDisable_20x35_"))
        closeButtonImageView.frame = CGRect(x: 0, y: 15, width: 49, height: 30)
        closeButtonNode.view.addSubview(closeButtonImageView)
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = 2 * CGFloat.pi
        rotationAnimation.duration = 10.0
        rotationAnimation.repeatCount = Float.greatestFiniteMagnitude
        self.radarLightNode.view.layer.add(rotationAnimation, forKey: "rotation")
        
        node.clipsToBounds = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override var wc_navigationBarBackgroundColor: UIColor? {
        return .clear
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
