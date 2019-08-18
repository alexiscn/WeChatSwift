//
//  StorageUsageViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class StorageUsageViewController: ASViewController<ASDisplayNode> {
    
    private let scrollNode = ASScrollNode()
    
    private let summaryStorageNode: StorageUsageSummaryNode
    
    private let cacheStorageNode: StorageUsageDetailNode
    
    private let chatStorageNode: StorageUsageDetailNode
    
    init() {
        
        summaryStorageNode = StorageUsageSummaryNode()
        
        
        let cacheStorageDetail = StorageUsageDetail(title: "缓存", desc: "缓存是使用微信过程中产生的临时数据，清理缓存不会影响微信的正常使用。", totalSize: 0, action: .clean)
        cacheStorageNode = StorageUsageDetailNode(detail: cacheStorageDetail)
        
        let chatStorageDetail = StorageUsageDetail(title: "聊天记录", desc: "可清理聊天中的图片、视频、文件等数据，但不会删除消息。", totalSize: 0, action: .manage)
        chatStorageNode = StorageUsageDetailNode(detail: chatStorageDetail)
        
        super.init(node: ASDisplayNode())
        
        node.addSubnode(scrollNode)
        scrollNode.addSubnode(summaryStorageNode)
        scrollNode.addSubnode(cacheStorageNode)
        scrollNode.addSubnode(chatStorageNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        scrollNode.view.showsVerticalScrollIndicator = false
        scrollNode.view.showsHorizontalScrollIndicator = false
        scrollNode.frame = node.bounds
        
        summaryStorageNode.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: 230)
        cacheStorageNode.frame = CGRect(x: 0, y: 238, width: Constants.screenWidth, height: 126)
        chatStorageNode.frame = CGRect(x: 0, y: 372, width: Constants.screenWidth, height: 126)
        
        scrollNode.view.contentSize = node.bounds.size
        
        navigationItem.title = "存储空间"
    }
 
    override var wc_navigationBarBackgroundColor: UIColor? {
        return .white
    }
}
