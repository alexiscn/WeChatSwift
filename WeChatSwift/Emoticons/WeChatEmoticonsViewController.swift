//
//  WeChatEmoticonsViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/30.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class WeChatEmoticonsViewController: ASViewController<ASDisplayNode> {
    
    private let bannerNode: ASPagerNode
    
    private let tableNode: ASTableNode
    
    private let bannerHeight = CGFloat(ceilf(Float(Constants.screenWidth * 0.375)))
    
    private var banners: [EmoticonBanner] = []
    
    private var emoticons: [StoreEmoticonItem] = []
    
    init() {
        let bannerLayout = ASPagerFlowLayout()
        bannerLayout.minimumLineSpacing = 0
        bannerLayout.minimumInteritemSpacing = 0
        bannerLayout.itemSize = CGSize(width: Constants.screenWidth, height: bannerHeight)
        bannerLayout.scrollDirection = .horizontal
        bannerLayout.sectionInset = .zero
        bannerNode = ASPagerNode(collectionViewLayout: bannerLayout)
        bannerNode.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: bannerHeight)
        bannerNode.backgroundColor = .clear
        bannerNode.allowsAutomaticInsetsAdjustment = true
        
        tableNode = ASTableNode(style: .plain)
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        super.init(node: ASDisplayNode())
        
        node.addSubnode(tableNode)
        bannerNode.setDelegate(self)
        bannerNode.setDataSource(self)
        
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
            
        tableNode.frame = node.bounds
        tableNode.backgroundColor = Colors.white
        let tableHeader = UIView()
        tableHeader.addSubnode(bannerNode)
        tableNode.view.tableHeaderView = tableHeader
        tableNode.view.separatorStyle = .none
        
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
            
            bannerNode.reloadData()
            tableNode.view.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: bannerHeight)
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

extension WeChatEmoticonsViewController: ASPagerDelegate, ASPagerDataSource {
    
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

// MARK: - ASTableDelegate & ASTableDataSource
extension WeChatEmoticonsViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return emoticons.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let emoticonItem = emoticons[indexPath.row]
        let block: ASCellNodeBlock = {
            return WeChatEmoticonsCellNode(storeEmoticonItem: emoticonItem)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
    }
}
