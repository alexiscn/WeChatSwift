//
//  ImageContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentImageContentNode: MomentContentNode {
    
    private let imageNode: ASNetworkImageNode = ASNetworkImageNode()
    
    private var ratio: CGFloat = 1.0
    
    private let image: MomentMedia
    
    init(image: MomentMedia) {
        self.image = image
        super.init()
        
        imageNode.url = image.url
        ratio = image.size.height / image.size.width
        
        imageNode.contentMode = .scaleToFill
        imageNode.clipsToBounds = true
        imageNode.shouldCacheImage = false
        addSubnode(imageNode)
    }
    
    override func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self.view)
        if let cellNode = cellNode, imageNode.frame.contains(point) {
            cellNode.delegate?.momentCellNode(cellNode, didTapImage: image, thumbImage: imageNode.image, tappedView: imageNode.view)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let width = constrainedSize.max.width * 0.75
        
        let ratiopSpec = ASRatioLayoutSpec(ratio: ratio, child: imageNode)
        ratiopSpec.style.maxSize = CGSize(width: width, height: width)
        
        let layout = ASStackLayoutSpec.horizontal()
        layout.style.flexGrow = 1.0
        layout.children = [ratiopSpec]
        return layout
    }
}
