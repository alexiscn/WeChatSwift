//
//  EmoticonDetailPackageDescNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/22.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonDetailPackageDescNode: ASDisplayNode {
    
    private let titleNode = ASTextNode()
    
    private let descNode = ASTextNode()
    
    private let actionButton = ASButtonNode()
    
    private let lineNode = ASDisplayNode()
    
    init(string: String) {
        super.init()
        automaticallyManagesSubnodes = true
        
        titleNode.attributedText = NSAttributedString(string: "小刘鸭第三弹", attributes: [
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor: UIColor(hexString: "#535353")
        ])
        
        descNode.maximumNumberOfLines = 0
        descNode.attributedText = NSAttributedString(string: "哈哈哈哈噶！小刘我又来啦，有没有", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(hexString: "#6C6C6C")
            ])
        lineNode.backgroundColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        
        actionButton.style.preferredSize = CGSize(width: 90, height: 32)
        actionButton.style.spacingAfter = 15
        
        lineNode.style.preferredSize = CGSize(width: constrainedSize.max.width - 30, height: Constants.lineHeight)
        
        let topStack = ASStackLayoutSpec.horizontal()
        topStack.children = [titleNode, actionButton]
        
        let topSpacer = ASLayoutSpec()
        topSpacer.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 20)
        
        
        let layout = ASStackLayoutSpec.vertical()
        layout.spacing = 10
        layout.children = [topSpacer, topStack, descNode, lineNode]
        
        let insets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        return ASInsetLayoutSpec(insets: insets, child: layout)
    }
    
    
}
