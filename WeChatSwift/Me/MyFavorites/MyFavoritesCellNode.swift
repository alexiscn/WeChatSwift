//
//  MyFavoritesCellNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/11.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MyFavoritesCellNode: ASCellNode {
    
    private let contentNode: MyFavoriteContentNode
    
    private let nameNode = ASTextNode()
    
    private let timeNode = ASTextNode()
    
    init(favItem: FavoriteItem) {
        
        contentNode = MyFavoriteContentNode()
        
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = .white
        cornerRadius = 8
        cornerRoundingType = .precomposited
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let footerStack = ASStackLayoutSpec.horizontal()
        footerStack.alignItems = .center
        footerStack.spacing = 10
        footerStack.children = [nameNode, timeNode]
        
        let layout = ASStackLayoutSpec.vertical()
        layout.spacing = 12
        layout.children = [contentNode, footerStack]
        
        let insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        return ASInsetLayoutSpec(insets: insets, child: layout)
    }
    
}


class MyFavoriteContentNode: ASDisplayNode {
    
}
