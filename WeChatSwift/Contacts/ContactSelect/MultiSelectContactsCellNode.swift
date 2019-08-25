//
//  MultiSelectContactsCellNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/25.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MultiSelectContactsCellNode: ASCellNode {
    
    private let checkboxButton = ASButtonNode()
    
    private let avatarImageNode = ASImageNode()
    
    private let nameNode = ASTextNode()
    
    private let lineNode = ASDisplayNode()
    
    init(contact: ContactModel, isLastCell: Bool) {
        super.init()
        automaticallyManagesSubnodes = true
        
        let normalImage = UIImage.SVGImage(named: "ui-resources_checkbox_unselected", fillColor: Colors.DEFAULT_TEXT_DARK_COLOR)
        let selectedImage = UIImage.SVGImage(named: "ui-resources_checkbox_selected", fillColor: Colors.Brand)
        checkboxButton.setImage(normalImage, for: .normal)
        checkboxButton.setImage(selectedImage, for: .selected)
        
        nameNode.attributedText = contact.wc_attributedStringForTitle()
        
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        checkboxButton.style.spacingBefore = 16
        checkboxButton.style.preferredSize = CGSize(width: 24.0, height: 24.0)
        
        avatarImageNode.style.preferredSize = CGSize(width: 40.0, height: 40.0)
        
        nameNode.style.flexGrow = 1.0
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = [checkboxButton, avatarImageNode, nameNode]
        
        return ASLayoutSpec()
    }
    
    //
    
}
