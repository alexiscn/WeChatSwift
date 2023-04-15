//
//  ChatRoomMemberItemNode.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/7.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ChatRoomMemberItemNode: ASDisplayNode {
    
    var addButtonHandler: RelayCommand?
    
    var contactTapHandlder: ((Contact) -> Void)?
    
    private let avatarNode = ASNetworkImageNode()
    
    private let nameNode = ASTextNode()
    
    private let addButtonNode = ASButtonNode()
    
    private let memberItem: AddChatRoomMemberItem
    
    init(item: AddChatRoomMemberItem) {
        
        self.memberItem = item
        
        super.init()
        
        automaticallyManagesSubnodes = true
        
        switch item {
        case .addButton:
            addButtonNode.setImage(UIImage(named: "AddGroupMemberBtn_50x50_"), for: .normal)
            addButtonNode.setImage(UIImage(named: "AddGroupMemberBtnHL_50x50_"), for: .highlighted)
        case .contact(let contact):
            avatarNode.url = contact.avatarURL
            avatarNode.cornerRoundingType = .precomposited
            avatarNode.cornerRadius = 4
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            nameNode.attributedText = NSAttributedString(string: contact.name, attributes: [
                .font: UIFont.systemFont(ofSize: 12),
                .foregroundColor: UIColor(hexString: "#454545"),
                .paragraphStyle: paragraphStyle
                ])
        }
    }
    
    override func didLoad() {
        super.didLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        self.view.addGestureRecognizer(tap)
        
        addButtonNode.addTarget(self, action: #selector(addButtonClicked), forControlEvents: .touchUpInside)
    }
    
    @objc private func handleTapGesture(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self.view)
        if avatarNode.frame.contains(point) {
            switch memberItem {
            case .contact(let contact):
                contactTapHandlder?(contact)
            default:
                break
            }
        }
    }
    
    @objc private func addButtonClicked() {
        addButtonHandler?()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        switch memberItem {
        case .addButton:
            addButtonNode.style.preferredSize = CGSize(width: 50, height: 50)
            addButtonNode.style.layoutPosition = CGPoint(x: constrainedSize.max.width - 50, y: (constrainedSize.max.height - 50)/2)
            
            return ASAbsoluteLayoutSpec(children: [addButtonNode])
        case .contact(_):
            avatarNode.style.preferredSize = CGSize(width: 50, height: 50)
            avatarNode.style.layoutPosition = CGPoint(x: constrainedSize.max.width - 50, y: (constrainedSize.max.height - 50)/2)
            
            nameNode.style.preferredSize = CGSize(width: 50, height: 14)
            nameNode.style.layoutPosition = CGPoint(x: constrainedSize.max.width - 50, y: constrainedSize.max.height - 15)
            
            return ASAbsoluteLayoutSpec(children: [avatarNode, nameNode])
        }
    }
    
}
