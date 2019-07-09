//
//  ChatRoomToolBar.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

enum ChatRoomKeyboardType {
    case none
    case voice
    case emotion
    case tools
}

final class ChatRoomToolBar: ASDisplayNode {
    
    var keyboard: ChatRoomKeyboardType = .none
    
    private lazy var voiceNode: ASButtonNode = {
        let button = ASButtonNode()
        button.setImage(UIImage.SVGImage(named: "icons_outlined_voice"), for: .normal)
        button.style.preferredSize = CGSize(width: 40, height: 40)
        button.imageNode.style.preferredSize = CGSize(width: 30, height: 30)
        return button
    }()
    
    private lazy var emotionNode: ASButtonNode = {
        let button = ASButtonNode()
        button.setImage(UIImage(named: "Add_emoticon_icon_nor_28x28_"), for: .normal)
        button.setImage(UIImage(named: "Add_emoticon_icon_pre_28x28_"), for: .highlighted)
        button.style.preferredSize = CGSize(width: 40, height: 40)
        button.imageNode.style.preferredSize = CGSize(width: 30, height: 30)
        return button
    }()
    
    private lazy var moreNode: ASButtonNode = {
        let button = ASButtonNode()
        button.setImage(UIImage.SVGImage(named: "icons_outlined_add2"), for: .normal)
        button.style.preferredSize = CGSize(width: 40, height: 40)
        button.imageNode.style.preferredSize = CGSize(width: 30, height: 30)
        return button
    }()
    
    private lazy var textNode: ASEditableTextNode = {
        let node = ASEditableTextNode()
        node.cornerRadius = 6.0
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        node.cornerRoundingType = .clipping
        node.returnKeyType = .send
        node.backgroundColor = Colors.white
        return node
    }()
    
    override init() {
        super.init()
        
        addSubnode(voiceNode)
        addSubnode(textNode)
        addSubnode(emotionNode)
        addSubnode(moreNode)
    }
    
    override func didLoad() {
        super.didLoad()
        
        //view.backgroundColor = .red
        
        voiceNode.addTarget(self, action: #selector(ChatRoomToolBar.voiceNodeClicked), forControlEvents: .touchUpInside)
        emotionNode.addTarget(self, action: #selector(ChatRoomToolBar.emotionNodeClicked), forControlEvents: .touchUpInside)
        moreNode.addTarget(self, action: #selector(ChatRoomToolBar.moreNodeClicked), forControlEvents: .touchUpInside)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        textNode.style.preferredSize = CGSize(width: 0, height: frame.height - 20)
        textNode.style.flexGrow = 1.0
        
        let layoutSpec = ASStackLayoutSpec.horizontal()
        layoutSpec.alignItems = .center
        layoutSpec.children = [voiceNode, textNode, emotionNode, moreNode]
        
        return layoutSpec
    }
}

extension ChatRoomToolBar {
    
    @objc private func voiceNodeClicked() {
        
    }
    
    @objc private func emotionNodeClicked() {
        
    }
    
    @objc private func moreNodeClicked() {
        
    }
}
