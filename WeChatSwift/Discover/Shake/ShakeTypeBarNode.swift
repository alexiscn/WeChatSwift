//
//  ShakeTypeBarNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/8.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ShakeTypeBarNode: ASDisplayNode {
    
    var elements: [ASButtonNode] = []
    
    init(shakes: [ShakeType]) {
        super.init()
        automaticallyManagesSubnodes = true
        
        for shake in shakes {
            let button = ASButtonNode()
            button.laysOutHorizontally = false
            button.imageNode.style.preferredSize = CGSize(width: 38, height: 34)
            button.setAttributedTitle(shake.attributedStringForTitleNormal(), for: .normal)
            button.setAttributedTitle(shake.attributedStringForTitleSelected(), for: .selected)
            button.setAttributedTitle(shake.attributedStringForTitleSelected(), for: .highlighted)
            button.setImage(shake.image, for: .normal)
            button.setImage(shake.highlightImage, for: .highlighted)
            button.setImage(shake.highlightImage, for: .selected)
            elements.append(button)
        }
        elements.first?.isSelected = true
    }
    
    override func didLoad() {
        super.didLoad()
        
        elements.forEach { $0.addTarget(self, action: #selector(shakeTypeButtonClicked(_:)), forControlEvents: .touchUpInside) }
    }
    
    @objc private func shakeTypeButtonClicked(_ sender: ASButtonNode) {
        elements.forEach { $0.isSelected = false }
        sender.isSelected = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let padding: CGFloat = 35.0
        let itemWidth = (Constants.screenWidth - 2 * padding)/CGFloat(elements.count)
        
        for (index, element) in elements.enumerated() {
            element.style.preferredSize = CGSize(width: itemWidth, height: constrainedSize.max.height)
            element.style.layoutPosition = CGPoint(x: padding + CGFloat(index) * itemWidth, y: 0)
        }
        return ASAbsoluteLayoutSpec(children: elements)
    }
}
