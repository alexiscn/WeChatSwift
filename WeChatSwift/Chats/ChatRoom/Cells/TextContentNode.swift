//
//  TextContentCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class TextContentNode: MessageContentNode {
    
    weak var delegate: TextContentNodeDelegate?
    
    private let bubbleNode = ASImageNode()
    
    private let textNode = ASTextNode()
    
    init(message: Message, text: String) {
        super.init(message: message)
        
        let icon = message.isOutgoing ? "ChatRoom_Bubble_Text_Sender_Green_57x40_": "ChatRoom_Bubble_Text_Receiver_White_57x40_"
        bubbleNode.image = UIImage(named: icon)
        bubbleNode.style.flexShrink = 1
        
        addSubnode(bubbleNode)
        addSubnode(textNode)
        
        let textFont = UIFont.systemFont(ofSize: 17)
        let lineHeight = textFont.lineHeight
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        paragraphStyle.lineSpacing = 3
        paragraphStyle.maximumLineHeight = lineHeight
        paragraphStyle.minimumLineHeight = lineHeight
        
        let attributedText = NSMutableAttributedString(string: text, attributes: [
            .font: textFont,
            .foregroundColor: Colors.DEFAULT_TEXT_COLOR,
            .paragraphStyle: paragraphStyle
            ])
        let links = LinkTextParser.shared.match(text: attributedText.string)
        for link in links {
            attributedText.addAttributes([
                NSAttributedString.Key.link: link.url as Any,
                NSAttributedString.Key.foregroundColor: Colors.DEFAULT_LINK_HIGHLIGHT_COLOR,
                NSAttributedString.Key.underlineColor: UIColor.clear
            ], range: link.range)
        }
        textNode.attributedText = ExpressionParser.shared?.attributedText(with: attributedText)
    }
    
    override func didLoad() {
        super.didLoad()
        textNode.isUserInteractionEnabled = true
        textNode.delegate = self
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        textNode.style.flexGrow = 1.0
        textNode.style.flexShrink = 1.0
        
        let insets: UIEdgeInsets
        if message.isOutgoing {
            insets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 15)
        } else {
            insets = UIEdgeInsets(top: 10, left: 17, bottom: 10, right: 12)
        }
        
        let insetsLayout = ASInsetLayoutSpec(insets: insets, child: textNode)
        let spec = ASBackgroundLayoutSpec()
        spec.background = bubbleNode
        
        spec.child = insetsLayout
        return spec
    }
}

extension TextContentNode: ASTextNodeDelegate {
    func textNode(_ textNode: ASTextNode!, tappedLinkAttribute attribute: String!, value: Any!, at point: CGPoint, textRange: NSRange) {
        delegate?.textContentNode(self, tappedLinkAttribute: attribute, value: value, at: point, textRange: textRange)
    }
}

protocol TextContentNodeDelegate: class {
    func textContentNode(_ textNode: TextContentNode, tappedLinkAttribute attribute: String!, value: Any!, at point: CGPoint, textRange: NSRange)
}
