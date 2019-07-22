//
//  TextContentCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class TextContentNode: MessageContentNode {
    
    private let bubbleNode: ASImageNode = ASImageNode()
    
    private let textNode: MessageTextNode = MessageTextNode()
    
    init(message: Message, text: String) {
        super.init(message: message)
        
        let icon = message.isOutgoing ? "ChatRoom_Bubble_Text_Sender_Green_57x40_": "ChatRoom_Bubble_Text_Receiver_White_57x40_"
        bubbleNode.image = UIImage(named: icon)
        bubbleNode.style.flexShrink = 1
        
        addSubnode(bubbleNode)
        addSubnode(textNode)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 3
        
        let attributedText = NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: Colors.DEFAULT_TEXT_COLOR,
            .paragraphStyle: paragraphStyle
            ])
        
        textNode.attributedText = attributedText //ExpressionParser.shared?.attributedText(with: attributedText)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let offsetLeft: CGFloat = message.isOutgoing ? 0: 6
        let offsetRight: CGFloat = message.isOutgoing ? 6: 0
        let insets = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12, left: 12 + offsetLeft, bottom: 12, right: 9 + offsetRight), child: textNode)
        let spec = ASBackgroundLayoutSpec()
        spec.background = bubbleNode
        spec.child = insets
        return spec
    }
}

private class MessageTextNode: ASTextNode {
    
    override init() {
        super.init()
        placeholderColor = UIColor.clear
        isLayerBacked = true
    }
    
    override func calculateSizeThatFits(_ constrainedSize: CGSize) -> CGSize {
        let size = super.calculateSizeThatFits(constrainedSize)
        return CGSize(width: max(size.width, 15), height: size.height)
    }
    
}
