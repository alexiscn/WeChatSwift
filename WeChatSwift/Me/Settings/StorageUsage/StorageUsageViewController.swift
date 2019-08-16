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
    
    private let cacheStorageNode: StorageUsageDetailNode
    
    private let chatStorageNode: StorageUsageDetailNode
    
    init() {
        
        let cacheStorageDetail = StorageUsageDetail(title: "缓存", desc: "缓存是使用微信过程中产生的临时数据，清理缓存不会影响微信的正常使用。", totalSize: 0, action: .clean)
        cacheStorageNode = StorageUsageDetailNode(detail: cacheStorageDetail)
        
        let chatStorageDetail = StorageUsageDetail(title: "聊天记录", desc: "可清理聊天中的图片、视频、文件等数据，但不会删除消息。", totalSize: 0, action: .manage)
        chatStorageNode = StorageUsageDetailNode(detail: chatStorageDetail)
        
        super.init(node: ASDisplayNode())
        node.addSubnode(scrollNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        navigationItem.title = "存储空间"
    }
    
}
