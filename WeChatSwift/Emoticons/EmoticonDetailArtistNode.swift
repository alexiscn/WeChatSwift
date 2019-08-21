//
//  EmoticonDetailArtistNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/21.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonDetailArtistNode: ASDisplayNode {
    
    private let avatarNode = ASNetworkImageNode()
    
    private let nameNode = ASTextNode()
    
    private let descNode = ASTextNode()
    
    private let arrowNode = ASImageNode()
    
    init(artist: Contact) {
        super.init()
        automaticallyManagesSubnodes = true
        
        avatarNode.image = artist.avatar
        
        nameNode.attributedText = NSAttributedString(string: artist.name, attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .foregroundColor: Colors.black
            ])
        
        descNode.attributedText = NSAttributedString(string: "艺术家主页", attributes: [
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor(hexString: "#666666")
            ])
        
        arrowNode.image = Constants.arrowImage
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        avatarNode.style.spacingBefore = 15
        avatarNode.style.preferredSize = CGSize(width: 36.0, height: 36.0)
        
        arrowNode.style.preferredSize = CGSize(width: 12, height: 24)
        
        nameNode.style.flexGrow = 1.0
        nameNode.style.spacingBefore = 10
        
        arrowNode.style.spacingAfter = 15
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.children = [avatarNode, nameNode, descNode, arrowNode]
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 46)
        return stack
    }
    
}
