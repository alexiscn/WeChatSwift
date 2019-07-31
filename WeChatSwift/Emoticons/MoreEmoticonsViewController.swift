//
//  MoreEmoticonsViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/30.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MoreEmoticonsViewController: ASViewController<ASDisplayNode> {
    
    private let bannerHeight = CGFloat(ceilf(Float(Constants.screenWidth * 0.375)))
    private let bannerNode: ASPagerNode
    private let collectionNode: ASCollectionNode
    
    private var banners: [EmoticonBanner] = []
    
    private var emoticons: [StoreEmoticonItem] = []
    
    init() {
        
        let spacing: CGFloat = 15.0
        let itemWidth: CGFloat = (Constants.screenWidth - spacing * 4.0)/3
        let itemHeight = itemWidth + 30.0
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        
        collectionNode = ASCollectionNode(collectionViewLayout: layout)
        collectionNode.backgroundColor = .clear
        collectionNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionNode.registerSupplementaryNode(ofKind: UICollectionView.elementKindSectionHeader)
        
        let bannerLayout = ASPagerFlowLayout()
        bannerLayout.minimumLineSpacing = 0
        bannerLayout.minimumInteritemSpacing = 0
        bannerLayout.itemSize = CGSize(width: Constants.screenWidth, height: bannerHeight)
        bannerLayout.scrollDirection = .horizontal
        bannerNode = ASPagerNode(collectionViewLayout: bannerLayout)
        bannerNode.backgroundColor = .clear
        bannerNode.allowsAutomaticInsetsAdjustment = true
        
        super.init(node: ASDisplayNode())
        
        node.addSubnode(collectionNode)
        collectionNode.dataSource = self
        collectionNode.delegate = self
        
        collectionNode.addSubnode(bannerNode)
        bannerNode.setDelegate(self)
        bannerNode.setDataSource(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        collectionNode.frame = node.bounds
        
        loadBanners()
        loadFakeEmoticons()
    }
    
    private func loadBanners() {
        guard let bannerPath = Bundle.main.path(forResource: "EmoticonBanners", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: bannerPath)) else {
                return
        }
        do {
            let banners = try JSONDecoder().decode([EmoticonBanner].self, from: data)
            self.banners = banners
            bannerNode.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: bannerHeight)
            bannerNode.reloadData()
        } catch {
            print(error)
        }
    }
    
    private func loadFakeEmoticons() {
        let stickers = AppContext.current.emoticonMgr.emoticons.filter { return $0.type == .sticker }
        let items = stickers.first?.numberOfItems(at: 0)
        let count = items?.count ?? 1
        for i in 0 ... 30 {
            let index = i % count
            let item = items?[index]
            emoticons.append(StoreEmoticonItem(image: item?.thumbImage, title: item?.title, desc: "有\(i)个朋友在用"))
        }
    }
}

// MARK: - ASPagerDelegate & ASPagerDataSource
extension MoreEmoticonsViewController: ASPagerDelegate, ASPagerDataSource {
    
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return banners.count
    }
    
    func pagerNode(_ pagerNode: ASPagerNode, nodeBlockAt index: Int) -> ASCellNodeBlock {
        let banner = banners[index]
        let block: ASCellNodeBlock = {
            return WeChatEmoticonBannerCellNode(banner: banner)
        }
        return block
    }
}

// MARK: - ASCollectionDelegate & ASCollectionDataSource
extension MoreEmoticonsViewController: ASCollectionDelegate, ASCollectionDataSource {
    
    func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
        return 1
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return emoticons.count
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let item = emoticons[indexPath.row]
        let block: ASCellNodeBlock = {
            return EmoticonStoreCellNode(item: item)
        }
        return block
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        collectionNode.deselectItem(at: indexPath, animated: false)
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> ASCellNode {
        if kind == UICollectionView.elementKindSectionHeader {
            let cellNode = ASCellNode()
            cellNode.addSubnode(bannerNode)
            return cellNode
        }
        return ASCellNode()
    }
}
