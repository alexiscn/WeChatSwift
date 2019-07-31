//
//  EmoticonStoreCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/31.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonStoreCellNode: ASCellNode {
    
    private let backgroundNode = ASDisplayNode()
    
    private let imageNode = ASNetworkImageNode()
    
    private let nameNode = ASTextNode()
    
    init(item: StoreEmoticonItem) {
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        imageNode.image = item.image
    
        backgroundNode.cornerRadius = 13
        backgroundNode.borderWidth = 0.5
        backgroundNode.borderColor = UIColor(hexString: "#CCCCCC").cgColor
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let nameAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
            NSAttributedString.Key.foregroundColor: UIColor(hexString: "#333333"),
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        nameNode.attributedText = NSAttributedString(string: "静态函数", attributes: nameAttributes)
    }
    
    override func didLoad() {
        super.didLoad()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let padding = constrainedSize.max.width * 0.1
        let insets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        imageNode.style.preferredSize = CGSize(width: constrainedSize.max.width * 0.8, height: constrainedSize.max.width * 0.8)
        
        let imageLayoutSpec = ASInsetLayoutSpec(insets: insets, child: imageNode)
        
        let topLayoutSpec = ASBackgroundLayoutSpec(child: imageLayoutSpec, background: backgroundNode)
        topLayoutSpec.style.preferredSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.height - 30)
        topLayoutSpec.style.flexGrow = 1.0
        
        let bottomLayoutSpec = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: nameNode)
        bottomLayoutSpec.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 30)
        
        let layout = ASStackLayoutSpec.vertical()
        layout.alignItems = .center
        layout.children = [topLayoutSpec, bottomLayoutSpec]
        
        return layout
    }
    
}
