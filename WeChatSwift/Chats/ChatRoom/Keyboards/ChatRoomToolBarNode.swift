//
//  ChatRoomToolBarNode.swift
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

protocol ChatRoomToolBarNodeDelegate {
    func toolBar(_ toolBar: ChatRoomToolBarNode, didSendText text: String)
}

final class ChatRoomToolBarNode: ASDisplayNode {
    
    var keyboard: ChatRoomKeyboardType = .none
    
    var delegate: ChatRoomToolBarNodeDelegate?
    
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
        
        textNode.delegate = self
    }
    
    override func didLoad() {
        super.didLoad()
        
        textNode.layer.cornerRadius = 6
        textNode.layer.masksToBounds = true
        
        voiceNode.addTarget(self, action: #selector(ChatRoomToolBarNode.voiceNodeClicked), forControlEvents: .touchUpInside)
        emotionNode.addTarget(self, action: #selector(ChatRoomToolBarNode.emotionNodeClicked), forControlEvents: .touchUpInside)
        moreNode.addTarget(self, action: #selector(ChatRoomToolBarNode.moreNodeClicked), forControlEvents: .touchUpInside)
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

// MARK: - ASEditableTextNodeDelegate
extension ChatRoomToolBarNode: ASEditableTextNodeDelegate {
    func editableTextNodeShouldBeginEditing(_ editableTextNode: ASEditableTextNode) -> Bool {
        keyboard = .none
        voiceNode.isSelected = false
        return true
    }
    
    func editableTextNode(_ editableTextNode: ASEditableTextNode, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            delegate?.toolBar(self, didSendText: textNode.textView.text)
            return false
        }
        return true
    }
}

// MARK: - Event Handers
extension ChatRoomToolBarNode {
    
    @objc private func voiceNodeClicked() {
        keyboard = .voice
    }
    
    @objc private func emotionNodeClicked() {
        keyboard = .emotion
    }
    
    @objc private func moreNodeClicked() {
        keyboard = .tools
    }
}
