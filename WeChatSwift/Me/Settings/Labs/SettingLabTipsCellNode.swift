//
//  SettingLabTipsCellNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/11.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingLabTipsCellNode: ASCellNode {
    
    private let leftLineNode = ASDisplayNode()
    
    private let rightLineNode = ASDisplayNode()
    
    private let titleNode = ASTextNode()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        
        leftLineNode.backgroundColor = .white
        rightLineNode.backgroundColor = .white
        titleNode.attributedText = NSAttributedString(string: "暂无功能可使用", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.white
        ])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        leftLineNode.style.preferredSize = CGSize(width: 28, height: Constants.lineHeight)
        rightLineNode.style.preferredSize = CGSize(width: 28, height: Constants.lineHeight)
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.spacing = 16
        stack.verticalAlignment = .center
        stack.horizontalAlignment = .middle
        stack.children = [leftLineNode, titleNode, rightLineNode]
        return stack
    }
    
}
