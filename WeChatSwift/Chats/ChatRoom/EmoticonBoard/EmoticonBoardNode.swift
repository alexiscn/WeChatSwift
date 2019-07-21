//
//  EmoticonBoardNode.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/17.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

protocol EmoticonBoardNodeDelegate: class {
    func emoticonBoardPressedSendButton()
    func emoticonBoardPressedDeleteButton()
    func emoticonBoardPressedSettingButton()
    func emoticonBoardPressedAddButton()
    func emoticonBoardDidTapEmoticon(_ emoticon: Emoticon, viewModel: EmoticonViewModel)
}

class EmoticonBoardNode: ASDisplayNode {
    
    weak var delegate: EmoticonBoardNodeDelegate?
    
    private let tabBarNode: EmoticonBoardTabBarNode
    
    private let collectionNode: ASCollectionNode
    
    private var pageControl: UIPageControl = {
        let page = UIPageControl()
        page.pageIndicatorTintColor = UIColor(hexString: "#E1E2E6")
        page.currentPageIndicatorTintColor = UIColor(hexString: "#8E8E8E")
        page.hidesForSinglePage = true
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
        tabBarNode.delegate = self
    }
    
    override func didLoad() {
        super.didLoad()
        collectionNode.view.isPagingEnabled = true
        collectionNode.view.showsHorizontalScrollIndicator = false
        collectionNode.view.showsVerticalScrollIndicator = false
        collectionNode.backgroundColor = .clear
    
        pageControl.frame = CGRect(x: 0, y: 196.0 - 24.0, width: Constants.screenWidth, height: 20)
        pageControl.numberOfPages = dataSource.first?.numberOfPages() ?? 0
        view.addSubview(pageControl)
        
        collectionNode.reloadData()
        DispatchQueue.main.async {
            self.tabBarNode.emoticonGridDidScrollTo(IndexPath(row: 0, section: 0))
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        tabBarNode.style.preferredSize = CGSize(width: Constants.screenWidth, height: 44.0)
        collectionNode.style.preferredSize = CGSize(width: constrainedSize.max.width, height: constrainedSize.max.height - 44.0)
        let stack = ASStackLayoutSpec.vertical()
        stack.children = [collectionNode, tabBarNode]
        return ASInsetLayoutSpec(insets: .zero, child: stack)
    }
}

// MARK: - ASCollectionDelegate & ASCollectionDataSource
extension EmoticonBoardNode: ASCollectionDelegate, ASCollectionDataSource {
    
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
            let cell = EmoticonGridCellNode(viewModel: sectionModel, emoticons: emoticons)
            cell.didTapEmoticon = { [weak self] emoticon in
                self?.delegate?.emoticonBoardDidTapEmoticon(emoticon, viewModel: sectionModel)
            }
            return cell
        }
        return block
    }
}

// MARK: - UIScrollViewDelegate
extension EmoticonBoardNode: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let pageWidth = bounds.width
        let point = CGPoint(x: scrollView.contentOffset.x + pageWidth/2, y: 0)
        if let indexPath = collectionNode.indexPathForItem(at: point) {
            let numberOfPages = dataSource[indexPath.section].numberOfPages()
            pageControl.numberOfPages = numberOfPages
            pageControl.currentPage = indexPath.row
            tabBarNode.emoticonGridDidScrollTo(indexPath)
        }
    }
}

// MARK: - EmoticonBoardTabBarNodeDelegate
extension EmoticonBoardNode: EmoticonBoardTabBarNodeDelegate {
    
    func emoticonBoardTabBarPressedAddButton() {
        delegate?.emoticonBoardPressedAddButton()
    }
    
    func emoticonBoardTabBarPressedSendButton() {
        delegate?.emoticonBoardPressedSendButton()
    }
    
    func emoticonBoardTabBarPressedDeleteButton() {
        delegate?.emoticonBoardPressedDeleteButton()
    }
    
    func emoticonBoardTabBarPressedSettingButton() {
        delegate?.emoticonBoardPressedSettingButton()
    }
    
    func emoticonBoardTabBarDidSelected(at indexPath: IndexPath) {
        let destIndex = IndexPath(row: 0, section: indexPath.row)
        collectionNode.scrollToItem(at: destIndex, at: .left, animated: false)
        let numberOfPages = dataSource[destIndex.section].numberOfPages()
        pageControl.numberOfPages = numberOfPages
        pageControl.currentPage = 0
    }
}
