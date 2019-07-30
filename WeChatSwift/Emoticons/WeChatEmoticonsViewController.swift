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
    
    private var banners: [EmoticonBanner] = []
    
    private var emoticons: [String] = ["1", "2", "3", "4", "5", "6"]
    
    init() {
        
        let layout = ASPagerFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: Constants.screenWidth, height: Constants.screenWidth * 0.375)
        layout.scrollDirection = .horizontal
        bannerNode = ASPagerNode(collectionViewLayout: layout)
        bannerNode.backgroundColor = .clear
        bannerNode.allowsAutomaticInsetsAdjustment = true
        
        tableNode = ASTableNode(style: .plain)
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        super.init(node: ASDisplayNode())
        
        node.addSubnode(tableNode)
        tableNode.addSubnode(bannerNode)
        
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
        
        loadBanners()
    }
    
    private func loadBanners() {
        guard let bannerPath = Bundle.main.path(forResource: "EmoticonBanners", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: bannerPath)) else {
            return
        }
        do {
            let banners = try JSONDecoder().decode([EmoticonBanner].self, from: data)
            //tableNode.contentInset = UIEdgeInsets(top: Constants.screenWidth * 0.5, left: 0, bottom: 0, right: 0)
            self.banners = banners
            bannerNode.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: Constants.screenWidth * 0.375)
            bannerNode.reloadData()
        } catch {
            print(error)
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
        let block: ASCellNodeBlock = {
            return WeChatEmoticonsCellNode(string: "")
        }
        return block
    }
    
}
