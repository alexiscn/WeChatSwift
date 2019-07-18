//
//  EmoticonBoardTabBarCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/18.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonBoardTabBarCellNode: ASCellNode {
    
    private let imageNode = ASImageNode()
    
    private let hairlineNode = ASDisplayNode()
    
    init(viewModel: EmoticonViewModel) {
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        imageNode.image = viewModel.tabImage
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: imageNode)
    }
}
