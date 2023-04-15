//
//  ShakeViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/8.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ShakeViewController: ASDKViewController<ASDisplayNode> {
    
    private let shakeLogoUpNode = ASImageNode()
    
    private let shakeLogoDownNode = ASImageNode()
    
    private let hiddenImageNode = ASImageNode()
    
    private let shakeTypeBar: ShakeTypeBarNode
    
    private var animating: Bool = false
    
    init(gender: Bool = true) {
        
        shakeTypeBar = ShakeTypeBarNode(shakes: [.people, .music, .tv])
        
        hiddenImageNode.image = UIImage(named: "ShakeHideImg_women_320x320_")
        
        if gender {
            shakeLogoUpNode.image = UIImage(named: "Shake_Logo_Up_150x83_")
            shakeLogoDownNode.image = UIImage(named: "Shake_Logo_Down_150x82_")
        } else {
            shakeLogoUpNode.image = UIImage(named: "Shake_Logo_Female_Up_150x83_")
            shakeLogoDownNode.image = UIImage(named: "Shake_Logo_Female_Down_150x82_")
        }
        
        super.init(node: ASDisplayNode())
        
        node.addSubnode(hiddenImageNode)
        
        node.addSubnode(shakeTypeBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = UIColor(hexString: "#2E3132")
        
        navigationItem.title = "摇一摇"
        let image = UIImage.SVGImage(named: "icons_outlined_setting")?.withRenderingMode(.alwaysTemplate)
        let settingButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: #selector(settingButtonClicked))
        navigationItem.rightBarButtonItem = settingButtonItem
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        shakeTypeBar.frame = CGRect(x: 0, y: view.bounds.height - 70 - Constants.bottomInset, width: view.bounds.width, height: 70)
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
    
    override var wx_navigationBarBackgroundColor: UIColor? {
        return UIColor(hexString: "#2E3132")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    
    override var wx_titleTextAttributes: [NSAttributedString.Key : Any]? {
        return [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    override var wx_barTintColor: UIColor {
        return UIColor.white
    }
    
    override var wx_barBarTintColor: UIColor? {
        return UIColor.white
    }
}

// MARK: - Event Handlers
extension ShakeViewController {
    
    @objc private func settingButtonClicked() {
        let shakeSettingVC = ShakeSettingViewController()
        navigationController?.pushViewController(shakeSettingVC, animated: true)
    }
}
