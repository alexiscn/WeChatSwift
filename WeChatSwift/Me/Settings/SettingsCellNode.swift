//
//  SettingsCellNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/21.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingsCellNode: ASCellNode {
    
    private let titleNode: ASTextNode
    
    private let arrowNode: ASImageNode
    
    private let model: SettingsTableModel
    
    init(model: SettingsTableModel) {
        self.model = model
        titleNode = ASTextNode()
        
        arrowNode = ASImageNode()
        
        super.init()
        automaticallyManagesSubnodes = true
        titleNode.attributedText = model.attributedStringForTitle()
        arrowNode.image = UIImage.SVGImage(named: "icons_outlined_arrow")
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = Colors.white
    }
 
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        if model.type == .logout || model.type == .switchAccount {
            let center = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: titleNode)
            center.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
            return center
        }
        
        titleNode.style.spacingBefore = 16
        arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
        arrowNode.style.spacingAfter = 16
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        stack.children = [titleNode, spacer, arrowNode]
        
        return ASInsetLayoutSpec(insets: .zero, child: stack)
    }
}
