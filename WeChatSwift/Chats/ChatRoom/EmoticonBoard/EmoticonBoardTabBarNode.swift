//
//  EmoticonBoardTabBarNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonBoardTabBarNode: ASDisplayNode {
    
    private let addButtonNode: ASButtonNode
    
    private let collectionNode: ASCollectionNode
    
    private let settingButtonNode: ASButtonNode
    
    private let sendButtonNode: ASButtonNode
    
    override init() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 44, height: 44)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 1
        
        collectionNode = ASCollectionNode(collectionViewLayout: layout)
        
        addButtonNode = ASButtonNode()
        settingButtonNode = ASButtonNode()
        
        sendButtonNode = ASButtonNode()
        
        super.init()
        
        collectionNode.delegate = self
        collectionNode.dataSource = self
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: .zero, child: collectionNode)
    }
}

extension EmoticonBoardTabBarNode: ASCollectionDelegate, ASCollectionDataSource {
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let block: ASCellNodeBlock = {
            return ASCellNode()
        }
        return block
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        
    }
}
