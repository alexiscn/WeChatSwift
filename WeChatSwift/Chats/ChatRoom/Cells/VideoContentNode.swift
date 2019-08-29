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
    
    var imageView: UIView? {
        return thumbImageNode.view
    }
    
    init(message: Message, videoMsg: VideoMessage) {
        self.videoMsg = videoMsg
        super.init(message: message)
        automaticallyManagesSubnodes = true
        
        thumbImageNode.url = videoMsg.url
        thumbImageNode.cornerRadius = 6.0
        thumbImageNode.cornerRoundingType = .precomposited
        
        iconImageNode.image = UIImage.as_imageNamed("Fav_List_Video_Play_40x40_")
        videoInfoBackgroundNode.image = UIImage.as_imageNamed("Albumtimeline_video_shadow_4x28_")
        videoInfoBackgroundNode.cornerRadius = 6.0
        videoInfoBackgroundNode.cornerRoundingType = .precomposited
        
        videoLengthNode.attributedText = videoMsg.attributedStringForVideoLength()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let size = videoMsg.size == .zero ? defaultVideoSize: videoMsg.size
        let ratio = size.height / size.width
        
        let maxWidth = Constants.screenWidth * 0.4
        var width: CGFloat
        var height: CGFloat
        if ratio > 1.0 {
            width = maxWidth / ratio
            height = maxWidth
        } else {
            width = maxWidth
            height = maxWidth / ratio
        }
        width = max(width, 60.0)
        height = max(height, 60.0)
        
        thumbImageNode.style.preferredSize = CGSize(width: width, height: height)
        thumbImageNode.style.layoutPosition = .zero
        
        iconImageNode.style.preferredSize = CGSize(width: 40.0, height: 40.0)
        iconImageNode.style.layoutPosition = CGPoint(x: (width - 40.0)/2.0, y: (height - 40.0)/2.0)
        
        videoInfoBackgroundNode.style.preferredSize = CGSize(width: width, height: 20.0)
        videoInfoBackgroundNode.style.layoutPosition = CGPoint(x: 0, y: height - 20.0)
        
        videoLengthNode.style.preferredSize = CGSize(width: width - 6.0, height: 13)
        videoLengthNode.style.layoutPosition = CGPoint(x: 0, y: height - 17.5)
        
        let layout = ASAbsoluteLayoutSpec(children: [thumbImageNode, iconImageNode, videoInfoBackgroundNode, videoLengthNode])
        
        let insets = UIEdgeInsets(top: 0, left: message.isOutgoing ? 0: 5, bottom: 0, right: message.isOutgoing ? 5: 0)
        return ASInsetLayoutSpec(insets: insets, child: layout)
    }
}
