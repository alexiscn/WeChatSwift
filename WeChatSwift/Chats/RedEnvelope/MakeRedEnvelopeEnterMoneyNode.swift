//
//  MakeRedEnvelopeEnterMoneyNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/29.
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
        
        trailingTextNode.attributedText = NSAttributedString(string: "元", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: Colors.black
        ])
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .right
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.1),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        inputTextNode.keyboardType = .numberPad
        inputTextNode.attributedPlaceholderText = NSAttributedString(string: "0.00", attributes: attributes)
        inputTextNode.typingAttributes = [
            NSAttributedString.Key.font.rawValue: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor.rawValue: Colors.black,
            NSAttributedString.Key.paragraphStyle.rawValue: paragraphStyle
        ]
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
        cornerRadius = 5
        cornerRoundingType = .defaultSlowCALayer
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        inputTextNode.style.flexGrow = 1.0
        inputTextNode.style.flexShrink = 1.0
        
        trailingTextNode.style.spacingBefore = 10
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = [leadingTextNode, inputTextNode, trailingTextNode]
        
        let insets = UIEdgeInsets(top: 17.5, left: 10, bottom: 17.5, right: 10)
        return ASInsetLayoutSpec(insets: insets, child: stack)
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return inputTextNode.resignFirstResponder()
    }
}
