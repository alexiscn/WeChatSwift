//
//  StorageUsageViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/16.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class StorageUsageViewController: ASViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private let headBackgroundNode = ASDisplayNode()
    
    private let summaryStorageNode: StorageUsageSummaryNode
    
    private var dataSource: [StorageUsageDetail] = []
    
    private let loadingView = StorageUsageLoadingView(frame: CGRect(x: 0, y: 0, width: Constants.screenWidth, height: 140))
    
    private let scanner = StorageUsageScanner()
    
    init() {
        
        let summary = StorageUsageSummary(systemTotalSize: 100, systemFreeSize: 50, wechatSize: 30)
        summaryStorageNode = StorageUsageSummaryNode(summary: summary)
        
        let cacheStorageDetail = StorageUsageDetail(title: "缓存", desc: "缓存是使用微信过程中产生的临时数据，清理缓存不会影响微信的正常使用。", totalSize: 0, action: .clean)
        let chatStorageDetail = StorageUsageDetail(title: "聊天记录", desc: "可清理聊天中的图片、视频、文件等数据，但不会删除消息。", totalSize: 0, action: .manage)
        dataSource = [cacheStorageDetail, chatStorageDetail]
        
        super.init(node: ASDisplayNode())
        node.addSubnode(headBackgroundNode)
        node.addSubnode(tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headBackgroundNode.backgroundColor = Colors.white
        headBackgroundNode.frame = CGRect(x: 0, y: Constants.topInset + Constants.statusBarHeight - Constants.screenHeight * 2.0, width: Constants.screenWidth, height: Constants.screenHeight * 2.0)
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        tableNode.view.showsVerticalScrollIndicator = false
        tableNode.view.showsHorizontalScrollIndicator = false
        tableNode.frame = node.bounds
        tableNode.view.separatorStyle = .none
        tableNode.backgroundColor = .clear
        tableNode.allowsSelection = false
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: Constants.screenWidth, height: 230))
        headerView.addSubnode(summaryStorageNode)
        summaryStorageNode.frame = headerView.bounds
        tableNode.view.tableHeaderView = headerView
        
        navigationItem.title = LocalizedString("Setting_StorageUsageVC_Title")
        
        scanner.startScan { (summary, detail) in
            
        }
    }
 
    override var wc_navigationBarBackgroundColor: UIColor? {
        return .white
    }
}

// MARK: - UIScrollViewDelegate
extension StorageUsageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        headBackgroundNode.frame.origin.y = Constants.screenHeight * -2.0 - scrollView.contentOffset.y
    }
    
}

extension StorageUsageViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.section]
        let block: ASCellNodeBlock = {
            return StorageUsageDetailNode(detail: model)
        }
        return block
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}
