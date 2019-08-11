//
//  MomentNewMessageCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/31.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentNewMessageCellNode: ASCellNode {
    
    private let buttonNode = ASButtonNode()
    
    private let avatarNode = ASNetworkImageNode()
    
    private let arrowNode = ASImageNode()
    
    init(newMessage: MomentNewMessage) {
        super.init()
        
        avatarNode.image = newMessage.userAvatar
        avatarNode.frame = CGRect(x: 4.5, y: 4.5, width: 31, height: 31)
        avatarNode.cornerRadius = 4
        avatarNode.cornerRoundingType = .defaultSlowCALayer
        
        buttonNode.setBackgroundImage(UIImage(named: "AlbumTimeLineTipBkg_50x40_"), for: .normal)
        buttonNode.setBackgroundImage(UIImage(named: "AlbumTimeLineTipBkgHL_50x40_"), for: .highlighted)
        arrowNode.image = UIImage.as_imageNamed("AlbumTimeLineTipArrow_15x15_")
        arrowNode.frame = CGRect(x: 155, y: 12.5, width: 15, height: 15)
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
            NSAttributedString.Key.foregroundColor: Colors.white
        ]
        let content = "\(newMessage.unread)条新消息"
        buttonNode.setAttributedTitle(NSAttributedString(string: content, attributes: attributes), for: .normal)
        
        buttonNode.addSubnode(avatarNode)
        buttonNode.addSubnode(arrowNode)
        addSubnode(buttonNode)
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = .white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        arrowNode.style.preferredSize = CGSize(width: 15, height: 15)
        
        buttonNode.style.preferredSize = CGSize(width: 180, height: 40)
        
        let padding = (constrainedSize.max.width - 180.0)/2.0
        
        
        let insets = UIEdgeInsets(top: 15.0, left: padding, bottom: 15, right: padding)
        return ASInsetLayoutSpec(insets: insets, child: buttonNode)
    }
    
}
