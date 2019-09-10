//
//  VoiceContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class VoiceContentNode: MessageContentNode {
    
    private let bubbleNode = ASImageNode()
    
    private let imageNode = ASImageNode()
    
    private let durationNode = ASTextNode()
    
    private let unreadNode = ASImageNode()
    
    init(message: Message, voiceMsg: VoiceMessage) {
        
        let icon = message.isOutgoing ? "ChatRoom_Bubble_Text_Sender_Green_57x40_": "ChatRoom_Bubble_Text_Receiver_White_57x40_"
        bubbleNode.image = UIImage(named: icon)
        bubbleNode.style.flexShrink = 1
        
        super.init(message: message)
        
        addSubnode(bubbleNode)
        addSubnode(imageNode)
        addSubnode(durationNode)
        addSubnode(unreadNode)
        
        let image = message.isOutgoing ? "ChatRoom_Bubble_Voice_Sender_24x24_": "ChatRoom_Bubble_Voice_Receiver_24x24_"
        imageNode.image = UIImage.as_imageNamed(image)
        unreadNode.image = UIImage.as_imageNamed("VoiceNodeUnread_8x8_")
        unreadNode.style.preferredSize = CGSize(width: 8, height: 8)
        durationNode.attributedText = voiceMsg.attributedStringForDuration()
        
        supportedMenus = [.playWithEarphone, .addFavorite, .translate, .multiSelect, .delete, .remind]
    }
 
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        imageNode.style.preferredSize = CGSize(width: 24, height: 24)
        
        let spacer = ASLayoutSpec()
        spacer.style.flexGrow = 1.0
        spacer.style.flexShrink = 1.0
        spacer.style.height = ASDimension(unit: .points, value: 40)
        spacer.style.minWidth = ASDimensionMake(20)
        
        if message.isOutgoing {
            imageNode.style.spacingAfter = 12
            imageNode.style.spacingBefore = 3
            stack.children = [spacer, durationNode, imageNode]
        } else {
            imageNode.style.spacingAfter = 3
            imageNode.style.spacingBefore = 12
            stack.children = [imageNode, durationNode, spacer]
        }
        
        let backgroundSpec = ASBackgroundLayoutSpec(child: stack, background: bubbleNode)
        
        let layout = ASStackLayoutSpec.horizontal()
        layout.alignItems = .center
        layout.spacing = 10
        layout.children = message.isOutgoing ? [backgroundSpec] : [backgroundSpec, unreadNode]
        return ASInsetLayoutSpec(insets: .zero, child: layout)
    }
}
