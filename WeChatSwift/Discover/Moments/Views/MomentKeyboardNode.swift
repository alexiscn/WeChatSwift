//
//  MomentKeyboardNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/28.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentKeyboardNode: ASDisplayNode {
    
    private let emoticonNode = ASButtonNode()
    
    override init() {
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
