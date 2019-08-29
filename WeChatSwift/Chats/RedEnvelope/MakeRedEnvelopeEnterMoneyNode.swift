//
//  MakeRedEnvelopeEnterMoneyNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MakeRedEnvelopeEnterMoneyNode: ASDisplayNode {
    
    private let leadingTextNode = ASTextNode()
    
    private let inputTextNode = ASEditableTextNode()
    
    private let trailingTextNode = ASTextNode()
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        leadingTextNode.attributedText = NSAttributedString(string: "金额", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: Colors.black
        ])
        
        trailingTextNode.attributedText = NSAttributedString(string: "", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: Colors.black
        ])
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
        cornerRadius = 5
        cornerRoundingType = .precomposited
        
        inputTextNode.view.semanticContentAttribute = .forceRightToLeft
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        inputTextNode.style.flexGrow = 1.0
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = [leadingTextNode, inputTextNode, trailingTextNode]
        
        let insets = UIEdgeInsets(top: 17.5, left: 10, bottom: 17.5, right: 10)
        return ASInsetLayoutSpec(insets: insets, child: stack)
    }
    
}
