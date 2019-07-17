//
//  WebpageContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

extension MomentCellNode {
    
    class WebpageContentNode: MomentContentNode {
        
        private let imageNode: ASNetworkImageNode = ASNetworkImageNode()
        
        private let textNode: ASTextNode = ASTextNode()
        
        private let webPage: MomentWebpage
        
        init(webPage: MomentWebpage) {
            
            self.webPage = webPage
            
            super.init()
            backgroundColor = UIColor(hexString: "#F3F3F5")
            textNode.maximumNumberOfLines = 2
            imageNode.contentMode = .scaleAspectFill
            
            addSubnode(imageNode)
            addSubnode(textNode)
            
            imageNode.image = webPage.thumbImage
            textNode.attributedText = webPage.attributedStringForTitle()
        }
        
        override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
            imageNode.style.preferredSize = CGSize(width: 40, height: 40)
            
            textNode.style.flexGrow = 1.0
            textNode.style.flexShrink = 1.0
            
            let stack = ASStackLayoutSpec.horizontal()
            stack.alignItems = .center
            stack.spacing = 4.0
            stack.children = [imageNode, textNode]
            
            let insets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            return ASInsetLayoutSpec(insets: insets, child: stack)
        }
    }
}
