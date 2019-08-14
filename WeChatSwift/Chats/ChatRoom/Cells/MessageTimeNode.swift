//
//  MessageTimeNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/14.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MessageTimeNode: ASDisplayNode {
    
    private let textNode = ASTextNode()
    
    private let backgroundNode = ASImageNode()
    
    init(timeString: String, hideBackground: Bool) {
        super.init()
        automaticallyManagesSubnodes = true
        
        backgroundNode.image = UIImage.as_imageNamed("MessageContent_TimeNodeBkg_Light_30x18_")
        backgroundNode.isHidden = hideBackground
        
        let textColor = hideBackground ? UIColor(white: 0, alpha: 0.3): UIColor(white: 0, alpha: 0.9)
        
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor: textColor
        ]
        textNode.attributedText = NSAttributedString(string: timeString, attributes: attributes)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let insets = UIEdgeInsets(top: 1.5, left: 5, bottom: 1.5, right: 5)
        let textSpec = ASInsetLayoutSpec(insets: insets, child: textNode)
        
        let backgroundSpec = ASBackgroundLayoutSpec(child: textSpec, background: backgroundNode)
        return ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: backgroundSpec)
    }
}
