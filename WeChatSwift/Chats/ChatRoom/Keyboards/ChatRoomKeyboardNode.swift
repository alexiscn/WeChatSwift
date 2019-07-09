//
//  ChatRoomKeyboardNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ChatRoomKeyboardNode: ASDisplayNode {
    
    private var lastKeyboardOffsetY: CGFloat = 0.0
    
    private let toolBar = ChatRoomToolBar()
    
    private let emotionPanel = ChatRoomEmotionPanelNode()
    
    private let toolsPanel = ChatRoomToolPanelNode(tools: ChatRoomTool.allCases)
    
    override init() {
        super.init()
        
        addSubnode(toolBar)
        addSubnode(emotionPanel)
        addSubnode(toolsPanel)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        switch toolBar.keyboard {
        case .emotion:
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
                self.toolsPanel.isHidden = true
                self.emotionPanel.isHidden = false
                self.lastKeyboardOffsetY = self.frame.origin.y
                
                self.frame = CGRect(x: 0, y: self.supernode!.frame.height - self.bounds.height, width: Constants.screenWidth, height: self.bounds.height)
                
            }, completion: nil)
        case .tools:
            print("....")
        default:
            break
        }
    }
}
