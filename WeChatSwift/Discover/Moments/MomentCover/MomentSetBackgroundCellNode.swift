//
//  MomentSetBackgroundCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentSetBackgroundCellNode: ASCellNode {
    
    private let nameNode = ASTextNode()
    
    private let imageGridNode: MomentCoverImageGridNode
    
    init(group: MomentBackgroundGroup) {
        
        imageGridNode = MomentCoverImageGridNode(images: group.items)
        
        super.init()
        automaticallyManagesSubnodes = true
        nameNode.attributedText = group.attributedStringForName()
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        nameNode.style.preferredSize = CGSize(width: 79, height: 20)
        nameNode.style.spacingBefore = 5
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        let horizontalStack = ASStackLayoutSpec.horizontal()
        horizontalStack.children = [nameNode, imageGridNode, spacer]
        
        let bottomSpacer = ASLayoutSpec()
        bottomSpacer.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 30.0)
        
        let layout = ASStackLayoutSpec.vertical()
        layout.children = [horizontalStack, bottomSpacer]
        
        return ASInsetLayoutSpec(insets: .zero, child: layout)
    }
    
}

class MomentCoverImageGridNode: ASDisplayNode {
    
    private let itemWidth: CGFloat = 75.0
    
    private let itemHeight: CGFloat = 75.0
    
    private let stepX: CGFloat = 79.0
    
    private let stepY: CGFloat = 79.0
    
    private var elements: [ASNetworkImageNode] = []
    
    init(images: [MomentBackground]) {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        for image in images {
            let element = ASNetworkImageNode()
            element.url = image.previewURL
            elements.append(element)
        }
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        for (index, element) in elements.enumerated() {
            let row = CGFloat(index / 3)
            let col = CGFloat(index % 3)
            element.style.preferredSize = CGSize(width: itemWidth, height: itemHeight)
            element.style.layoutPosition = CGPoint(x: stepX * col, y: stepY * row)
        }
        return ASAbsoluteLayoutSpec(children: elements)
    }
}
