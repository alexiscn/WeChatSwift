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
    
    private let likeElements: [ASButtonNode] = []
    
    private let commentElements: [ASTextNode] = []
    
    init(likes: [MomentLikeUser], comments: [MomentComment]) {
        super.init()
        triangleNode.image = UIImage.as_imageNamed("AlbumTriangleB_45x6_")
        triangleNode.style.preferredSize = CGSize(width: 45, height: 6)
        containerNode.backgroundColor = UIColor(hexString: "#F3F3F5")
        
     
        for likeUser in likes {
            
        }
        
    }
    
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [triangleNode, containerNode]
        
        return ASInsetLayoutSpec(insets: .zero, child: stack)
    }
}

extension MomentCommentNode: ASTextNodeDelegate {
    
}

private class MomentLineNode: ASDisplayNode {
    
    override func didLoad() {
        super.didLoad()
        
        let backLayer = CAShapeLayer()
        backLayer.frame = CGRect(x: 0, y: (1.0 - Constants.lineHeight)/2.0, width: bounds.width, height: Constants.lineHeight)
        backLayer.backgroundColor = UIColor(hexString: "#DDDEDF").cgColor
        layer.addSublayer(backLayer)
        
        let frontLayer = CAShapeLayer()
        frontLayer.backgroundColor = UIColor(hexString: "#F6F7F7").cgColor
        frontLayer.frame = CGRect(x: 0, y: (1.0 - Constants.lineHeight)/2.0, width: bounds.width, height: Constants.lineHeight)
        layer.addSublayer(frontLayer)
    }
}
