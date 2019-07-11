//
//  ChatRoomEmotionPanelNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

struct ExpressionSection {
    var items: [Expression]
}

class ChatRoomEmotionPanelNode: ASDisplayNode, ASCollectionDataSource, ASCollectionDelegate {
    
    private let collectionNode: ASCollectionNode
    
    private var dataSource: [ExpressionSection] = []
    
    init(expressions: [Expression]) {
        
        let itemSize = CGSize(width: 36.0, height: 36.0)
        let itemSpacing: CGFloat = 6
        var margin: CGFloat = 12.0
        let count = (Constants.screenWidth - 2.0 * margin + itemSpacing) / (itemSpacing + itemSize.width)
        let numberInRows = Int(count)
        margin = (Constants.screenWidth - CGFloat(numberInRows) * (itemSize.height + itemSpacing))/2
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = itemSize
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.sectionInset = UIEdgeInsets(top: 20, left: margin, bottom: 20, right: margin)
        
        collectionNode = ASCollectionNode(collectionViewLayout: layout)
        
        let pages = expressions.count / (numberInRows * 3)
        
        var offset: Int = 0
        let numbersInPage = numberInRows * 3
        for _ in 0 ..< pages {
            var items: [Expression] = []
            for _ in 0 ..< numbersInPage {
                if offset >= expressions.count {
                    break
                }
                items.append(expressions[offset])
                offset += 1
            }
            dataSource.append(ExpressionSection(items: items))
        }

        super.init()
    
        collectionNode.dataSource = self
        collectionNode.delegate = self
        addSubnode(collectionNode)
    }
    
    override func didLoad() {
        super.didLoad()
        
        collectionNode.view.isPagingEnabled = true
    }
    
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return dataSource.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let expression = dataSource[indexPath.section].items[indexPath.row]
        let block = {
            return ChatRoomExpressionCellNode(expression: expression)
        }
        return block
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: collectionNode)
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
