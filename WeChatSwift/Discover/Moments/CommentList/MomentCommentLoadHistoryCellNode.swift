//
//  MomentCommentLoadHistoryCellNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/15.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentCommentLoadHistoryCellNode: ASCellNode {
    
    private let textNode = ASTextNode()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        textNode.attributedText = NSAttributedString(string: "查看更早的消息...", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(hexString: "#737373")
            ])
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let layout = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: textNode)
        layout.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 60.0)
        return layout
    }
}
