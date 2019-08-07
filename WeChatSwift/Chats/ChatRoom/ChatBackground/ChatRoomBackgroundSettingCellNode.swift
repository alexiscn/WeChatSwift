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
    
    private let downloadNode = ASDisplayNode()
    
    private let selectionNode = ASImageNode()
    
    init(string: String) {
        super.init()
        
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASAbsoluteLayoutSpec(children: [thumbImageNode])
    }
}
