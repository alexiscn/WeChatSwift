//
//  WeChatEmoticonBannerCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/30.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class WeChatEmoticonBannerCellNode: ASCellNode {
    
    private let imageNode = ASNetworkImageNode()

    init(banner: EmoticonBanner) {
        
        super.init()
        automaticallyManagesSubnodes = true
        
        imageNode.url = banner.iconUrl
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: imageNode)
    }
    
}
