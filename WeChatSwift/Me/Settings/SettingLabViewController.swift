//
//  SettingLabViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingLabViewController: ASViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode()
    
    init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = UIColor(hexString: "#F1A555")
        tableNode.frame = view.bounds
        tableNode.view.separatorStyle = .none
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 260))
        let headerNode = SettingLabHeaderNode()
        headerNode.frame = headerView.bounds
        headerView.addSubnode(headerNode)
        tableNode.view.tableHeaderView = headerView
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 117 + Constants.bottomInset))
        let footerNode = SettingLabFooterNode()
        footerNode.frame = footerView.bounds
        footerView.addSubnode(footerNode)
        tableNode.view.tableFooterView = footerView
        
        navigationItem.title = "插件"
    }
    
}

// MARK: - ASTableDelegate & ASTableDataSource
extension SettingLabViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 0
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let block: ASCellNodeBlock = {
            return ASCellNode()
        }
        return block
    }
    
}
