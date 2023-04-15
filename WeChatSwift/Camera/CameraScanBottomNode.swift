//
//  CameraScanBottomNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/13.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class CameraScanBottomNode: ASDisplayNode {
    
    private var elements: [ASButtonNode] = []
    
    private let spacing: CGFloat = 4.0
    
    private let itemWidth: CGFloat = 67.0
    
    private let itemHeight: CGFloat = 83.0
    
    private var previousSelectedButton: ASButtonNode?
    
    init(scanTypes: [CameraScanType]) {
        super.init()
        automaticallyManagesSubnodes = true
        for scan in scanTypes {
            let scanButton = ASButtonNode()
            scanButton.laysOutHorizontally = false
            scanButton.setImage(scan.image, for: .normal)
            scanButton.setImage(scan.lighlightImage, for: .highlighted)
            scanButton.setImage(scan.lighlightImage, for: .selected)
            scanButton.setAttributedTitle(scan.attributedStringForNormalTitle(), for: .normal)
            scanButton.setAttributedTitle(scan.attributedStringForHighlightTitle(), for: .highlighted)
            scanButton.setAttributedTitle(scan.attributedStringForHighlightTitle(), for: .selected)
            elements.append(scanButton)
        }
        elements.first?.isSelected = true
        previousSelectedButton = elements.first
    }
    
    override func didLoad() {
        super.didLoad()
        backgroundColor = UIColor(white: 0, alpha: 0.85)
        elements.forEach { $0.addTarget(self, action: #selector(handleButtonClicked(_:)), forControlEvents: .touchUpInside) }
    }
    
    @objc private func handleButtonClicked(_ sender: ASButtonNode) {
        if previousSelectedButton == sender {
            return
        }
        previousSelectedButton?.isSelected = false
        sender.isSelected = true
        previousSelectedButton = sender
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let padding = (constrainedSize.max.width - spacing * CGFloat(elements.count - 1) - CGFloat(elements.count) * itemWidth)/2.0
        for (index, button) in elements.enumerated() {
            button.style.preferredSize = CGSize(width: itemWidth, height: itemHeight)
            button.style.layoutPosition = CGPoint(x: padding + (itemWidth + spacing) * CGFloat(index), y: 15.0)
        }
        return ASAbsoluteLayoutSpec(children: elements)
    }
    
}

