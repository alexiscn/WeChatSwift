//
//  ChatRoomKeyboardNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

protocol ChatRoomKeyboardNodeDelegate {
    func keyboard(_ keyboard: ChatRoomKeyboardNode, didSendText text: String)
}

class ChatRoomKeyboardNode: ASDisplayNode {
    
    var delegate: ChatRoomKeyboardNodeDelegate?
    
    weak var tableNode: ASTableNode?
    
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
        
        emotionPanel.delegate = self
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
    
    func dismissKeyboard() {
        if toolBar.isFirstResponder() {
            let _ = toolBar.resignFirstResponder()
        } else {
            let superNodeHeight = supernode?.bounds.height ?? Constants.screenHeight
            if superNodeHeight - frame.origin.y > barHeight {
                UIView.animate(withDuration: 0.25) {
                    self.lastKeyboardOffsetY = self.frame.origin.y
                    let y = superNodeHeight - self.barHeight - self.bottomInset
                    self.frame.origin.y = y
                    self.toolsPanel.frame.origin.y = self.bounds.height
                    self.emotionPanel.frame.origin.y = self.bounds.height
                    self.updateTableNodeFrame()
                }
            }
        }
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        switch toolBar.keyboard {
        case .emotion:
            self.toolsPanel.isHidden = true
            self.emotionPanel.isHidden = false
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
                self.lastKeyboardOffsetY = self.frame.origin.y
                self.frame.origin.y = Constants.screenHeight - self.bounds.height - Constants.topInset - 44
                self.emotionPanel.frame.origin.y = self.barHeight
                self.toolsPanel.frame.origin.y = self.bounds.height
                self.updateTableNodeFrame()
            }, completion: nil)
        case .tools:
            self.toolsPanel.isHidden = false
            self.emotionPanel.isHidden = true
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
                self.lastKeyboardOffsetY = self.frame.origin.y
                self.frame.origin.y = Constants.screenHeight - self.bounds.height - Constants.topInset - 44
                self.emotionPanel.frame.origin.y = self.bounds.height
                self.toolsPanel.frame.origin.y = self.barHeight
                self.updateTableNodeFrame()
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
                    self.frame.origin.y = targetY
                    self.emotionPanel.frame.origin.y = self.bounds.height
                    self.toolsPanel.frame.origin.y = self.bounds.height
                    print(self.bounds.height)
                    self.updateTableNodeFrame()
                } else if endFrame.origin.y == Constants.screenHeight && beginFrame.origin.y != endFrame.origin.y && duration > 0 {
                    self.lastKeyboardOffsetY = self.frame.origin.y
                    self.frame.origin.y = targetY - self.bottomInset
                    self.updateTableNodeFrame()
                } else if beginFrame.origin.y - endFrame.origin.y < 0 && duration == 0.0 {
                    self.lastKeyboardOffsetY = self.frame.origin.y
                    self.frame.origin.y = targetY - self.bottomInset
                    self.updateTableNodeFrame()
                }
            }
        default:
            break
        }
    }
    
    func updateTableNodeFrame() {
        guard let tableNode = tableNode else {
            return
        }
        let originOffsetY = tableNode.contentOffset.y
        let keyboardOffsetY = self.frame.origin.y - lastKeyboardOffsetY
        
        tableNode.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.frame.origin.y)
        let contentSizeDiff = tableNode.view.contentSize.height - tableNode.bounds.height
        var offset: CGFloat = 0.0
        if fabsf(Float(contentSizeDiff)) > fabsf(Float(keyboardOffsetY)) {
            offset = originOffsetY - keyboardOffsetY
        } else {
            offset = contentSizeDiff
        }
        if tableNode.view.contentSize.height + tableNode.contentInset.top + tableNode.contentInset.bottom > tableNode.frame.height {
            tableNode.contentOffset = CGPoint(x: 0, y: offset)
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

// MARK: - ChatRoomToolBarNodeDelegate
extension ChatRoomKeyboardNode: ChatRoomToolBarNodeDelegate {
    
    func toolBar(_ toolBar: ChatRoomToolBarNode, didSendText text: String) {
        delegate?.keyboard(self, didSendText: text)
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
                self.updateTableNodeFrame()
            }, completion: nil)
        case .tools:
            toolsPanel.isHidden = false
            emotionPanel.isHidden = true
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
                self.lastKeyboardOffsetY = self.frame.origin.y
                self.frame.origin.y = self.supernode!.bounds.height - self.bounds.height
                self.emotionPanel.frame.origin.y = self.frame.height
                self.toolsPanel.frame.origin.y = self.barHeight
                self.updateTableNodeFrame()
            }, completion: nil)
        default:
            break
        }
    }
    
}

// MARK: - ChatRoomEmotionPanelNodeDelegate

extension ChatRoomKeyboardNode: ChatRoomEmotionPanelNodeDelegate {
    
    func emotionPanelPressedDeleteButton() {
        
    }
    
    func emotionPanelSelectedExpression(_ expression: Expression) {
        toolBar.appendText(expression.text)
    }
}
