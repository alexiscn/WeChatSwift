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
    
    private var dataSource: [EmoticonViewModel] = []
    
    init(emoticons: [EmoticonViewModel], tabs: [EmoticonTab]) {
        
        dataSource = emoticons
        tabBarNode = EmoticonBoardTabBarNode(tabs: tabs)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: Constants.screenWidth, height: 196)
        collectionNode = ASCollectionNode(collectionViewLayout: layout)
        
        super.init()
        
        collectionNode.delegate = self
        collectionNode.dataSource = self
    }
    
    override func didLoad() {
        super.didLoad()
        collectionNode.backgroundColor = .clear
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        tabBarNode.style.preferredSize = CGSize(width: Constants.screenWidth, height: 44.0)
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [collectionNode, tabBarNode]
        return ASInsetLayoutSpec(insets: .zero, child: stack)
    }
}

extension EmoticonBoardNode: ASCollectionDataSource, ASCollectionDelegate {
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return dataSource.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return dataSource[section].numberOfPages()
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let sectionModel = dataSource[indexPath.section]
        let emoticons = sectionModel.numberOfItems(at: indexPath.row)
        let block: ASCellNodeBlock = {
            return EmoticonBoardPageCellNode(emoticons: emoticons)
        }
        return block
    }
    
}
