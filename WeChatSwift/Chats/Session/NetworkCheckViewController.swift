//
//  NetworkCheckViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/19.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class NetworkCheckViewController: ASDKViewController<ASDisplayNode> {
    
    private let iconImageView = ASImageNode()
    
    private let statusNode = ASTextNode()
    
    private let detailTextNode = ASTextNode()
    
    private let closeButtonNode = ASButtonNode()
    
    override init() {
        super.init(node: ASDisplayNode())
        
        iconImageView.image = UIImage(named: "checkingnetwork_76x135_")
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        detailTextNode.attributedText = NSAttributedString(string: "检查网络需要一些时间，请耐心等待", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle
            ])
        closeButtonNode.setImage(UIImage.SVGImage(named: "icons_filled_close"), for: .normal)
        
        node.addSubnode(iconImageView)
        node.addSubnode(statusNode)
        node.addSubnode(detailTextNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.frame = view.bounds
        view.addSubview(blurView)
        view.sendSubviewToBack(blurView)
        
        closeButtonNode.addTarget(self, action: #selector(handleCloseButtonClicked), forControlEvents: .touchUpInside)
    }
    
    @objc private func handleCloseButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        iconImageView.frame = CGRect(x: (view.bounds.width - 76)/2.0, y: 160, width: 76, height: 135)
        statusNode.frame = CGRect(x: 0, y: 334.0, width: view.bounds.width, height: 21)
        detailTextNode.frame = CGRect(x: 0, y: 371.0, width: view.bounds.width, height: 17)
    }
    
}
