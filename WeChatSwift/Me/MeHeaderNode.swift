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
        
        
        nameNode.attributedText = NSAttributedString(string: "这是一个昵称", attributes: [
            .font: UIFont.systemFont(ofSize: 22, weight: .medium),
            .foregroundColor: UIColor.black
            ])
        qrCodeNode.image = UIImage.as_imageNamed("icons_outlined_qr-code")
        arrowNode.image = UIImage.as_imageNamed("icons_outlined_arrow")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        nameNode.style.flexGrow = 1.0
        descNode.style.flexGrow = 1.0
        
        avatarNode.style.preferredSize = CGSize(width: 64, height: 64)
        qrCodeNode.style.preferredSize = CGSize(width: 18, height: 18)
        arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
        
        let descStack = ASStackLayoutSpec.horizontal()
        descStack.children = [descNode, qrCodeNode, arrowNode]
        
        let infoStack = ASStackLayoutSpec.vertical()
        infoStack.children = [nameNode, descStack]
        
        let layout = ASStackLayoutSpec.horizontal()
        layout.children = [avatarNode, infoStack]
        
        return layout
    }
    
}
