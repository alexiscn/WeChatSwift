//
//  SessionCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/12.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SessionCellNode: ASCellNode {
    
    private let session: Session
    
    private let avatarNode = ASImageNode()
    
    //private let redDi
    
    private let titleNode = ASTextNode()
    
    private let subTitleNode = ASTextNode()
    
    private let timeNode = ASTextNode()
    
    private let muteNode = ASImageNode()
    
    init(session: Session) {
        self.session = session
        super.init()
        
        automaticallyManagesSubnodes = true
        
        let avatar = session.avatar ?? "DefaultHead_48x48_"
        avatarNode.cornerRadius = 4.0
        avatarNode.cornerRoundingType = .clipping
        avatarNode.backgroundColor = UIColor(hexString: "#FEFFFF")
        avatarNode.image = UIImage.as_imageNamed(avatar)
        
        titleNode.attributedText = session.attributedStringForTitle()
        titleNode.maximumNumberOfLines = 1
        
        timeNode.attributedText = session.attributedStringForTime()
        
        subTitleNode.attributedText = session.attributedStringForSubTitle()
        subTitleNode.maximumNumberOfLines = 1
        muteNode.image = UIImage.SVGImage(named: "icons_outlined_mute")
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = UIColor(hexString: "#FEFFFF")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        avatarNode.style.preferredSize = CGSize(width: 48.0, height: 48.0)
        avatarNode.style.spacingBefore = 16
        avatarNode.style.spacingAfter = 8
        
        titleNode.style.flexGrow = 1.0
        subTitleNode.style.flexGrow = 1.0
        subTitleNode.style.flexShrink = 1.0
        subTitleNode.style.spacingAfter = 12
        timeNode.style.spacingAfter = 16
        
        let topStack = ASStackLayoutSpec.horizontal()
        topStack.alignItems = .center
        topStack.children = [titleNode, timeNode]
        
        let bottomStack = ASStackLayoutSpec.horizontal()
        bottomStack.children = session.muted ? [subTitleNode]: [subTitleNode, muteNode]
        
        let stack = ASStackLayoutSpec.vertical()
        stack.style.flexGrow = 1.0
        stack.style.flexShrink = 1.0
        stack.spacing = 6
        stack.children = [topStack, bottomStack]
        
        let layout = ASStackLayoutSpec.horizontal()
        layout.alignItems = .center
        layout.children = [avatarNode, stack]
        
        let insets = UIEdgeInsets(top: 11, left: 0, bottom: 11, right: 0)
        
        return ASInsetLayoutSpec(insets: insets, child: layout)
    }
}
