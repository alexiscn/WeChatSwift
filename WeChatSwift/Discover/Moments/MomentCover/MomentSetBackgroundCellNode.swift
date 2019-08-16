//
//  MomentSetBackgroundCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentSetBackgroundCellNode: ASCellNode {
    
    private let nameNode = ASTextNode()
    
    init(group: MomentBackgroundGroup) {
        super.init()
        
        nameNode.attributedText = group.attributedStringForName()
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASLayoutSpec()
    }
    
}
