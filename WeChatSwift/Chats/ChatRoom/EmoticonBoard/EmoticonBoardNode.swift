//
//  EmoticonBoardNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonBoardNode: ASDisplayNode {
    
    private let tabBarNode: EmoticonBoardTabBarNode
    
    private let collectionNode: ASCollectionNode
    
    private var dataSource: [EmoticonModel] = []
    
    override init() {
        
        tabBarNode = EmoticonBoardTabBarNode()
        
        let layout = UICollectionViewFlowLayout()
        
        collectionNode = ASCollectionNode(collectionViewLayout: layout)
        
        super.init()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        tabBarNode.style.preferredSize = CGSize(width: Constants.screenWidth, height: 44.0)
        
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [collectionNode, tabBarNode]
        
        return stack
    }
}

extension EmoticonBoardNode: ASCollectionDataSource, ASCollectionDelegate {
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return dataSource.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].pages
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let emoticon = dataSource[indexPath.section]
        let block: ASCellNodeBlock = {
            return ASCellNode()
        }
        return block
    }
    
}
