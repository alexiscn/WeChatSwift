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
    
    private let avatarBackgroundNode = ASImageNode()
    
    private let avatarNode = ASNetworkImageNode()
    
    private let closeButtonNode = ASButtonNode()
    
    init() {
        super.init(node: ASDisplayNode())
        
        backgroundNode.image = UIImage(named: "SkyBg01_320x490_")
        backgroundNode.frame = node.bounds
        node.addSubnode(backgroundNode)
        
        radarLightNode.image = UIImage(named: "Radar_Scan_light_615x615_")
        node.addSubnode(radarLightNode)
        node.addSubnode(closeButtonNode)
        
        let closeText = NSAttributedString(string: LanguageManager.Common.cancel(), attributes: [
            .font: UIFont.systemFont(ofSize: 14, weight: .semibold),
            .foregroundColor: UIColor.white
        ])
        closeButtonNode.setAttributedTitle(closeText, for: .normal)
        
        avatarBackgroundNode.image = UIImage(named: "Radar_Avatar_bg_130x130_")
        avatarNode.url = AppContext.current.me.avatar
        avatarNode.cornerRadius = 39.0
        avatarNode.cornerRoundingType = .defaultSlowCALayer
        node.addSubnode(avatarBackgroundNode)
        avatarBackgroundNode.addSubnode(avatarNode)
        
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
        avatarBackgroundNode.frame = CGRect(x: (node.bounds.width - 130.0)/2.0, y: (node.bounds.height - 130)/2.0, width: 130, height: 130)
        avatarNode.frame = CGRect(x: 26, y: 24, width: 78, height: 78)
        
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
