//
//  ImageContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ImageContentNode: MessageContentNode {
    
    private let defaultImageSize = CGSize(width: 200, height: 200)
    
    private let imageNode: ASNetworkImageNode = ASNetworkImageNode()
    
    override init(message: Message) {
        
        super.init(message: message)
        
        imageNode.cornerRadius = 6.0
        imageNode.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        imageNode.cornerRoundingType = .clipping
        addSubnode(imageNode)
        
        switch message.content {
        case .image(let imageMsg):
            let size = imageMsg.size == .zero ? defaultImageSize: imageMsg.size
            imageNode.style.preferredSize = size
            
            if let image = imageMsg.image {
                imageNode.image = image
            } else {
                imageNode.url = imageMsg.url
            }
            
        default:
            break
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: imageNode)
    }
    
}
