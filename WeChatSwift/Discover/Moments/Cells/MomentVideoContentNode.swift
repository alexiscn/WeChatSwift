//
//  MomentVideoContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/31.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentVideoContentNode: MomentContentNode {
 
    private let videoNode = ASVideoNode()
    
    private let video: MomentVideo
    
    init(video: MomentVideo) {
        self.video = video
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let ratio = video.size.height/video.size.width
        let width = constrainedSize.max.width * 0.75
        let layout = ASRatioLayoutSpec(ratio: ratio, child: videoNode)
        layout.style.maxSize = CGSize(width: width, height: width)
        return layout
    }
}
