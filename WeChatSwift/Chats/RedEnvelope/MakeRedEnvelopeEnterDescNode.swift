//
//  MakeRedEnvelopeEnterDescNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MakeRedEnvelopeEnterDescNode: ASDisplayNode {
    
    private let addEmoticonButton = ASButtonNode()
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        addEmoticonButton.setImage(UIImage(named: "AddExpression_Icon_29x29_"), for: .normal)
        addEmoticonButton.setImage(UIImage(named: "AddExpression_Icon_Pressed_29x29_"), for: .highlighted)
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
        cornerRadius = 5
        cornerRoundingType = .precomposited
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASLayoutSpec()
    }
    
}
