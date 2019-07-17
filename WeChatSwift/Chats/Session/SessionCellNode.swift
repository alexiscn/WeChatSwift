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
    
    private let badgeNode = BadgeNode()
    
    private let titleNode = ASTextNode()
    
    private let subTitleNode = ASTextNode()
    
    private let timeNode = ASTextNode()
    
    private let muteNode = ASImageNode()
    
    private let hairlineNode = ASDisplayNode()
    
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
        
        muteNode.image = UIImage.as_imageNamed("chatNotPush_15x15_")
        muteNode.style.spacingAfter = 16
        muteNode.style.preferredSize = CGSize(width: 15, height: 15)
        
        hairlineNode.backgroundColor = UIColor(white: 0, alpha: 0.15)
        hairlineNode.style.preferredSize = CGSize(width: 9, height: Constants.lineHeight)
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = UIColor(hexString: "#FEFFFF")
        badgeNode.update(count: session.unreadCount, showDot: session.showUnreadAsRedDot)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        badgeNode.style.preferredSize = CGSize(width: 30, height: 30)
        avatarNode.style.preferredSize = CGSize(width: 48.0, height: 48.0)
        
        let avatarLayout: ASLayoutSpec
        if session.unreadCount > 0 {
            avatarNode.style.layoutPosition = CGPoint(x: 16.0, y: 12.0)
            badgeNode.style.layoutPosition = CGPoint(x: 47, y: -1)
            avatarLayout = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: ASAbsoluteLayoutSpec(children: [avatarNode, badgeNode]))
        } else {
            avatarLayout = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 12), child: avatarNode)
        }
        avatarLayout.style.preferredSize = CGSize(width: 72.0, height: 76.0)
        
        titleNode.style.flexGrow = 1.0
        subTitleNode.style.flexGrow = 1.0
        subTitleNode.style.flexShrink = 1.0
        subTitleNode.style.spacingAfter = 12
        timeNode.style.spacingAfter = 16
        
        let topStack = ASStackLayoutSpec.horizontal()
        topStack.alignItems = .center
        topStack.children = [titleNode, timeNode]
        
        let bottomStack = ASStackLayoutSpec.horizontal()
        bottomStack.children = session.muted ? [subTitleNode, muteNode]: [subTitleNode]
        
        let stack = ASStackLayoutSpec.vertical()
        stack.style.flexGrow = 1.0
        stack.style.flexShrink = 1.0
        stack.spacing = 6
        stack.children = [topStack, bottomStack]
        
        let layout = ASStackLayoutSpec.horizontal()
        layout.alignItems = .center
        layout.children = [avatarLayout, stack]
        layout.style.preferredSize = CGSize(width: Constants.screenWidth, height: 72)
        
        let abs = ASAbsoluteLayoutSpec(children: [layout, hairlineNode])
        hairlineNode.style.layoutPosition = CGPoint(x: 76, y: 72 - Constants.lineHeight)
        hairlineNode.style.preferredSize = CGSize(width: Constants.screenWidth - 76, height: Constants.lineHeight)
        return abs
    }
}
