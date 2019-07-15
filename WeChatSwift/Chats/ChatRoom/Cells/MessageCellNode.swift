//
//  MessageCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

/*
| -------------------topTextNode--------------------- |
| avatarNode? |   contentTopTextNode?   | avatarNode? |
|             |      contentNode        |             |
|             |                         |             |
| -----------------bottomTextNode---------------------|
*/

/// Base Message Cell Node
public class MessageCellNode: ASCellNode {
    
    let isOutgoing: Bool
    
    private var topTextNode: ASTextNode?
    
    private var contentTopTextNode: ASTextNode?
    
    private let contentNode: MessageContentNode
    
    private var bottomTextNode: ASTextNode?
    
    private var avatarNode: ASNetworkImageNode = ASNetworkImageNode()
    
    private var statusNode: ASImageNode?
    
    private let message: Message
    
    public init(message: Message, contentNode: MessageContentNode) {
        
        self.message = message
        self.isOutgoing = message.isOutgoing
        
        if let formattedTime = message._formattedTime {
            topTextNode = ASTextNode()
            topTextNode?.attributedText = NSAttributedString(string: formattedTime)
            topTextNode?.style.alignSelf = .center
        }
        self.contentNode = contentNode
        
        avatarNode.style.preferredSize = CGSize(width: 40, height: 40)
        
        super.init()
        
        if let node = topTextNode {
            addSubnode(node)
        }
        addSubnode(avatarNode)
        addSubnode(contentNode)
        if let node = contentTopTextNode {
            addSubnode(node)
        }
        if let node = bottomTextNode {
            addSubnode(node)
        }
        
        selectionStyle = .none
        let user = MockFactory.shared.users.first(where: { $0.identifier == message.senderID })
        let avatar = user?.avatar ?? "DefaultHead_48x48_"
        avatarNode.image = UIImage.as_imageNamed(avatar)
        avatarNode.cornerRadius = 6.0
        avatarNode.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        avatarNode.cornerRoundingType = .clipping
        
        avatarNode.addTarget(self, action: #selector(avatarClicked), forControlEvents: .touchUpInside)
    }
    
    @objc private func avatarClicked() {
        
    }
    
    public override func didLoad() {
        super.didLoad()
    }
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let contentVerticalStack = ASStackLayoutSpec.vertical()
        contentVerticalStack.style.flexShrink = 1.0
        contentVerticalStack.style.flexGrow = 1.0
        contentVerticalStack.style.spacingAfter = 5.0
        contentVerticalStack.style.spacingBefore = 5.0
        if let contentTopTextNode = contentTopTextNode {
            contentVerticalStack.children = [contentTopTextNode, contentNode]
        } else {
            contentVerticalStack.children = [contentNode]
        }
        
        let contentHorizontalStack = ASStackLayoutSpec.horizontal()
        contentHorizontalStack.justifyContent = .start
        let fakeAvatarNode = ASDisplayNode()
        fakeAvatarNode.style.preferredSize = CGSize(width: 40, height: 40)
        if isOutgoing {
            contentHorizontalStack.children = [fakeAvatarNode, contentVerticalStack, avatarNode]
        } else {
            contentHorizontalStack.children = [avatarNode, contentVerticalStack, fakeAvatarNode]
        }
        let contentHorizontalSpec = ASInsetLayoutSpec(insets: .zero, child: contentHorizontalStack)
        
        let layoutSpec = ASStackLayoutSpec.vertical()
        layoutSpec.justifyContent = .start
        layoutSpec.alignItems = isOutgoing ? .end: .start
        var layoutElements: [ASLayoutElement] = []
        if let topTextNode = topTextNode {
            layoutElements.append(topTextNode)
        }
        layoutElements.append(contentHorizontalSpec)
        if let bottomTextNode = bottomTextNode {
            layoutElements.append(bottomTextNode)
        }
        layoutSpec.children = layoutElements
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12), child: layoutSpec)
        
    }
}


