//
//  PayOfflinePayQRCodeNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class PayOfflinePayQRCodeNode: ASDisplayNode {

    private let topBackgroundNode = ASDisplayNode()
    
    private let payIconNode = ASImageNode()
    
    private let payTitleNode = ASTextNode()
    
    private let payMoreButtonNode = ASButtonNode()
    
    private let barTipsNode = ASTextNode()
    
    private let barImageNode = ASImageNode()
    
    private let qrCodeImageNode = ASImageNode()
    
    
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        topBackgroundNode.backgroundColor = UIColor(hexString: "#F7F7F7")
        
        payIconNode.image = UIImage(named: "WCPayOfflinePay_Pay_23x23_")
        
        payTitleNode.attributedText = NSAttributedString(string: "向商家付款", attributes: [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor(hexString: "#429056")
            ])
        payMoreButtonNode.setImage(UIImage(named: "WCPayOfflinePay_dot_25x27_"), for: .normal)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        barTipsNode.attributedText = NSAttributedString(string: "点击可查看付款码数字", attributes: [
            .font: UIFont.systemFont(ofSize: 13),
            .foregroundColor: UIColor(white: 0, alpha: 0.2),
            .paragraphStyle: paragraphStyle
            ])
        
        barImageNode.image = UIImage(named: "qr_bar")
        
        qrCodeImageNode.image = UIImage(named: "qr_code")
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        payIconNode.style.preferredSize = CGSize(width: 23, height: 23)
        payIconNode.style.spacingBefore = 20
        payTitleNode.style.flexGrow = 1.0
        payMoreButtonNode.style.spacingAfter = 20
        
        let topStack = ASStackLayoutSpec.horizontal()
        topStack.alignItems = .center
        topStack.children = [payIconNode, payTitleNode, payMoreButtonNode]
        topStack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
        
        topBackgroundNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
        let backgroundSpec = ASBackgroundLayoutSpec(child: topStack, background: topBackgroundNode)
        backgroundSpec.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 56)
        
        let spacerTips = ASLayoutSpec()
        spacerTips.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 16)
        
        barImageNode.style.preferredSize = CGSize(width: 165, height: 90)
        
        qrCodeImageNode.style.preferredSize = CGSize(width: 180, height: 180)
        
        let layout = ASStackLayoutSpec.vertical()
        layout.alignItems = .center
        layout.children = [backgroundSpec, spacerTips, barTipsNode, barImageNode, qrCodeImageNode]
        
        return layout
    }
    
}
