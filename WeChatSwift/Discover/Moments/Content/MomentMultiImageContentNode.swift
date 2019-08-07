//
//  MultiImageContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

extension MomentCellNode {
    
    class MultiImageContentNode: MomentContentNode {
        
        private var imageNodes: [ASNetworkImageNode] = []
        
        init(multiImage: MomentMultiImage) {
            super.init()
            automaticallyManagesSubnodes = true
            for image in multiImage.images {
                let node = ASNetworkImageNode()
                node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
                node.url = image.url
                imageNodes.append(node)
            }
        }
        
        override func didLoad() {
            super.didLoad()
        }
        
        override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
            let spacing: CGFloat = 6
            let itemWidth: CGFloat = 82.0
            let itemHeight: CGFloat = 82.0
            for (index, imageNode) in imageNodes.enumerated() {
                let row = CGFloat(index / 3)
                let col = CGFloat(index % 3)
                let x = col * (itemWidth + spacing)
                let y = row * (itemHeight + spacing)
                imageNode.style.preferredSize = CGSize(width: itemWidth, height: itemHeight)
                imageNode.style.layoutPosition = CGPoint(x: x, y: y)
            }
            let layoutSpec = ASAbsoluteLayoutSpec(children: imageNodes)
            return layoutSpec
        }
    }
}
