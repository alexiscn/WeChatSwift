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
    
    private var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = UIColor(hexString: "#E1E2E6")
        page.currentPageIndicatorTintColor = UIColor(hexString: "#8E8E8E")
        return page
    }()
    
    private var dataSource: [EmoticonViewModel] = []
    
    init(emoticons: [EmoticonViewModel]) {
        
        dataSource = emoticons
        tabBarNode = EmoticonBoardTabBarNode(emoticons: emoticons)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: Constants.screenWidth, height: 196)
        collectionNode = ASCollectionNode(collectionViewLayout: layout)
        
        super.init()
        addSubnode(collectionNode)
        addSubnode(tabBarNode)
        collectionNode.delegate = self
        collectionNode.dataSource = self
    }
    
    override func didLoad() {
        super.didLoad()
        collectionNode.view.isPagingEnabled = true
        collectionNode.view.showsHorizontalScrollIndicator = false
        collectionNode.view.showsVerticalScrollIndicator = false
        collectionNode.backgroundColor = .clear
        
        print(collectionNode.frame.width)
        
        view.addSubview(pageControl)
        pageControl.frame = CGRect(x: 0, y: 196.0 - 37.0, width: Constants.screenWidth, height: 37)
        
        pageControl.numberOfPages = 5
        collectionNode.reloadData()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        tabBarNode.style.preferredSize = CGSize(width: Constants.screenWidth, height: 44.0)
        collectionNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.height - 44.0)
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
            return EmoticonGridNode(viewMode: sectionModel, emoticons: emoticons)
        }
        return block
    }
    
}
