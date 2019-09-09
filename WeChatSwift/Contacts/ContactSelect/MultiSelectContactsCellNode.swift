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
    
    private let avatarImageNode = ASNetworkImageNode()
    
    private let nameNode = ASTextNode()
    
    private let lineNode = ASDisplayNode()
    
    private let isLastCell: Bool
    
    init(contact: MultiSelectContact, isLastCell: Bool) {
        self.isLastCell = isLastCell
        super.init()
        automaticallyManagesSubnodes = true
        
        let normalImage = UIImage.SVGImage(named: "ui-resources_checkbox_unselected", fillColor: Colors.DEFAULT_TEXT_DISABLED_COLOR)
        let selectedImage = UIImage.SVGImage(named: "ui-resources_checkbox_selected", fillColor: Colors.Brand)
        checkboxButton.setImage(normalImage, for: .normal)
        checkboxButton.setImage(selectedImage, for: .selected)
        checkboxButton.isSelected = contact.isSelected
        
        avatarImageNode.url = contact.avatarURL
        avatarImageNode.cornerRadius = 4
        avatarImageNode.cornerRoundingType = .precomposited
        nameNode.attributedText = contact.attributedTextForName()
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = .white
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        checkboxButton.style.spacingBefore = 16
        checkboxButton.style.preferredSize = CGSize(width: 24.0, height: 24.0)
        avatarImageNode.style.preferredSize = CGSize(width: 40.0, height: 40.0)
        nameNode.style.flexGrow = 1.0
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.spacing = 16.0
        stack.alignItems = .center
        stack.children = [checkboxButton, avatarImageNode, nameNode]
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
        
        lineNode.isHidden = isLastCell
        lineNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 108, height: Constants.lineHeight)
        lineNode.style.layoutPosition = CGPoint(x: 108.0, y: 56.0 - Constants.lineHeight)
        
        return ASAbsoluteLayoutSpec(children: [stack, lineNode])
    }
}
