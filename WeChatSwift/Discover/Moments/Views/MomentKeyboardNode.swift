//
//  MomentKeyboardNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/28.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import WXGrowingTextView

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
