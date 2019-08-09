//
//  SettingLabFooterNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingLabFooterNode: ASDisplayNode {
    
    private let descNode = ASTextNode()
    
    private let linkNode = ASButtonNode()
    
    var linkButtonHandler: RelayCommand?
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        
        descNode.attributedText = NSAttributedString(string: "使用微信插件功能，即代表你同意", attributes: [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor.white
            ])
        
        let buttonTitle = NSAttributedString(string: "《微信插件使用须知及协议》", attributes: [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: Colors.DEFAULT_LINK_COLOR
            ])
        linkNode.setAttributedTitle(buttonTitle, for: .normal)
    }
    
    override func didLoad() {
        super.didLoad()
        
        linkNode.addTarget(self, action: #selector(linkButtonClicked), forControlEvents: .touchUpInside)
    }
    
    @objc private func linkButtonClicked() {
        linkButtonHandler?()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let stack = ASStackLayoutSpec.vertical()
        stack.spacing = 5
        stack.alignItems = .center
        stack.children = [descNode, linkNode]
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 38)
        stack.style.layoutPosition = CGPoint(x: 0, y: 45)
        
        return ASAbsoluteLayoutSpec(children: [stack])
    }
    
}
