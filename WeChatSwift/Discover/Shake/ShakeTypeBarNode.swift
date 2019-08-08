//
//  ShakeTypeBarNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/8.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ShakeTypeBarNode: ASDisplayNode {
    
    var elements: [ASButtonNode] = []
    
    init(shakes: [ShakeType]) {
        super.init()
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASLayoutSpec()
    }
}

enum ShakeType {
    case people
    case music
    case tv
}
