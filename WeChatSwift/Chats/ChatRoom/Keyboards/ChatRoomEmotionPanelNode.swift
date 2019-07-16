//
//  ChatRoomEmotionPanelNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

protocol ChatRoomEmotionPanelNodeDelegate {
    func emotionPanelPressedDeleteButton()
    func emotionPanelSelectedExpression(_ expression: Expression)
}

class ChatRoomEmotionPanelNode: ASDisplayNode, ASCollectionDataSource, ASCollectionDelegate {
    
    var delegate: ChatRoomEmotionPanelNodeDelegate?
    
    private let collectionNode: ASCollectionNode
    
    private var dataSource: [Expression] = []
    
    private let layoutInfo: ChatRoomEmotionLayoutInfo
    
    init(expressions: [Expression]) {
        
        self.dataSource = expressions
        
        let itemSize = CGSize(width: 36.0, height: 36.0)
        let itemSpacing: CGFloat = 6
        var margin: CGFloat = 12.0
        let columns = Int((Constants.screenWidth - 2.0 * margin + itemSpacing) / (itemSpacing + itemSize.width))
        margin = (Constants.screenWidth - CGFloat(columns) * (itemSize.height + itemSpacing))/2
        
        layoutInfo = ChatRoomEmotionLayoutInfo(itemsCount: expressions.count,
                                               itemSize: itemSize,
                                               itemSpacing: itemSpacing,
                                               margin: margin,
                                               columns: columns)

        let layoutDelegate = ChatRoomEmotionLayoutDelegate(layoutInfo: layoutInfo)
        collectionNode = ASCollectionNode(layoutDelegate: layoutDelegate, layoutFacilitator: nil)

        super.init()
        
        collectionNode.dataSource = self
        collectionNode.delegate = self
        
        addSubnode(collectionNode)
    }
    
    override func didLoad() {
        super.didLoad()
        
        collectionNode.backgroundColor = .clear
        collectionNode.view.isPagingEnabled = true
        collectionNode.showsVerticalScrollIndicator = false
        collectionNode.showsHorizontalScrollIndicator = false
        collectionNode.style.preferredSize = CGSize(width: bounds.width, height: bounds.height - 40)
        
        for page in 0 ..< layoutInfo.numberOfPages {
            let x = CGFloat(page) * Constants.screenWidth + layoutInfo.margin + (layoutInfo.itemSpacing + layoutInfo.itemSize.width) *  CGFloat(layoutInfo.columns - 1)
            let y = CGFloat(layoutInfo.rows - 1) * (layoutInfo.itemSpacing + layoutInfo.itemSize.width)
            let button = UIButton(type: .custom)
            button.addTarget(self, action: #selector(deleteEmoticonButtonClicked), for: .touchUpInside)
            button.setImage(UIImage(named: "DeleteEmoticonBtn_32x32_"), for: .normal)
            button.frame = CGRect(origin: CGPoint(x: x, y: y), size: layoutInfo.itemSize)
            button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
            collectionNode.view.addSubview(button)
        }
    }
    
    @objc private func deleteEmoticonButtonClicked() {
        delegate?.emotionPanelPressedDeleteButton()
    }
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let expression = dataSource[indexPath.row]
        let block = {
            return ChatRoomExpressionCellNode(expression: expression)
        }
        return block
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        let expression = dataSource[indexPath.row]
        delegate?.emotionPanelSelectedExpression(expression)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0), child: collectionNode)
    }
}

class ChatRoomExpressionCellNode: ASCellNode {
    
    private let imageNode: ASImageNode = ASImageNode()
    
    init(expression: Expression) {
        super.init()
        imageNode.style.preferredSize = CGSize(width: 28, height: 28)
        addSubnode(imageNode)
        imageNode.image = UIImage.as_imageNamed(expression.icon)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let padding = (constrainedSize.max.width - 28)/2.0
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding), child: imageNode)
    }
}
