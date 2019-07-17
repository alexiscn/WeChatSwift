//
//  MultiImageContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

extension MomentCellNode {
    
    class MultiImageContentNode: MomentContentNode {
        override init() {
            super.init()
        }
        
        override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
            return ASLayoutSpec()
        }
    }
}
