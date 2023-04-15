//
//  SettingDiscoverEntranceViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingDiscoverEntranceViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode()
    
    private var dataSource: [DiscoverModel] = []
    
    override init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self
        dataSource = DiscoverManager.shared.discoverEntrance().flatMap { return $0.models }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = view.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        tableNode.view.allowsSelection = false
        navigationItem.title = LocalizedString("Setting_DiscoverEntranceTitle")
        
        setupTableHeader()
        setupTableFooter()
    }
    
    private func setupTableHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 1, width: view.bounds.width, height: 37))
        let headerLabel = UILabel()
        headerLabel.numberOfLines = 0
        headerLabel.text = LocalizedString("Setting_DiscoverEntrance_SectionHeader")
        headerLabel.textColor = Colors.DEFAULT_TEXT_GRAY_COLOR
        headerLabel.font = UIFont.systemFont(ofSize: 14)
        headerLabel.frame = CGRect(x: 16, y: 16, width: headerView.bounds.width - 32, height: 17)
        headerView.addSubview(headerLabel)
        tableNode.view.tableHeaderView = headerView
    }
    
    private func setupTableFooter() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 46))
        let footerLabel = UILabel()
        footerLabel.numberOfLines = 0
        footerLabel.text = LocalizedString("Setting_DiscoverEntrance_SectionFooter")
        footerLabel.textColor = Colors.DEFAULT_TEXT_GRAY_COLOR
        footerLabel.font = UIFont.systemFont(ofSize: 14)
        footerLabel.frame = CGRect(x: 16, y: 4, width: footerView.bounds.width - 32, height: 34)
        footerView.addSubview(footerLabel)
        tableNode.view.tableFooterView = footerView
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension SettingDiscoverEntranceViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let discover = dataSource[indexPath.row]
        let isLastCell = indexPath.row == dataSource.count - 1
        let block: ASCellNodeBlock = {
            return SettingDiscoverEntranceCellNode(discover: discover, isLastCell: isLastCell)
        }
        return block
    }
}
