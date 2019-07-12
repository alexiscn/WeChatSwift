//
//  SessionCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/12.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SessionCellNode: ASCellNode {
    
    private let avatarNode = ASImageNode()
    
    //private let redDi
    
    private let titleNode = ASTextNode()
    
    private let subTitleNode = ASTextNode()
    
    private let timeNode = ASTextNode()
    
    private let muteNode = ASImageNode()
    
    init(session: Session) {
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        avatarNode.cornerRadius = 4.0
        avatarNode.cornerRoundingType = .clipping
        avatarNode.style.preferredSize = CGSize(width: 48.0, height: 48.0)
        
        titleNode.style.flexGrow = 1.0
        titleNode.attributedText = session.attributedStringForTitle()
        
        muteNode.image = UIImage.SVGImage(named: "icons_outlined_mute")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let layout = ASStackLayoutSpec.horizontal()
        layout.alignItems = .center
        layout.children = [avatarNode]
        
        let topStack = ASStackLayoutSpec.horizontal()
        topStack.children = [titleNode, timeNode]
        
        let bottomStack = ASStackLayoutSpec.horizontal()
        bottomStack.children = [subTitleNode, muteNode]
        
        return ASInsetLayoutSpec(insets: .zero, child: layout)
    }
}
