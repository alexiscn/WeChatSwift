//
//  EmoticonGridNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonGridNode: ASCellNode {
    
    var nodes: [EmoticonNode] = []
    
    init(viewMode: EmoticonViewModel, emoticons: [Emoticon]) {
        super.init()
        
        let rows = viewMode.layout.rows
        let columns = viewMode.layout.columns
        let insetX = viewMode.layout.marginLeft
        let insetY = viewMode.layout.marginTop
        let itemSize = viewMode.layout.itemSize
        
        for row in 0 ..< rows {
            for col in 0 ..< columns {
                let index = row * columns + col
                if viewMode.type == .expression && index == rows * columns - 1 {
                    continue
                }
                let x = insetX + CGFloat(col) * (itemSize.width + viewMode.layout.spacingX)
                let y = insetY + CGFloat(row) * (itemSize.height + viewMode.layout.spacingY)
                if index >= emoticons.count {
                    continue
                }
                let emoticon = emoticons[index]
                let node = EmoticonNode(emoticon: emoticon, itemSize: itemSize)
                node.style.preferredSize = itemSize
                node.style.layoutPosition = CGPoint(x: x, y: y)
                addSubnode(node)
                nodes.append(node)
            }
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASAbsoluteLayoutSpec(children: nodes)
    }
}

class EmoticonNode: ASDisplayNode {
    
    private let imageNode = ASImageNode()
    
    private let textNode = ASTextNode()
    
    private let emoticon: Emoticon
    
    init(emoticon: Emoticon, itemSize: CGSize) {
        self.emoticon = emoticon
        super.init()
        
        imageNode.image = emoticon.image
        imageNode.style.preferredSize = itemSize
        
        addSubnode(imageNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [imageNode, textNode]
        print(constrainedSize)
        return ASInsetLayoutSpec(insets: .zero, child: imageNode)
    }
    
}
