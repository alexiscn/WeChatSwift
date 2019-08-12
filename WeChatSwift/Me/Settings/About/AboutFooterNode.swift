//
//  AboutFooterNode.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/12.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class AboutFooterNode: ASDisplayNode {
    
    private let agreementButton = ASButtonNode()
    
    private let andTextNode = ASTextNode()
    
    private let privacyButton = ASButtonNode()
    
    private let copyRightNode = ASTextNode()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        let agreementText = NSAttributedString(string: "《微信软件许可及服务协议》", attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: Colors.DEFAULT_LINK_COLOR
        ])
        agreementButton.setAttributedTitle(agreementText, for: .normal)
        
        andTextNode.attributedText = NSAttributedString(string: "和", attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: Colors.black
        ])
        
        let privacyText = NSAttributedString(string: "《微信隐私保护指引》", attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: Colors.DEFAULT_LINK_COLOR
        ])
        privacyButton.setAttributedTitle(privacyText, for: .normal)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 3
        let copyRight = "腾讯公司 版权所有\nCopyright © 2011-2019 Tencent.All Rights Reserved."
        copyRightNode.attributedText = NSAttributedString(string: copyRight, attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor(white: 0, alpha: 0.3),
            .paragraphStyle: paragraphStyle
        ])
    }
    
    override func didLoad() {
        super.didLoad()
        
        agreementButton.addTarget(self, action: #selector(agreementButtonClicked), forControlEvents: .touchUpInside)
        privacyButton.addTarget(self, action: #selector(privacyButtonClicked), forControlEvents: .touchUpInside)
    }
    
    @objc private func agreementButtonClicked() {
        
    }
    
    @objc private func privacyButtonClicked() {
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.horizontalAlignment = .middle
        stack.verticalAlignment = .center
        stack.children = [agreementButton, andTextNode, privacyButton]
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 15)
        
        let topSpacer = ASLayoutSpec()
        topSpacer.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 20)
        
        let centerSpacer = ASLayoutSpec()
        centerSpacer.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 16)
        
        let bottomSpacer = ASLayoutSpec()
        bottomSpacer.style.flexGrow = 1.0
        
        let layout = ASStackLayoutSpec.vertical()
        layout.children = [topSpacer, stack, centerSpacer, copyRightNode, bottomSpacer]
        
        return layout
    }
}
