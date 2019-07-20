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
        
        hairlineNode.backgroundColor = UIColor(hexString: "#ECECEC")
    }
    
    override func didLoad() {
        super.didLoad()
        
        let selected = UIView()
        selected.backgroundColor = UIColor(hexString: "#F6F6F8")
        selectedBackgroundView = selected
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.style.preferredSize = CGSize(width: 24, height: 24)
        let center = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: imageNode)
        center.style.preferredSize = constrainedSize.max
        center.style.layoutPosition = .zero
        
        hairlineNode.style.preferredSize = CGSize(width: 0.5, height: 32)
        hairlineNode.style.layoutPosition = CGPoint(x: constrainedSize.max.width - 0.5, y: (constrainedSize.max.height - 32)/2)
        return ASAbsoluteLayoutSpec(children: [center, hairlineNode])
    }
}
