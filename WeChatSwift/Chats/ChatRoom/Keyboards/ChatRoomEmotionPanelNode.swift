//
//  ChatRoomEmotionPanelNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ChatRoomEmotionPanelNode: ASDisplayNode, ASPagerDelegate, ASPagerDataSource {
    
    var pagerNode: ASPagerNode = ASPagerNode()
    
    private let dataSource: [Expression]
    
    init(expressions: [Expression]) {
        self.dataSource = expressions
        super.init()
        
        let itemSize = CGSize(width: 24.0, height: 24.0)
        let itemSpacing: CGFloat = 6
        var margin: CGFloat = 12.0
        
        let count = (Constants.screenWidth - 2.0 * margin + itemSpacing) / (itemSpacing + itemSize.width)
        print(count)
        
        addSubnode(pagerNode)
    }
    
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return 0
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
        let block = {
            return ASCellNode()
        }
        return block
    }
}
