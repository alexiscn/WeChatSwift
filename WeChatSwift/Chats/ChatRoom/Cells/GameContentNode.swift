//
//  GameContentNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/24.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit
import PINRemoteImage

class GameContentNode: MessageContentNode {
    
    private var imageNode = ASDisplayNode()
    
    private let game: GameMessage
    
    private lazy var animatedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame.size = CGSize(width: 50.0, height: 50.0)
        return imageView
    }()
    
    init(message: Message, gameMsg: GameMessage) {
        self.game = gameMsg
        super.init(message: message)
        imageNode.setViewBlock { [weak self] () -> UIView in
            return self?.animatedImageView ?? UIView()
        }
        addSubnode(imageNode)
    }
    
    override func didLoad() {
        super.didLoad()
 
        if let value = game.value {
            animatedImageView.image = game.gameType.imageFor(value: value)
        } else {
            animatedImageView.animationImages = game.gameType.animationImages
            animatedImageView.animationDuration = game.gameType.animationDuration
            animatedImageView.animationRepeatCount = 0
            animatedImageView.startAnimating()
            
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        imageNode.style.preferredSize = CGSize(width: 50, height: 50)
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6), child: imageNode)
    }
}
