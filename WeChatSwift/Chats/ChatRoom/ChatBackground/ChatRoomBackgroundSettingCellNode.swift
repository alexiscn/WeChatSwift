//
//  ChatRoomBackgroundSettingCellNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/7.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ChatRoomBackgroundSettingCellNode: ASCellNode {
    
    private let thumbImageNode = ASImageNode()
    
    private let statusCurrentNode = ASImageNode()
    
    private let statusCurrentIconNode = ASImageNode()
    
    private let backgroundItem: ChatRoomBackgroundItem
    
    init(backgroundItem: ChatRoomBackgroundItem) {
        self.backgroundItem = backgroundItem
        super.init()
        
        automaticallyManagesSubnodes = true
        
        thumbImageNode.image = backgroundItem.thumb
        thumbImageNode.cornerRadius = 4
        thumbImageNode.cornerRoundingType = .precomposited
        thumbImageNode.contentMode = .scaleAspectFill
        
        statusCurrentNode.image = UIImage(named: "ChatBackgroundStatusCurrent_25x25_")
        statusCurrentIconNode.image = UIImage(named: "ChatBackgroundStatusCurrentIcon_15x15_")
    }
    
    override func didLoad() {
        super.didLoad()
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        thumbImageNode.style.preferredSize = constrainedSize.max
        
        if backgroundItem.isSelected {
            statusCurrentNode.isHidden = false
            statusCurrentIconNode.isHidden = false
            statusCurrentNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 25)
            statusCurrentNode.style.layoutPosition = CGPoint(x: 0, y: constrainedSize.max.height - 25)
            statusCurrentIconNode.style.preferredSize = CGSize(width: 15, height: 15)
            statusCurrentIconNode.style.layoutPosition = CGPoint(x: (constrainedSize.max.width - 15)/2, y: constrainedSize.max.height - 20)
        } else {
            statusCurrentNode.isHidden = true
            statusCurrentIconNode.isHidden = true
        }
        return ASAbsoluteLayoutSpec(children: [thumbImageNode, statusCurrentNode, statusCurrentIconNode])
    }
}
