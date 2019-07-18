//
//  EmoticonBoardTabBarCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/18.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonBoardTabBarCellNode: ASCellNode {
    
    private let imageNode = ASImageNode()
    
    private let hairlineNode = ASDisplayNode()
    
    init(emoticonTab: EmoticonTab) {
        
        super.init()
        
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let layout = ASLayoutSpec()
        return layout
    }
}
