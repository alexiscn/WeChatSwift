//
//  WeChatEmoticonsCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/30.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class WeChatEmoticonsCellNode: ASCellNode {
    
    private let imageNode = ASNetworkImageNode()
    
    private let titleNode = ASTextNode()
    
    private let descNode = ASTextNode()
    
    private let actionButtonNode = ASButtonNode()
    
    private let lineNode = ASDisplayNode()
    
    init(string: String) {
        super.init()
        
        automaticallyManagesSubnodes = true
        
        let normalAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .semibold),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#1AAD19")
        ]
        actionButtonNode.setAttributedTitle(NSAttributedString(string: "添加", attributes: normalAttributes), for: .normal)
        
        let disableAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13, weight: .semibold),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#D9D9D9")
        ]
        actionButtonNode.setAttributedTitle(NSAttributedString(string: "已添加", attributes: disableAttributes), for: .disabled)
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        imageNode.style.preferredSize = CGSize(width: 60, height: 60)
        imageNode.style.spacingBefore = 12
        actionButtonNode.style.preferredSize = CGSize(width: 60, height: 26)
        
        let nameSpec = ASStackLayoutSpec.vertical()
        nameSpec.style.flexGrow = 1.0
        nameSpec.children = [titleNode, descNode]
        
        let stack = ASStackLayoutSpec.horizontal()
        stack.alignItems = .center
        stack.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 80)
        stack.children = [imageNode, nameSpec, actionButtonNode]
        
        let layout = ASStackLayoutSpec.vertical()
        layout.children = [stack, lineNode]
        
        return layout
    }
}
