//
//  FTSContactCellNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/20.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class FTSContactCellNode: ASCellNode {
    
    private let headImageNode = ASImageNode()
    
    private let nameNode = ASTextNode()
    
    private let detailNode = ASTextNode()
    
    private let lineNode = ASDisplayNode()
    
    private let isLastCell: Bool
    
    init(contact: Contact, searchText: String, isLastCell: Bool) {
        self.isLastCell = isLastCell
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        headImageNode.style.preferredSize = CGSize(width: 40.0, height: 40.0)
        
        let infoStack = ASStackLayoutSpec.vertical()
        infoStack.children = [nameNode, detailNode]
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.children = [headImageNode, infoStack]
        stack.alignItems = .center
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 64)
    
        if isLastCell {
            return stack
        } else {
            lineNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 20, height: Constants.lineHeight)
            lineNode.style.layoutPosition = CGPoint(x: 20, y: 64.0 - Constants.lineHeight)
            return ASAbsoluteLayoutSpec(children: [stack, lineNode])
        }
    }
}
