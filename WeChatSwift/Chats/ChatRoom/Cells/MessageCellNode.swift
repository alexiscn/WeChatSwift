//
//  MessageCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

/*
| -------------------topTextNode--------------------- |
| avatarNode? |   contentTopTextNode?   | avatarNode? |
|             |      contentNode        |             |
|             |                         |             |
| -----------------bottomTextNode---------------------|
*/

/// Base Message Cell Node
public class MessageCellNode: ASCellNode {
    
    weak var delegate: MessageCellNodeDelegate?
    
    let isOutgoing: Bool
    
    private var timeNode: MessageTimeNode?
    
    private var contentTopTextNode: ASTextNode?
    
    let contentNode: MessageContentNode
    
    private var bottomTextNode: ASTextNode?
    
    private var avatarNode: ASNetworkImageNode = ASNetworkImageNode()
    
    private var statusNode: ASImageNode?
    
    private let message: Message
    
    public init(message: Message, contentNode: MessageContentNode) {
        
        self.message = message
        self.isOutgoing = message.isOutgoing
        
        if let formattedTime = message._formattedTime {
            let hideBackground = AppContext.current.userSettings.globalBackgroundImage == nil
            timeNode = MessageTimeNode(timeString: formattedTime, hideBackground: hideBackground)
        }
        self.contentNode = contentNode
        
        avatarNode.style.preferredSize = CGSize(width: 40, height: 40)
        
        super.init()
        
        if let node = timeNode { addSubnode(node) }
        addSubnode(avatarNode)
        addSubnode(contentNode)
        if let node = contentTopTextNode { addSubnode(node) }
        if let node = bottomTextNode { addSubnode(node) }
        
        selectionStyle = .none
        let user = MockFactory.shared.users.first(where: { $0.identifier == message.senderID })
        let avatar = user?.avatar ?? "DefaultHead_48x48_"
        avatarNode.image = UIImage.as_imageNamed(avatar)
        avatarNode.cornerRadius = 6.0
        avatarNode.cornerRoundingType = .precomposited
        
        if let textContentCell = contentNode as? TextContentNode {
            textContentCell.delegate = self
        }
    }
    
    public override func didLoad() {
        super.didLoad()
        
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        self.view.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self.view)
        if avatarNode.frame.contains(point) {
            delegate?.messageCell(self, didTapAvatar: message.senderID)
        } else if contentNode.frame.contains(point) {
            delegate?.messageCell(self, didTapContent: message.content)
        }
    }
    
    @objc private func handleLongPressGesture(_ gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: self.view)
        if avatarNode.frame.contains(point) {
            delegate?.messageCell(self, didLongPressedAvatar: message.senderID)
        } else if contentNode.frame.contains(point) {
            if gesture.state == .began {
                let menus = contentNode.supportedMenus
                delegate?.messageCell(self,
                                      showMenus: menus,
                                      message: message,
                                      targetRect: contentNode.frame,
                                      targetView: self.view)
            }
        }
    }
    
    public override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let contentVerticalStack = ASStackLayoutSpec.vertical()
        contentVerticalStack.style.flexShrink = 1.0
        contentVerticalStack.style.flexGrow = 1.0
        contentVerticalStack.style.spacingAfter = 5.0
        contentVerticalStack.style.spacingBefore = 5.0
        if let contentTopTextNode = contentTopTextNode {
            contentVerticalStack.children = [contentTopTextNode, contentNode]
        } else {
            contentVerticalStack.children = [contentNode]
        }
        
        let contentHorizontalStack = ASStackLayoutSpec.horizontal()
        contentHorizontalStack.justifyContent = .start
        let fakeAvatarNode = ASDisplayNode()
        fakeAvatarNode.style.preferredSize = CGSize(width: 40, height: 40)
        if isOutgoing {
            contentHorizontalStack.children = [fakeAvatarNode, contentVerticalStack, avatarNode]
        } else {
            contentHorizontalStack.children = [avatarNode, contentVerticalStack, fakeAvatarNode]
        }
        let contentHorizontalSpec = ASInsetLayoutSpec(insets: .zero, child: contentHorizontalStack)
        
        let layoutSpec = ASStackLayoutSpec.vertical()
        layoutSpec.justifyContent = .start
        layoutSpec.alignItems = isOutgoing ? .end: .start
        var layoutElements: [ASLayoutElement] = []
        if let topTextNode = timeNode {
            topTextNode.style.preferredSize = CGSize(width: Constants.screenWidth, height: 44)
            layoutElements.append(topTextNode)
        }
        layoutElements.append(contentHorizontalSpec)
        if let bottomTextNode = bottomTextNode {
            layoutElements.append(bottomTextNode)
        }
        layoutSpec.children = layoutElements
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 12, bottom: 5, right: 12), child: layoutSpec)
        
    }
}

// MARK: - TextContentNodeDelegate
extension MessageCellNode: TextContentNodeDelegate {
    func textContentNode(_ textNode: TextContentNode, tappedLinkAttribute attribute: String!, value: Any!, at point: CGPoint, textRange: NSRange) {
        if let url = value as? URL {
            delegate?.messageCell(self, didTapLink: url)
        }
    }
}

protocol MessageCellNodeDelegate: class {
    func messageCell(_ cellNode: MessageCellNode, didTapAvatar userID: String)
    func messageCell(_ cellNode: MessageCellNode, didLongPressedAvatar userID: String)
    func messageCell(_ cellNode: MessageCellNode, didTapContent content: MessageContent)
    func messageCell(_ cellNode: MessageCellNode, didTapLink url: URL?)
    func messageCell(_ cellNode: MessageCellNode, showMenus menus: [MessageMenuAction], message: Message, targetRect: CGRect, targetView: UIView)
}

enum MessageMenuAction: Int {
    case copy
    case forward
    case delete
    case addFavorite
    case removeFavorite
    case multiSelect
    case remind
    case translate
    case recall
    case addToSticker
    case followShoot
    case viewStickerAlbum
    case edit
    
    var title: String {
        switch self {
        case .copy:
            return "复制"
        case .forward:
            return "转发"
        case .delete:
            return "删除"
        case .addFavorite:
            return "收藏"
        case .removeFavorite:
            return "取消收藏"
        case .multiSelect:
            return "多选"
        case .remind:
            return "提醒"
        case .translate:
            return "翻译"
        case .recall:
            return "撤回"
        case .addToSticker:
            return "添加到表情"
        case .followShoot:
            return "跟拍"
        case .viewStickerAlbum:
            return "查看专辑"
        case .edit:
            return "编辑"
        }
    }
}
