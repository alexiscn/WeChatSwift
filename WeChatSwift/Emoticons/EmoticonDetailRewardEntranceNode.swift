//
//  EmoticonDetailRewardEntranceNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/21.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonDetailRewardEntranceNode: ASDisplayNode {
    
    private let begWordNode = ASTextNode()
    
    private let rewardButtonNode = ASButtonNode()
    
    private let donorsCountNode = ASTextNode()
    
    init(donation: [Int]) {
        super.init()
        automaticallyManagesSubnodes = true
        
        //FF6A55
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        rewardButtonNode.style.preferredSize = CGSize(width: 75, height: 32)
        
        return ASLayoutSpec()
    }
    
}
