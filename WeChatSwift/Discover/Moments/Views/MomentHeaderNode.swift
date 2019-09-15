//
//  MomentHeaderNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/31.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentHeaderNode: ASDisplayNode {
    
    var avatarTapHandler: RelayCommand?
    var coverTapHandler: RelayCommand?
    
    private let nameNode = ASTextNode()
    
    private let coverNode = ASImageNode()
    
    private let tipsNode = ASTextNode()
    
    private let avatarNode = ASNetworkImageNode()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        
        let user = AppContext.current.me
        
        coverNode.image = AppContext.current.momentCoverManager.cover() //UIImage.as_imageNamed("AlbumListViewBkg_320x320_")
        avatarNode.url = user.avatar
        avatarNode.cornerRadius = 6
        avatarNode.cornerRoundingType = .defaultSlowCALayer
        
        tipsNode.attributedText = NSAttributedString(string: "轻触设置相册封面", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(hexString: "#212121")
            ])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        let nameAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 21, weight: .semibold),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#FFFBF2"),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        nameNode.attributedText = NSAttributedString(string: user.name, attributes: nameAttributes)
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = .white
        isUserInteractionEnabled = true
        
        avatarNode.addTarget(self, action: #selector(avatarClicked), forControlEvents: .touchUpInside)
    
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func updateCover(_ cover: UIImage?) {
        coverNode.image = cover
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        coverTapHandler?()
    }
    
    @objc private func avatarClicked() {
        avatarTapHandler?()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        coverNode.style.preferredSize = CGSize(width: Constants.screenWidth, height: Constants.screenWidth)
        coverNode.style.layoutPosition = CGPoint(x: 0, y: constrainedSize.max.height - Constants.screenWidth - 50.0)
        avatarNode.style.preferredSize = CGSize(width: 70, height: 70)
        avatarNode.style.layoutPosition = CGPoint(x: constrainedSize.max.width - 82, y: constrainedSize.max.height - 100)
        nameNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 100, height: 24)
        nameNode.style.layoutPosition = CGPoint(x: 0, y: constrainedSize.max.height - 90)
        return ASAbsoluteLayoutSpec(children: [coverNode, avatarNode, nameNode])
    }
}
