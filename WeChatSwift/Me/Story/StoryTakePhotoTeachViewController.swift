//
//  StoryTakePhotoTeachViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/12.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class StoryTakePhotoTeachViewController: ASDKViewController<ASDisplayNode> {

    var cancelHandler: RelayCommand?
    
    private let cancelButton = ASButtonNode()
    
    private let backgroundImageNode = ASImageNode()

    private let takeButton = ASButtonNode()
    
    override init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(cancelButton)
        node.addSubnode(backgroundImageNode)
        node.addSubnode(takeButton)
        
        backgroundImageNode.image = UIImage(named: "story_teach_bg_144x344_")
        let attributedText = NSAttributedString(string: "拍一个视频动态", attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            .foregroundColor: Colors.Blue_90
            ])
        takeButton.setImage(UIImage.SVGImage(named: "icons_filled_camera"), for: .normal)
        takeButton.setAttributedTitle(attributedText, for: .normal)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateHidden()
        node.backgroundColor = Colors.white
        cancelButton.addTarget(self, action: #selector(cancelButtonClicked), forControlEvents: .touchUpInside)
        takeButton.addTarget(self, action: #selector(takeButtonClicked), forControlEvents: .touchUpInside)
    }
    
    @objc private func cancelButtonClicked() {
        cancelHandler?()
    }
    
    @objc private func takeButtonClicked() {
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cancelButton.frame = node.bounds
        backgroundImageNode.frame = CGRect(x: 0, y: 325, width: 144, height: 344)
        takeButton.frame = CGRect(x: (view.bounds.width - 194)/2, y: 564, width: 194, height: 48)
    }
    
    func updateHidden() {
        backgroundImageNode.alpha = 0.0
        takeButton.alpha = 0.0
    }
}
