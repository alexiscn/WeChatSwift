//
//  VideoContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class VideoContentNode: MessageContentNode {
    
    private let defaultVideoSize = CGSize(width: 200, height: 200)
    
    private let thumbImageNode = ASNetworkImageNode()
    
    private let iconImageNode = ASImageNode()
    
    private let videoInfoBackgroundNode = ASImageNode()
    
    private let videoLengthNode = ASTextNode()
    
    private let videoMsg: VideoMessage
    
    init(message: Message, videoMsg: VideoMessage) {
        self.videoMsg = videoMsg
        super.init(message: message)
        automaticallyManagesSubnodes = true
        
        thumbImageNode.url = videoMsg.url
        
        iconImageNode.image = UIImage.as_imageNamed("MessageVideoPlay_40x40_")
        
        videoInfoBackgroundNode.image = UIImage.as_imageNamed("Albumtimeline_video_shadow_4x28_")
        
        videoLengthNode.attributedText = videoMsg.attributedStringForVideoLength()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        iconImageNode.style.preferredSize = CGSize(width: 40.0, height: 40.0)
        
        let size = videoMsg.size == .zero ? defaultVideoSize: videoMsg.size
        let ratio = size.height / size.width
        let ratioLayoutSpec = ASRatioLayoutSpec(ratio: ratio, child: thumbImageNode)
        ratioLayoutSpec.style.maxSize = CGSize(width: Constants.screenWidth * 0.4, height: Constants.screenWidth * 0.4)
        
        let insets = UIEdgeInsets(top: 0, left: message.isOutgoing ? 0: 5, bottom: 0, right: message.isOutgoing ? 5: 0)
        let layout = ASInsetLayoutSpec(insets: insets, child: ratioLayoutSpec)
        return layout
    }
}
