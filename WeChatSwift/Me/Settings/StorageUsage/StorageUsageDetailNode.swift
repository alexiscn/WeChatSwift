//
//  StorageUsageDetailNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class StorageUsageDetailNode: ASDisplayNode {
    
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
            .foregroundColor: UIColor(hexString: "#F7F7F7")
            ])
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let stack = ASStackLayoutSpec.vertical()
        stack.spacing = 8
        stack.children = [titleNode, fileSizeNode, descNode]
        
        let insets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        let layout = ASInsetLayoutSpec(insets: insets, child: stack)
        
        return ASLayoutSpec()
    }
    
}


