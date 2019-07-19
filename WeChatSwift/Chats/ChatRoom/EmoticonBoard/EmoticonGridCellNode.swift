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
        let spacingX = viewMode.layout.spacingX
        let spacingY = viewMode.layout.spacingY
        let numberOfPerPage = viewMode.type == .expression ? (rows * columns - 1): rows * columns
        for index in 0 ..< emoticons.count {
            let page = index / numberOfPerPage // 当前的页数
            let offsetInPage = index - page * numberOfPerPage // 在当前页的索引
            let col: CGFloat = CGFloat(offsetInPage % columns) // 在当前页的列数
            let row: CGFloat = CGFloat(offsetInPage/columns) // 在当前页的行数
            let x = insetX + col * (spacingX + itemSize.width) + CGFloat(page) * Constants.screenWidth
            let y = insetY +  row * (spacingY + itemSize.height)
            let emoticon = emoticons[index]
            let node = EmoticonNode(emoticon: emoticon, itemSize: itemSize)
            node.style.preferredSize = itemSize
            node.style.layoutPosition = CGPoint(x: x, y: y)
            addSubnode(node)
            nodes.append(node)
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
        imageNode.image = emoticon.thumbImage
        imageNode.style.preferredSize = itemSize
        imageNode.contentMode = .scaleAspectFill
        addSubnode(imageNode)
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [imageNode, textNode]
        return ASInsetLayoutSpec(insets: .zero, child: imageNode)
    }
    
}
