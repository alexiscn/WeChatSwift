//
//  EmoticonGridNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonGridNode: ASDisplayNode {
    
    init(emoticons: [Emoticon], columns: Int, rows: Int, itemSize: CGSize, insets: UIEdgeInsets) {
        super.init()
        
        var x: CGFloat = insets.left
        var y: CGFloat = insets.top
        for row in 0 ..< rows {
            for col in 0 ..< columns {
                let index = row * columns + col
                x = insets.left + CGFloat(col) * itemSize.width
                y = insets.top + CGFloat(row) * itemSize.height
                let emoticon = emoticons[index]
                let node = EmoticonNode(emoticon: emoticon)
                node.frame = CGRect(x: x, y: y, width: itemSize.width, height: itemSize.height)
                addSubnode(node)
            }
        }
    }
    
}

class EmoticonNode: ASDisplayNode {
    
    private let imageNode = ASImageNode()
    
    private let textNode = ASTextNode()
    
    private let emoticon: Emoticon
    
    init(emoticon: Emoticon) {
        self.emoticon = emoticon
        super.init()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [imageNode, textNode]
        return stack
    }
    
}
