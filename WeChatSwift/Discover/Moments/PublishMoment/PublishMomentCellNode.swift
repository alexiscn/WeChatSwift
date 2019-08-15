//
//  PublishMomentCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/15.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class PublishMomentCellNode: ASCellNode {
    
    private let imageNode = ASImageNode()
    
    private let titleNode = ASTextNode()
    
    private let arrowNode = ASImageNode()
    
    private let topLineNode = ASDisplayNode()
    
    private let bottomLineNode = ASDisplayNode()
    
    private let action: PublishMomentAction
    
    init(action: PublishMomentAction) {
        self.action = action
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASLayoutSpec()
    }
    
}
