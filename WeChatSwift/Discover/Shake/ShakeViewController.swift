//
//  ShakeViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/8.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ShakeViewController: ASViewController<ASDisplayNode> {
    
    private let shakeLogoUpNode = ASImageNode()
    
    private let shakeLogoDownNode = ASImageNode()
    
    private let shakeTypeBar: ShakeTypeBarNode
    
    init() {
        
        shakeTypeBar = ShakeTypeBarNode(shakes: [.people, .music, .tv])
        
        super.init(node: ASDisplayNode())
        
        node.addSubnode(shakeTypeBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = UIColor(hexString: "#2E3132")
        
        navigationItem.title = "摇一摇"
        let settingButtonItem = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_setting"), style: .done, target: self, action: #selector(settingButtonClicked))
        navigationItem.rightBarButtonItem = settingButtonItem
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionBegan(motion, with: event)
        
        if motion == .motionShake {
            
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionEnded(motion, with: event)
    }
    
}

// MARK: - Event Handlers
extension ShakeViewController {
    
    @objc private func settingButtonClicked() {
        let shakeSettingVC = ShakeSettingViewController()
        navigationController?.pushViewController(shakeSettingVC, animated: true)
    }
}
