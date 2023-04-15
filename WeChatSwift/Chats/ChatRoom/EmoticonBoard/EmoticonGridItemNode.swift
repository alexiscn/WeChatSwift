//
//  EmoticonGridItemNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/19.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import Foundation

class EmoticonGridItemNode: ASDisplayNode {
    
    private let imageNode = ASImageNode()
    
    private let textNode = ASTextNode()
    
    let emoticon: Emoticon
    
    init(emoticon: Emoticon, itemSize: CGSize) {
        self.emoticon = emoticon
        
        super.init()
        self.clipsToBounds = false
        imageNode.image = emoticon.thumbImage
        imageNode.style.preferredSize = itemSize
        imageNode.contentMode = .scaleAspectFill
        addSubnode(imageNode)
        addSubnode(textNode)
        
        if let title = emoticon.title {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attributes = [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
                NSAttributedString.Key.foregroundColor: Colors.DEFAULT_TEXT_GRAY_COLOR,
                NSAttributedString.Key.paragraphStyle: paragraphStyle
            ]
            textNode.attributedText = NSAttributedString(string: title, attributes: attributes)
        }
    }
    
    override func didLoad() {
        super.didLoad()
        
    }
    
    override func layout() {
        super.layout()
        
        if emoticon.title != nil {
            textNode.frame = CGRect(x: 0, y: bounds.height + 3, width: bounds.height, height: 15)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        if emoticon.title != nil {
            let stack = ASStackLayoutSpec.vertical()
            stack.children = [imageNode, textNode]
            return ASInsetLayoutSpec(insets: .zero, child: stack)
        } else {
            return ASInsetLayoutSpec(insets: .zero, child: imageNode)
        }
    }
    
}
