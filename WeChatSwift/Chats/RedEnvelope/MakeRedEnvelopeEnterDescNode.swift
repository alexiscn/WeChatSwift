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
        cornerRoundingType = .defaultSlowCALayer
        
        addEmoticonButton.addTarget(self, action: #selector(handleAddEmoticonButtonClicked), forControlEvents: .touchUpInside)
    }
    
    @objc private func handleAddEmoticonButtonClicked() {
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        addEmoticonButton.style.preferredSize = CGSize(width: 29.0, height: 29.0)
        addEmoticonButton.style.layoutPosition = CGPoint(x: constrainedSize.max.width - 29.0 - 20.0, y: 17.5)
        
        let layout = ASAbsoluteLayoutSpec(children: [addEmoticonButton])
        layout.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56.0)
        return layout
    }
    
}
