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
    
    var isSwipeBackGestureCauseKeyboardDismiss = false
    
    weak var tableNode: ASTableNode?
    
    private let toolBar = ChatRoomToolBarNode()
    private let emotionPanel = ChatRoomEmotionPanelNode(expressions: Expression.all)
    private let toolsPanel = ChatRoomToolPanelNode(tools: ChatRoomTool.allCases)
    
    private let barHeight: CGFloat
    private let panelHeight: CGFloat
    private let bottomInset: CGFloat
    
    private var lastKeyboardOffsetY: CGFloat = 0.0
    private var keyboardType: ChatRoomKeyboardType = .none {
        didSet {
            transitionLayout()
        }
    }
    private var keyboardEndFrame: CGRect = .zero
    private var keyboardBeginFrame: CGRect = .zero
    
    init(barHeight: CGFloat = 56.0, panelHeight: CGFloat = 240.0) {
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
        
        let offsetY = Constants.screenHeight - Constants.statusBarHeight - Constants.bottomInset - 44.0 - barHeight
        let height = barHeight + bottomInset + panelHeight
        self.frame = CGRect(x: 0, y: offsetY, width: Constants.screenWidth, height: height)
        
        backgroundColor = UIColor(hexString: "#F5F6F7")
    }
    
    func dismissKeyboard() {
        if toolBar.isFirstResponder() {
            let _ = toolBar.resignFirstResponder()
        } else {
            let superNodeHeight = supernode?.bounds.height ?? Constants.screenHeight
            if superNodeHeight - frame.origin.y > (barHeight + self.bottomInset) {
                self.keyboardType = .none
            }
        }
    }
    
    private func transitionLayout() {
        self.transitionLayout(withAnimation: true, shouldMeasureAsync: false, measurementCompletion: nil)
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        switch toolBar.keyboard {
        case .emotion:
            self.keyboardType = .emotion
        case .tools:
            self.keyboardType = .tools
        case .none:
            guard let beginFrame = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect,
                let endFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
                let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
                    return
            }
            self.keyboardEndFrame = endFrame
            self.keyboardBeginFrame = beginFrame
            if beginFrame.size.height >= 0 && beginFrame.origin.y - endFrame.origin.y > 0 {
                self.keyboardType = .input
            } else if endFrame.origin.y == Constants.screenHeight && beginFrame.origin.y != endFrame.origin.y && duration > 0 {
                if !isSwipeBackGestureCauseKeyboardDismiss {
                    self.keyboardType = .none
                }
            } else if beginFrame.origin.y - endFrame.origin.y < 0 && duration == 0.0 {
                self.keyboardType = .none
            }
        default:
            break
        }
    }
    
    func updateTableNodeFrame() {
        guard let tableNode = tableNode else { return }
        let tableNodeOffsetY = tableNode.contentOffset.y
        let keyboardOffsetY = self.frame.origin.y - lastKeyboardOffsetY
        
        tableNode.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.frame.origin.y)
        let contentSizeDiff = tableNode.view.contentSize.height - tableNode.bounds.height
        var offset: CGFloat = 0.0
        if fabsf(Float(contentSizeDiff)) > fabsf(Float(keyboardOffsetY)) {
            offset = tableNodeOffsetY - keyboardOffsetY
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
        switch keyboardType {
        case .none:
            stack.children = [toolBar, spacer, additionLayout]
        case .input:
            stack.children = [toolBar, spacer, additionLayout]
        case .emotion:
            stack.children = [toolBar, additionLayout, spacer]
        case .tools:
            stack.children = [toolBar, additionLayout, spacer]
        case .voice:
            stack.children = [toolBar, spacer, additionLayout]
        }
        return ASInsetLayoutSpec(insets: .zero, child: stack)
    }
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        
        let containerHeight = Constants.screenHeight - Constants.statusBarHeight - 44
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
            self.lastKeyboardOffsetY = self.frame.origin.y
            switch self.keyboardType {
            case .none:
                self.toolsPanel.isHidden = true
                self.emotionPanel.isHidden = true
                self.emotionPanel.frame.origin.y = self.bounds.height
                self.toolsPanel.frame.origin.y = self.bounds.height
                self.frame.origin.y = containerHeight - self.barHeight - self.bottomInset
            case .input:
                self.toolsPanel.isHidden = true
                self.emotionPanel.isHidden = true
                self.emotionPanel.frame.origin.y = self.bounds.height
                self.toolsPanel.frame.origin.y = self.bounds.height
                self.frame.origin.y = self.keyboardEndFrame.origin.y - self.barHeight - (Constants.screenHeight - containerHeight)
            case .emotion:
                self.toolsPanel.isHidden = true
                self.emotionPanel.isHidden = false
                self.frame.origin.y = containerHeight - self.bounds.height
                self.emotionPanel.frame.origin.y = self.barHeight
                self.toolsPanel.frame.origin.y = self.bounds.height
            case .tools:
                self.toolsPanel.isHidden = false
                self.emotionPanel.isHidden = true
                self.frame.origin.y = containerHeight - self.bounds.height
                self.emotionPanel.frame.origin.y = self.bounds.height
                self.toolsPanel.frame.origin.y = self.barHeight
            case .voice:
                self.toolsPanel.isHidden = true
                self.emotionPanel.isHidden = true
                self.emotionPanel.frame.origin.y = self.bounds.height
                self.toolsPanel.frame.origin.y = self.bounds.height
                self.frame.origin.y = containerHeight - self.barHeight - self.bottomInset
            }
            self.updateTableNodeFrame()
            
        }) { completed in
            context.completeTransition(completed)
        }
        
    }
}

// MARK: - ChatRoomToolBarNodeDelegate
extension ChatRoomKeyboardNode: ChatRoomToolBarNodeDelegate {
    
    func toolBar(_ toolBar: ChatRoomToolBarNode, didSendText text: String) {
        delegate?.keyboard(self, didSendText: text)
    }
    
    func toolBar(_ toolBar: ChatRoomToolBarNode, keyboardTypeChanged keyboard: ChatRoomKeyboardType) {
        self.keyboardType = keyboard
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
