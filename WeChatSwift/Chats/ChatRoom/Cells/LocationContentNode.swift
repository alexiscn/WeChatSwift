//
//  LocationContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class LocationContentNode: MessageContentNode {
    
    private let bubbleNode = ASImageNode()
    
    private let loadingNode = ASImageNode()
    
    private let titleNode = ASTextNode()
    
    private let descNode = ASTextNode()
    
    private let hairlineNode = ASDisplayNode()
    
    private let thumbNode = ASImageNode()
    
    private let pinNode = ASImageNode()
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        return indicator
    }()
    
    init(message: Message, locationMsg: LocationMessage) {
        super.init(message: message)
        
        automaticallyManagesSubnodes = true
        
        let icon = message.isOutgoing ? "ChatRoom_Bubble_App_Sender_57x40_": "ChatRoom_Bubble_Text_Receiver_White_57x40_"
        bubbleNode.image = UIImage(named: icon)
        bubbleNode.style.flexShrink = 1
        
        titleNode.maximumNumberOfLines = 1
        descNode.maximumNumberOfLines = 1
        
        titleNode.attributedText = locationMsg.attributedStringForTitle()
        descNode.attributedText = locationMsg.attributedStringForDesc()
        thumbNode.image = locationMsg.thumbImage
        hairlineNode.backgroundColor = Colors.DEFAULT_BORDER_COLOR
        pinNode.image = UIImage.as_imageNamed("located_pin_18x38_")
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let width = Constants.screenWidth * 0.625
        
        titleNode.style.layoutPosition = CGPoint(x: 12, y: 10)
        titleNode.style.preferredSize = CGSize(width: width - 24, height: 20)
        
        descNode.style.layoutPosition = CGPoint(x: 12, y: 32)
        descNode.style.preferredSize = CGSize(width: width - 24, height: 15)
        
        hairlineNode.style.layoutPosition = CGPoint(x: 0, y: 52)
        hairlineNode.style.preferredSize = CGSize(width: width, height: Constants.lineHeight)
        
        let topLayout = ASAbsoluteLayoutSpec(children: [titleNode, descNode, hairlineNode])
        
//        pinNode.style.preferredSize = CGSize(width: 18, height: 38)
//        let pin = ASCenterLayoutSpec(centeringOptions: .XY, sizingOptions: .minimumXY, child: pinNode)
//        let bottom = ASBackgroundLayoutSpec(child: pin, background: thumbNode)
//        bottom.style.preferredSize = CGSize(width: 255, height: 95)
        
        let layout = ASStackLayoutSpec.vertical()
        layout.style.preferredSize = CGSize(width: width, height: 148)
        thumbNode.style.preferredSize = CGSize(width: width, height: 95)
        layout.children = [topLayout, thumbNode]
        
        let insets: UIEdgeInsets
        if message.isOutgoing {
            insets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        } else {
            insets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        }
        
        return ASBackgroundLayoutSpec(child: ASInsetLayoutSpec(insets: insets, child: layout), background: bubbleNode)
    }
}
