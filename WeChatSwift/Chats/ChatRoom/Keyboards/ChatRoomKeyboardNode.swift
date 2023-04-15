//
//  ChatRoomKeyboardNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

protocol ChatRoomKeyboardNodeDelegate: class {
    func keyboard(_ keyboard: ChatRoomKeyboardNode, didSendText text: String)
    func keyboard(_ keyboard: ChatRoomKeyboardNode, didSelectToolItem tool: ChatRoomTool)
    func keyboard(_ keyboard: ChatRoomKeyboardNode, didSendSticker sticker: WCEmotion)
    func keyboardAddFavoriteEmoticonButtonPressed()
    func keyboard(_ keyboard: ChatRoomKeyboardNode, didSendGameEmoticon game: FavoriteEmoticon)
    func keyboardEmoticonAddButtonPressed()
    func keyboardEmoticonSettingsButtonPressed()
}

class ChatRoomKeyboardNode: ASDisplayNode {
    
    weak var delegate: ChatRoomKeyboardNodeDelegate?
    
    var isSwipeBackGestureCauseKeyboardDismiss = false
    
    weak var tableNode: ASTableNode?
    
    private let toolBar = ChatRoomToolBarNode()
    private let emoticonBoardNode: EmoticonBoardNode
    private let toolsPanel = ChatRoomToolPanelNode(tools: ChatRoomTool.allCases)
    private let bottomNode = ASDisplayNode()
    
    private var barHeight: CGFloat
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
        
        let emoticonMgr = AppContext.current.emoticonMgr
        emoticonBoardNode = EmoticonBoardNode(emoticons: emoticonMgr.emoticons)
        
        toolBar.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: barHeight)
        emoticonBoardNode.frame = CGRect(x: 0, y: Constants.screenHeight, width: Constants.screenWidth, height: panelHeight)
        toolsPanel.frame = CGRect(x: 0, y: Constants.screenHeight, width: Constants.screenWidth, height: panelHeight)
        
        bottomNode.backgroundColor = Colors.white
        
        super.init()
        
        addSubnode(toolBar)
        addSubnode(emoticonBoardNode)
        addSubnode(toolsPanel)
        
        toolBar.delegate = self
        toolsPanel.delegate = self
        emoticonBoardNode.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func didLoad() {
        super.didLoad()
        
        let offsetY = Constants.screenHeight - Constants.bottomInset - barHeight
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
                toolBar.resetButtonsSelection()
            }
        }
    }
    
    func clearText() {
        toolBar.clearText()
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
        default:
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

        //toolBar.style.preferredSize = CGSize(width: Constants.screenWidth, height: toolBar.bounds.height)
        let additionLayout = ASOverlayLayoutSpec(child: toolsPanel, overlay: emoticonBoardNode)
        additionLayout.style.preferredSize = CGSize(width: Constants.screenWidth, height: panelHeight)
        
        bottomNode.style.preferredSize = CGSize(width: Constants.screenWidth, height: bottomInset)
        
        let stack = ASStackLayoutSpec.vertical()
        switch keyboardType {
        case .none:
            bottomNode.backgroundColor = .clear
            stack.children = [toolBar, bottomNode, additionLayout]
        case .input:
            bottomNode.backgroundColor = .clear
            stack.children = [toolBar, bottomNode, additionLayout]
        case .emotion:
            bottomNode.backgroundColor = .white
            stack.children = [toolBar, additionLayout, bottomNode]
        case .tools:
            bottomNode.backgroundColor = .clear
            stack.children = [toolBar, additionLayout, bottomNode]
        case .voice:
            bottomNode.backgroundColor = .clear
            stack.children = [toolBar, bottomNode, additionLayout]
        }
        return ASInsetLayoutSpec(insets: .zero, child: stack)
    }
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        
        let containerHeight = Constants.screenHeight
        barHeight = toolBar.bounds.height
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveLinear, animations: {
            self.lastKeyboardOffsetY = self.frame.origin.y
            switch self.keyboardType {
            case .none:
                self.bottomNode.backgroundColor = .clear
                self.toolsPanel.isHidden = true
                self.emoticonBoardNode.isHidden = true
                self.emoticonBoardNode.frame.origin.y = self.bounds.height
                self.toolsPanel.frame.origin.y = self.bounds.height
                self.frame.origin.y = containerHeight - self.barHeight - self.bottomInset
            case .input:
                self.toolsPanel.isHidden = true
                self.emoticonBoardNode.isHidden = true
                self.emoticonBoardNode.frame.origin.y = self.bounds.height
                self.toolsPanel.frame.origin.y = self.bounds.height
                self.frame.origin.y = self.keyboardEndFrame.origin.y - self.barHeight - (Constants.screenHeight - containerHeight)
            case .emotion:
                self.bottomNode.backgroundColor = .white
                self.toolsPanel.isHidden = true
                self.emoticonBoardNode.isHidden = false
                self.frame.origin.y = containerHeight - self.bounds.height
                self.emoticonBoardNode.frame.origin.y = self.barHeight
                self.toolsPanel.frame.origin.y = self.bounds.height
            case .tools:
                self.bottomNode.backgroundColor = .clear
                self.toolsPanel.isHidden = false
                self.emoticonBoardNode.isHidden = true
                self.frame.origin.y = containerHeight - self.bounds.height
                self.emoticonBoardNode.frame.origin.y = self.bounds.height
                self.toolsPanel.frame.origin.y = self.barHeight
            case .voice:
                self.toolsPanel.isHidden = true
                self.emoticonBoardNode.isHidden = true
                self.emoticonBoardNode.frame.origin.y = self.bounds.height
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
    
    func toolBarFrameUpdated() {
        transitionLayout()
    }
}

// MARK: - ChatRoomToolPanelNodeDelegate
extension ChatRoomKeyboardNode: ChatRoomToolPanelNodeDelegate {
    func toolPanelDidPressedTool(_ tool: ChatRoomTool) {
        delegate?.keyboard(self, didSelectToolItem: tool)
    }
}

// MARK: - EmoticonBoardNodeDelegate
extension ChatRoomKeyboardNode: EmoticonBoardNodeDelegate {
    
    func emoticonBoardPressedSendButton() {
        if let text = toolBar.text {
            delegate?.keyboard(self, didSendText: text)
        }
    }
    
    func emoticonBoardPressedDeleteButton() {
        guard let text = toolBar.text, text.count > 0 else {
            return
        }
        if text.hasSuffix("]") {
            var startLocation: Int = -1
            for index in 0 ..< text.count {
                let offset = text.count - 1 - index
                let range = NSRange(location: offset, length: 1)
                let char = text.subStringInRange(range)
                if char == "[" {
                    startLocation = offset
                    break
                }
            }
            if startLocation >= 0 {
                toolBar.text = text.subStringInRange(NSRange(location: 0, length: startLocation))
            }
        } else {
            toolBar.text = text.subStringInRange(NSRange(location: 0, length: text.count - 1))
        }
    }
    
    func emoticonBoardPressedSettingButton() {
        delegate?.keyboardEmoticonSettingsButtonPressed()
    }
    
    func emoticonBoardPressedAddButton() {
        delegate?.keyboardEmoticonAddButtonPressed()
    }
    
    func emoticonBoardDidTapEmoticon(_ emoticon: Emoticon, viewModel: EmoticonViewModel) {
        switch viewModel.type {
        case .expression:
            if let expression = emoticon as? Expression {
                toolBar.appendText(expression.text)
                emoticonBoardNode.inputBarTextDidUpdated(text: toolBar.text)
            }
        case .sticker:
            if let sticker = emoticon as? WCEmotion {
                delegate?.keyboard(self, didSendSticker: sticker)
            }
        case .favorites:
            if let fav = emoticon as? FavoriteEmoticon {
                switch fav.type {
                case .add:
                    delegate?.keyboardAddFavoriteEmoticonButtonPressed()
                case .dice, .jsb:
                    delegate?.keyboard(self, didSendGameEmoticon: fav)
                }
            }
        default:
            break
        }
    }
}
