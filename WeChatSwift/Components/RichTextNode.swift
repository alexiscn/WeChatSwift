//
//  RichTextNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/15.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class RichTextNode: ASDisplayNode {
    
    private let textNode = ASTextNode()
    
    private let kLinkAttributeName = "RichTextNodeLinkAttributes"
    
    init(attributes: NSAttributedString) {
        super.init()
        
        addSubnode(textNode)
        
        textNode.delegate = self
        textNode.isUserInteractionEnabled = true
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASLayoutSpec()
    }
}

// MARK: - ASTextNodeDelegate
extension RichTextNode: ASTextNodeDelegate {
    
    func textNode(_ textNode: ASTextNode!, shouldHighlightLinkAttribute attribute: String!, value: Any!, at point: CGPoint) -> Bool {
        return true
    }
    
    func textNode(_ textNode: ASTextNode!, tappedLinkAttribute attribute: String!, value: Any!, at point: CGPoint, textRange: NSRange) {
        
    }
    
}
