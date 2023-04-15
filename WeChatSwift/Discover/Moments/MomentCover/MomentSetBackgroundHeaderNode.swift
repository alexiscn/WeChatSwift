//
//  MomentSetBackgroundHeaderNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentSetBackgroundHeaderNode: ASDisplayNode {
    
    private let avatarNode = ASNetworkImageNode()
    
    private let nameNode = ASTextNode()
    
    private let descNode = ASTextNode()
    
    private let lineNode = ASImageNode()
    
    init(artist: MomentBackgroundArtist) {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        avatarNode.url = artist.thumbAvatarURL
        
        nameNode.attributedText = NSAttributedString(string: artist.name, attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            .foregroundColor: Colors.white
            ])
        
        descNode.maximumNumberOfLines = 0
        descNode.attributedText = NSAttributedString(string: artist.desc, attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor(hexString: "#909090")
            ])
        
        lineNode.image = UIImage.as_imageNamed("PhotographerSeparator_320x2_")
    }

    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        avatarNode.style.preferredSize = CGSize(width: 60.0, height: 60.0)
        
        descNode.style.flexShrink = 1.0
        
        let stack = ASStackLayoutSpec.vertical()
        stack.spacing = 15
        stack.children = [nameNode, descNode]
        //stack.style.maxWidth = constrainedSize.max.width - 60.0 - 15.0 - 12.0 - 15.0
        
        let horizontalStack = ASStackLayoutSpec.horizontal()
        horizontalStack.spacing = 12
        horizontalStack.children = [avatarNode, stack]
        horizontalStack.style.layoutPosition = CGPoint(x: 15, y: 20)
        horizontalStack.style.preferredSize = CGSize(width: constrainedSize.max.width - 35, height: constrainedSize.max.height - 20)
        
        lineNode.style.preferredSize = CGSize(width: 320, height: 2)
        lineNode.style.layoutPosition = CGPoint(x: 0, y: 144)
        
        return ASAbsoluteLayoutSpec(children: [horizontalStack, lineNode])
    }
}
