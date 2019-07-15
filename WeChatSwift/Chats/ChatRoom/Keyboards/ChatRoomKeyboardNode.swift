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
    
    private let toolBar = ChatRoomToolBarNode()
    
    private let emotionPanel = ChatRoomEmotionPanelNode(expressions: Expression.all)
    
    private let toolsPanel = ChatRoomToolPanelNode(tools: ChatRoomTool.allCases)
    
    private let barHeight: CGFloat
    
    private let panelHeight: CGFloat
    
    private let bottomInset: CGFloat
    
    private var height: CGFloat {
        return 0.0
    }
    
    init(barHeight: CGFloat = 60.0, panelHeight: CGFloat = 236.0) {
        self.barHeight = barHeight
        self.panelHeight = panelHeight
        self.bottomInset = Constants.bottomInset
        
        toolBar.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: barHeight)
        
        emotionPanel.frame = CGRect(x: 0, y: Constants.screenHeight, width: Constants.screenWidth, height: panelHeight)
        toolsPanel.frame = CGRect(x: 0, y: Constants.screenHeight, width: Constants.screenWidth, height: panelHeight)
        
        super.init()
        
        addSubnode(toolBar)
        addSubnode(emotionPanel)
        addSubnode(toolsPanel)
        
        toolBar.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func didLoad() {
        super.didLoad()
        
        let offsetY = Constants.screenHeight - Constants.topInset - Constants.bottomInset - 44.0 - barHeight
        let height = barHeight + bottomInset + panelHeight
        self.frame = CGRect(x: 0, y: offsetY, width: Constants.screenWidth, height: height)
        
        backgroundColor = UIColor(hexString: "#F5F6F7")
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        switch toolBar.keyboard {
        case .emotion:
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
                self.toolsPanel.isHidden = true
                self.emotionPanel.isHidden = false
                self.lastKeyboardOffsetY = self.frame.origin.y
                self.frame.origin.y = Constants.screenHeight - self.bounds.height - Constants.topInset - 44
                self.emotionPanel.frame.origin.y = self.barHeight
                self.toolsPanel.frame.origin.y = self.bounds.height
            }, completion: nil)
        case .tools:
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
                self.toolsPanel.isHidden = false
                self.emotionPanel.isHidden = true
                self.lastKeyboardOffsetY = self.frame.origin.y
                self.frame.origin.y = Constants.screenHeight - self.bounds.height - Constants.topInset - 44
                self.emotionPanel.frame.origin.y = self.bounds.height
                self.toolsPanel.frame.origin.y = self.barHeight
            }, completion: nil)
        case .none:
            guard let beginFrame = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
                let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
                    return
            }
            let superNodeHeight = supernode?.bounds.height ?? Constants.screenHeight
            let targetY = endFrame.origin.y - toolBar.bounds.height - (Constants.screenHeight - superNodeHeight)
            UIView.animate(withDuration: 0.25) {
                if beginFrame.size.height >= 0 && beginFrame.origin.y - endFrame.origin.y > 0 {
                    self.lastKeyboardOffsetY = self.frame.origin.y
                    self.frame.origin = CGPoint(x: 0, y: targetY)
                } else if endFrame.origin.y == Constants.screenHeight && beginFrame.origin.y != endFrame.origin.y && duration > 0 {
                    
                }
            }
            
        default:
            break
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        toolBar.style.preferredSize = CGSize(width: Constants.screenWidth, height: barHeight)
        
        let additionLayout = ASOverlayLayoutSpec(child: toolsPanel, overlay: emotionPanel)
        additionLayout.style.preferredSize = CGSize(width: Constants.screenWidth, height: panelHeight)
        
        let spacer = ASLayoutSpec()
        spacer.style.preferredSize = CGSize(width: Constants.screenWidth, height: bottomInset)
        
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [toolBar, spacer, additionLayout]
    
        return ASInsetLayoutSpec(insets: .zero, child: stack)
    }
}

extension ChatRoomKeyboardNode: ChatRoomToolBarNodeDelegate {
    
    func toolBar(_ toolBar: ChatRoomToolBarNode, didSendText text: String) {
        
    }
    
    func toolBar(_ toolBar: ChatRoomToolBarNode, keyboardTypeChanged keyboard: ChatRoomKeyboardType) {
        switch keyboard {
        case .emotion:
            toolsPanel.isHidden = true
            emotionPanel.isHidden = false
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
                self.lastKeyboardOffsetY = self.frame.origin.y
                self.frame.origin.y = self.supernode!.bounds.height - self.bounds.height
                self.emotionPanel.frame.origin.y = self.barHeight
                self.toolsPanel.frame.origin.y = self.frame.height
            }, completion: nil)
        case .tools:
            toolsPanel.isHidden = false
            emotionPanel.isHidden = true
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
                self.lastKeyboardOffsetY = self.frame.origin.y
                self.frame.origin.y = self.supernode!.bounds.height - self.bounds.height
                self.emotionPanel.frame.origin.y = self.frame.height
                self.toolsPanel.frame.origin.y = self.barHeight
            }, completion: nil)
        default:
            break
        }
    }
    
}
