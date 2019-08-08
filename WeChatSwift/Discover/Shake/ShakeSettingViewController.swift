//
//  ShakeSettingViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/8.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ShakeSettingViewController: ASViewController<ASTableNode> {
    
    private var dataSource: [ShakeSettingSection] = []
    
    init() {
        super.init(node: ASTableNode(style: .grouped))
        node.dataSource = self
        node.delegate = self
        setupDataSource()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        node.view.separatorStyle = .none
        
        navigationItem.title = "摇一摇设置"
    }
    
    private func setupDataSource() {
        dataSource.append(ShakeSettingSection(items: [.useDefaultBackground, .changeBackground, .enablePlaySound(true)]))
        dataSource.append(ShakeSettingSection(items: [.sayHello, .history]))
        dataSource.append(ShakeSettingSection(items: [.messageList]))
    }
}

extension ShakeSettingViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let item = dataSource[indexPath.section].items[indexPath.row]
        let isLastCell = indexPath.row == dataSource[indexPath.section].items.count - 1
        let block: ASCellNodeBlock = {
            return ShakeSettingCellNode(settingItem: item, isLastCell: isLastCell)
        }
        return block
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.01 : 8.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
