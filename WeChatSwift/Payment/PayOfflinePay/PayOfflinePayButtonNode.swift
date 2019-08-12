//
//  PayOfflinePayButtonNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class PayOfflinePayButtonNode: ASButtonNode {
    
    private let iconNode = ASImageNode()
    
    private let textNode = ASTextNode()
    
    private let arrowNode = ASImageNode()
    
    init(action: PayOfflinePayAction) {
        super.init()
        
        automaticallyManagesSubnodes = true
        iconNode.image = action.image
        textNode.attributedText = action.attributedStringForTitle()
        arrowNode.image = UIImage.as_imageNamed("OfflinePay_Arrorw_8x12_")
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = UIColor(hexString: "#FFFFFF", alpha: 0.07)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        iconNode.style.spacingBefore = 20
        textNode.style.flexGrow = 1.0
        arrowNode.style.preferredSize = CGSize(width: 8, height: 12)
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = [iconNode, textNode, arrowNode]
        
        let insets = UIEdgeInsets(top: 22, left: 0, bottom: 22, right: 0)
        return ASInsetLayoutSpec(insets: insets, child: stack)
    }
    
}
