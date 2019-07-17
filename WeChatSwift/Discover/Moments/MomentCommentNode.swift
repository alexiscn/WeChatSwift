//
//  MomentCommentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentCommentNode: ASDisplayNode {
    
    private let triangleNode = ASImageNode()
    
    private let containerNode = ASDisplayNode()
    
    override init() {
        super.init()
        triangleNode.image = UIImage.as_imageNamed("AlbumTriangleB_45x6_")
        triangleNode.style.preferredSize = CGSize(width: 45, height: 6)
        containerNode.backgroundColor = UIColor(hexString: "#F3F3F5")
    }
    
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [triangleNode, containerNode]
        
        return ASInsetLayoutSpec(insets: .zero, child: stack)
    }
}
