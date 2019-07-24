//
//  EmoticonContentNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import FLAnimatedImage

class EmoticonContentNode: MessageContentNode {
    
    private let imageNode = ASDisplayNode()
    
    private let emoticon: EmoticonMessage
    
    private lazy var animatedImageView: FLAnimatedImageView = {
        let animatedImage = FLAnimatedImageView()
        return animatedImage
    }()
    
    init(message: Message, emoticon: EmoticonMessage) {
        
        self.emoticon = emoticon
        super.init(message: message)
        
        addSubnode(imageNode)
        setViewBlock { [weak self] () -> UIView in
            return self?.animatedImageView ?? UIView()
        }
    }
    
    override func didLoad() {
        super.didLoad()
        
        animatedImageView.pin_setImage(from: emoticon.url)
//        if let url = emoticon.url, let data = try? Data(contentsOf: url) {
//            animatedImageView.animatedImage = FLAnimatedImage(animatedGIFData: data)
//        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        imageNode.style.preferredSize = CGSize(width: 120, height: 120)
        let insets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        let layout = ASInsetLayoutSpec(insets: insets, child: imageNode)
        return layout
    }
    
}

