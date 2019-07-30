//
//  PayOfflinePayCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/30.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class PayOfflinePayCellNode: ASCellNode {
    
    private let imageNode = ASImageNode()
    
    private let titleNode = ASTextNode()
    
    private let arrowNode = ASImageNode()
    
    private let lineNode = ASDisplayNode()
    
    init(action: PayOfflinePayAction) {
        super.init()
        automaticallyManagesSubnodes = true
        imageNode.image = action.image
        titleNode.attributedText = action.attributedStringForTitle()
        arrowNode.image = UIImage.as_imageNamed("OfflinePay_Arrorw_8x12_")
        lineNode.backgroundColor = UIColor(white: 1, alpha: 0.15)
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = UIColor(hexString: "#FFFFFF", alpha: 0.07)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        imageNode.style.spacingBefore = 20
        arrowNode.style.preferredSize = CGSize(width: 8, height: 12)
        titleNode.style.flexGrow = 1.0
        lineNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: Constants.lineHeight)
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = [imageNode, titleNode, arrowNode]
        
        let insets = UIEdgeInsets(top: 22, left: 10, bottom: 22, right: 10)
        
        let layout = ASStackLayoutSpec.vertical()
        layout.children = [ASInsetLayoutSpec(insets: insets, child: stack), lineNode]
        
        return layout
    }
    
}
