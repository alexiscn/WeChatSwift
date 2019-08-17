//
//  EmoticonManageCellNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonManageCellNode: ASCellNode {
    
    private let iconNode = ASNetworkImageNode()
    
    private let titleNode = ASTextNode()
    
    private let actionButton = ASButtonNode()
    
    private let lineNode = ASDisplayNode()
    
    init(string: String, isLastCell: Bool) {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASStackLayoutSpec.horizontal()
    }
}
