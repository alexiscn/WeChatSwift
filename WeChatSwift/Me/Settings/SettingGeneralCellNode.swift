//
//  SettingGeneralCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingGeneralCellNode: ASCellNode {
    
    private let titleNode = ASTextNode()
    
    private let arrowNode = ASImageNode()
    
    init(setting: SettingGeneral) {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        titleNode.attributedText = setting.attributedStringForTitle()
        
        arrowNode.image = UIImage.SVGImage(named: "icons_outlined_arrow")
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = Colors.white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
        
        titleNode.style.flexGrow = 1.0
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.children = [titleNode, arrowNode]
        
        let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        return ASInsetLayoutSpec(insets: insets, child: stack)
    }
    
}
