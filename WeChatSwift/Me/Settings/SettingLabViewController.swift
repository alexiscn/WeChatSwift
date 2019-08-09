//
//  SettingLabViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingLabViewController: ASViewController<ASTableNode> {
    
    init() {
        super.init(node: ASTableNode(style: .plain))
        node.dataSource = self
        node.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = UIColor(hexString: "#F1A555")
        node.view.separatorStyle = .none
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 260))
        let headerNode = SettingLabHeaderNode()
        headerNode.frame = headerView.bounds
        headerView.addSubnode(headerNode)
        node.view.tableHeaderView = headerView
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 117 + Constants.bottomInset))
        let footerNode = SettingLabFooterNode()
        footerNode.frame = footerView.bounds
        footerView.addSubnode(footerNode)
        node.view.tableFooterView = footerView
        
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
