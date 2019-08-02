//
//  SettingDiscoverEntranceCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingDiscoverEntranceCellNode: ASCellNode {
    
    private let iconNode = ASImageNode()
    
    private let titleNode = ASTextNode()
    
    init(string: String) {
        super.init()
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASLayoutSpec()
    }
    
}
