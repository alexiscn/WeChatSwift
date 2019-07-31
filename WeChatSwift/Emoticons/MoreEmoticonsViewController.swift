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
    
    init() {
        
        let spacing: CGFloat = 15.0
        let itemWidth: CGFloat = (Constants.screenWidth - spacing * 4.0)/3
        let itemHeight = itemWidth + 30.0
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        collectionNode = ASCollectionNode(collectionViewLayout: layout)
        collectionNode.backgroundColor = .clear
        collectionNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
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
        return 0
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
        let block: ASCellNodeBlock = {
            return ASCellNode()
        }
        return block
    }
    
    func collectionNode(_ collectionNode: ASCollectionNode, didSelectItemAt indexPath: IndexPath) {
        collectionNode.deselectItem(at: indexPath, animated: false)
    }
    
}
