//
//  StorageUsageDetailNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class StorageUsageDetailNode: ASCellNode {
    
    private let titleNode = ASTextNode()
    
    private let fileSizeNode = ASTextNode()
    
    private let actionButton = ASButtonNode()
    
    private let descNode = ASTextNode()
    
    init(detail: StorageUsageDetail) {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        descNode.maximumNumberOfLines = 0
        
        titleNode.attributedText = NSAttributedString(string: detail.title, attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: Colors.black
            ])
        
        fileSizeNode.attributedText = NSAttributedString(string: "50M", attributes: [
            .font: UIFont.systemFont(ofSize: 22, weight: .medium),
            .foregroundColor: Colors.black
            ])
        
        descNode.attributedText = NSAttributedString(string: detail.desc, attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(hexString: "#7F7F7F")
            ])
        
        actionButton.setAttributedTitle(detail.action.attributedText(), for: .normal)
        actionButton.setBackgroundImage(detail.action.backgroundImage, for: .normal)
        actionButton.setBackgroundImage(detail.action.highlightBackgroundImage, for: .highlighted)
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = Colors.white
        actionButton.addTarget(self, action: #selector(handleActionButtonClicked), forControlEvents: .touchUpInside)
    }
    
    @objc private func handleActionButtonClicked() {
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let stack = ASStackLayoutSpec.vertical()
        stack.spacing = 8
        stack.children = [titleNode, fileSizeNode, descNode]
        
        let insets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        let layout = ASInsetLayoutSpec(insets: insets, child: stack)
        
        actionButton.style.preferredSize = CGSize(width: 57, height: 32)
        actionButton.style.layoutPosition = CGPoint(x: constrainedSize.max.width - 57.0 - 15.0, y: 16.0)
        
        return ASAbsoluteLayoutSpec(children: [layout, actionButton])
    }
    
    
    
}


