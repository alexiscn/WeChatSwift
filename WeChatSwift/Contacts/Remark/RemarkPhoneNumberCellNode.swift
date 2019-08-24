//
//  RemarkPhoneNumberCellNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/11.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class RemarkPhoneNumberCellNode: ASCellNode {
    
    private let inputTextNode = ASEditableTextNode()
    
    init(string: String) {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let layout = ASInsetLayoutSpec(insets: .zero, child: inputTextNode)
        layout.style.preferredSize = CGSize(width: Constants.screenWidth , height: 56)
        return layout
    }
    
}
