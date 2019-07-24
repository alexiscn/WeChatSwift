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
        return FLAnimatedImageView()
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
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        imageNode.style.preferredSize = CGSize(width: 120, height: 120)
        
        let layout = ASInsetLayoutSpec(insets: .zero, child: imageNode)
        return layout
    }
    
}

