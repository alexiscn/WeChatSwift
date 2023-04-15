//
//  ChatRoomToolBarNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

enum ChatRoomKeyboardType {
    case none
    case input
    case voice
    case emotion
    case tools
}

protocol ChatRoomToolBarNodeDelegate {
    func toolBar(_ toolBar: ChatRoomToolBarNode, didSendText text: String)
    func toolBar(_ toolBar: ChatRoomToolBarNode, keyboardTypeChanged keyboard: ChatRoomKeyboardType)
    func toolBarFrameUpdated()
}

final class ChatRoomToolBarNode: ASDisplayNode {
    
    var keyboard: ChatRoomKeyboardType = .none
    
    var delegate: ChatRoomToolBarNodeDelegate?
    
    fileprivate struct Images {
        private init() {}
        static let Voice = UIImage.SVGImage(named: "icons_outlined_voice")
        static let Keyboard = UIImage.SVGImage(named: "icons_outlined_keyboard")
        static let Sticker = UIImage.SVGImage(named: "icons_outlined_sticker")
        static let More = UIImage.SVGImage(named: "icons_outlined_add2")
    }
    
    private lazy var voiceNode: ASButtonNode = {
        let button = ASButtonNode()
        button.setImage(Images.Voice, for: .normal)
        button.setImage(Images.Keyboard, for: .selected)
        button.style.preferredSize = CGSize(width: 40, height: 40)
        button.imageNode.style.preferredSize = CGSize(width: 32, height: 32)
        return button
    }()
    
    private lazy var emotionNode: ASButtonNode = {
        let button = ASButtonNode()
        button.setImage(Images.Sticker, for: .normal)
        button.setImage(Images.Keyboard, for: .selected)
        button.style.preferredSize = CGSize(width: 40, height: 40)
        button.imageNode.style.preferredSize = CGSize(width: 32, height: 32)
        return button
    }()
    
    private lazy var moreNode: ASButtonNode = {
        let button = ASButtonNode()
        button.setImage(Images.More, for: .normal)
        button.style.preferredSize = CGSize(width: 40, height: 40)
        button.imageNode.style.preferredSize = CGSize(width: 32, height: 32)
        return button
    }()
    
    private lazy var textNode: ASEditableTextNode = {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        paragraphStyle.paragraphSpacing = 1
        paragraphStyle.lineHeightMultiple = 1
        paragraphStyle.minimumLineHeight = 20
        paragraphStyle.maximumLineHeight = 20
        
        let node = ASEditableTextNode()
        node.returnKeyType = .send
        node.backgroundColor = Colors.white
        node.typingAttributes =
            [
                NSAttributedString.Key.font.rawValue: UIFont.systemFont(ofSize: 17),
                NSAttributedString.Key.foregroundColor.rawValue: Colors.DEFAULT_TEXT_COLOR,
                NSAttributedString.Key.paragraphStyle.rawValue: paragraphStyle
            ]
        node.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        return node
    }()
    
    private lazy var voiceButtonNode: ASButtonNode = {
        let normalText = NSAttributedString(string: "按住 说话", attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            .foregroundColor: UIColor(hexString: "#565656")
            ])
        
        let highlightText = NSAttributedString(string: "松开 结束", attributes: [
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            .foregroundColor: UIColor(hexString: "#565656")
            ])
        
        let normalBackground = UIImage.as_resizableRoundedImage(withCornerRadius: 4, cornerColor: nil, fill: .white)
        let highlightBackground = UIImage.as_resizableRoundedImage(withCornerRadius: 4, cornerColor: nil, fill: Colors.DEFAULT_BACKGROUND_COLOR)
        
        let button = ASButtonNode()
        button.setAttributedTitle(normalText, for: .normal)
        button.setAttributedTitle(highlightText, for: .highlighted)
        button.setBackgroundImage(normalBackground, for: .normal)
        button.setBackgroundImage(highlightBackground, for: .highlighted)
        //button.isUserInteractionEnabled = true
        return button
    }()
    
    var text: String? {
        get {
            return textNode.attributedText?.string
        }
        set {
            let attributedText = NSMutableAttributedString()
            attributedText.append(NSAttributedString(string: newValue ?? "", attributes: [
                .font: UIFont.systemFont(ofSize: 15),
                .foregroundColor: Colors.DEFAULT_TEXT_COLOR
                ]))
            textNode.attributedText = attributedText
        }
    }
    
    override init() {
        super.init()
        
        automaticallyManagesSubnodes = true
        textNode.delegate = self
    }
    
    override func didLoad() {
        super.didLoad()
        
        textNode.layer.cornerRadius = 6
        textNode.layer.masksToBounds = true
        textNode.maximumLinesToDisplay = 4
        textNode.style.minHeight = ASDimensionMake(40)
    
        let buttonNodes = [voiceNode, emotionNode, moreNode]
        buttonNodes.forEach { $0.addTarget(self, action: #selector(tapToolBarButtonNode(_:)), forControlEvents: .touchUpInside) }
        buttonNodes.forEach { node in
            node.addTarget(self, action: #selector(tapToolBarButtonNode(_:)), forControlEvents: .touchUpInside)
            node.style.preferredSize = CGSize(width: 40.0, height: 40.0)
            node.imageNode.style.preferredSize = CGSize(width: 32, height: 32)
        }
    }
    
    func clearText() {
        textNode.attributedText = nil
    }
    
    func appendText(_ text: String) {
        let attributedText = NSMutableAttributedString(attributedString: textNode.attributedText ?? NSAttributedString())
        attributedText.append(NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: Colors.DEFAULT_TEXT_COLOR
        ]))
        textNode.attributedText = attributedText
    }
    
    func resetButtonsSelection() {
        voiceNode.isSelected = false
        emotionNode.isSelected = false
        moreNode.isSelected = false
    }
    
    override func isFirstResponder() -> Bool {
        return textNode.isFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        resetButtonsSelection()
        return textNode.resignFirstResponder()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        voiceNode.style.spacingBefore = 3
        voiceNode.style.spacingAfter = 3
        emotionNode.style.spacingBefore = 3
        moreNode.style.spacingBefore = -6
        moreNode.style.spacingAfter = 3
            
        textNode.style.flexGrow = 1.0
        textNode.style.flexShrink = 1.0
        
//        voiceButtonNode.style.flexGrow = 1.0
//        voiceButtonNode.style.flexShrink = 1.0
//        voiceButtonNode.style.minHeight = ASDimensionMake(40)
//        voiceButtonNode.style.maxHeight = ASDimensionMake(40)
        
        //let element = (keyboard == .voice && voiceNode.isSelected) ? voiceButtonNode: textNode
        
        let layoutSpec = ASStackLayoutSpec.horizontal()
        layoutSpec.style.flexGrow = 1.0
        layoutSpec.alignItems = .end
        layoutSpec.children = [voiceNode, textNode, emotionNode, moreNode]
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0), child: layoutSpec)
    }
}

// MARK: - ASEditableTextNodeDelegate
extension ChatRoomToolBarNode: ASEditableTextNodeDelegate {
    func editableTextNodeShouldBeginEditing(_ editableTextNode: ASEditableTextNode) -> Bool {
        keyboard = .none
        voiceNode.isSelected = false
        emotionNode.isSelected = false
        moreNode.isSelected = false
        return true
    }
    
    func editableTextNode(_ editableTextNode: ASEditableTextNode, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            delegate?.toolBar(self, didSendText: textNode.textView.text)
            return false
        }
        return true
    }
    
    func editableTextNodeDidUpdateText(_ editableTextNode: ASEditableTextNode) {
//        let frame = editableTextNode.frame(forTextRange: NSRange(location: 0, length: editableTextNode.textView.text.count))
//        print(frame)
        
        guard let lineHeight = editableTextNode.textView.font?.lineHeight else {
            return
        }
        
        let maxHeight = ceil(lineHeight * CGFloat(4)
            + editableTextNode.textView.textContainerInset.top
            + editableTextNode.textView.textContainerInset.bottom)
        let sizeToFit = CGSize(width: editableTextNode.textView.bounds.width,
                               height: UIView.layoutFittingExpandedSize.height)
        let contentHeight = ceil(editableTextNode.textView.sizeThatFits(sizeToFit).height)
        editableTextNode.textView.isScrollEnabled = contentHeight > maxHeight
        let newHeight = min(contentHeight, maxHeight)
        let diff = abs(newHeight - editableTextNode.textView.frame.height)
        if diff > 0.1 {
            editableTextNode.textView.frame.size.height = newHeight
            textNode.style.preferredSize.height = newHeight
            setNeedsLayout()
            layoutIfNeeded()
            DispatchQueue.main.async {
                self.delegate?.toolBarFrameUpdated()
            }
        }
    }
}

// MARK: - Event Handers
extension ChatRoomToolBarNode {
    
    @objc private func tapToolBarButtonNode(_ sender: ASButtonNode) {
        let nodes = [voiceNode, emotionNode, moreNode]
        nodes.forEach { if sender != $0 { $0.isSelected = false } }
        sender.isSelected = !sender.isSelected
        
        let keyboards: [ChatRoomKeyboardType] = [.voice, .emotion, .tools]
        guard let index = nodes.firstIndex(of: sender) else {
            return
        }
        keyboard = keyboards[index]
        //self.setNeedsLayout()
        
        if sender.isSelected {
            if !textNode.isFirstResponder() {
                delegate?.toolBar(self, keyboardTypeChanged: keyboard)
            }
            textNode.resignFirstResponder()
        } else {
            textNode.becomeFirstResponder()
        }
    }
}
