//
//  ChatRoomAddContactCellNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/7.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

// TODO: Add More Member Entrance
class ChatRoomAddContactCellNode: ASCellNode {
    
    var addButtonHandler: RelayCommand?
    
    private var elements: [ChatRoomMemberItemNode] = []
    
    private let padding: CGFloat = 3.0
    private let maxNumberOfRows: Int = 4
    private let itemSize: CGSize = CGSize(width: 76, height: 88)
    
    init(members: [AddChatRoomMemberItem]) {
        super.init()
        automaticallyManagesSubnodes = true
        for member in members {
            let itemNode = ChatRoomMemberItemNode(item: member)
            itemNode.style.preferredSize = itemSize
            elements.append(itemNode)
        }
    }
    
    override func didLoad() {
        super.didLoad()
        
        backgroundColor = Colors.white
        elements.forEach { $0.addButtonHandler = addButtonHandler }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let numberOfItemsInRow = Int((Constants.screenWidth - 2 * padding)/itemSize.width)
        for (index, element) in elements.enumerated() {
            let row = CGFloat(index / numberOfItemsInRow)
            let col = CGFloat(index % numberOfItemsInRow)
            let x = padding + col * itemSize.width
            let y = row * itemSize.height
            element.style.layoutPosition = CGPoint(x: x, y: y)
        }
        
        var layouts: [ASLayoutElement] = []
        layouts.append(contentsOf: elements)
        
        let maxY = (elements.last?.style.layoutPosition.y ?? 0) + itemSize.height
        
        let bottomSpacer = ASLayoutSpec()
        bottomSpacer.style.preferredSize = CGSize(width: constrainedSize.max.width, height: 16)
        bottomSpacer.style.layoutPosition = CGPoint(x: 0, y: maxY)
        layouts.append(bottomSpacer)
        
        return ASAbsoluteLayoutSpec(children: layouts)
    }
    
}
