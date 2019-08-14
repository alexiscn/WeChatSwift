//
//  MeHeaderNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MeHeaderNode: ASButtonNode {
    
    private let avatarNode = ASImageNode()
    
    private let nameNode = ASTextNode()
    
    private let descNode = ASTextNode()
    
    private let qrCodeNode = ASImageNode()
    
    private let arrowNode = ASImageNode()
    
    override init() {
        super.init()
        
        avatarNode.cornerRadius = 10
        avatarNode.cornerRoundingType = .precomposited
        avatarNode.image = UIImage.as_imageNamed("JonSnow.jpg")
        
        nameNode.attributedText = NSAttributedString(string: "这是一个昵称", attributes: [
            .font: UIFont.systemFont(ofSize: 21, weight: .medium),
            .foregroundColor: UIColor.black
            ])
        qrCodeNode.image = UIImage.SVGImage(named: "icons_outlined_qr-code")
        qrCodeNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(Colors.DEFAULT_TEXT_GRAY_COLOR)
        arrowNode.image = UIImage.SVGImage(named: "icons_outlined_arrow")
        
        descNode.attributedText = NSAttributedString(string: "微信号：wxid_xzhdsfghids", attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: UIColor(white: 0, alpha: 0.5)
            ])
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        nameNode.style.flexGrow = 1.0
        descNode.style.flexGrow = 1.0
        
        avatarNode.style.preferredSize = CGSize(width: 64, height: 64)
        avatarNode.style.spacingBefore = 16
        qrCodeNode.style.preferredSize = CGSize(width: 18, height: 18)
        qrCodeNode.style.spacingAfter = 12
        qrCodeNode.style.spacingBefore = 8
        arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
        arrowNode.style.spacingAfter = 16
        
        let descStack = ASStackLayoutSpec.horizontal()
        descStack.alignItems = .center
        descStack.style.flexGrow = 1.0
        descStack.children = [descNode, qrCodeNode, arrowNode]
        
        let infoStack = ASStackLayoutSpec.vertical()
        infoStack.style.flexGrow = 1.0
        infoStack.children = [nameNode, descStack]
        
        let horizontalStack = ASStackLayoutSpec.horizontal()
        horizontalStack.alignItems = .center
        horizontalStack.spacing = 20
        horizontalStack.children = [avatarNode, infoStack]
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        
        let layout = ASStackLayoutSpec.vertical()
        layout.children = [horizontalStack, spacer]
        
        return layout
    }
    
}
