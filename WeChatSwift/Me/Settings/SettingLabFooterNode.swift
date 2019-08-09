//
//  SettingLabFooterNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingLabFooterNode: ASDisplayNode {
    
    private let descNode = ASTextNode()
    
    private let linkNode = ASButtonNode()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        
        descNode.attributedText = NSAttributedString(string: "使用微信插件功能，即代表你同意", attributes: [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.white
            ])
        
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASLayoutSpec()
    }
    
}
