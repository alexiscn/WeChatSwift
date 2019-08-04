//
//  SettingGeneralViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingGeneralViewController: ASViewController<ASTableNode> {
    
    private var dataSource: [SettingGeneralGroup] = []
    
    init() {
        super.init(node: ASTableNode(style: .grouped))
        node.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        node.delegate = self
        node.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        node.view.separatorColor = Colors.DEFAULT_SEPARTOR_LINE_COLOR
        navigationItem.title = "通用"
        
        setupDataSource()
    }
    
    private func setupDataSource() {
        dataSource.append(SettingGeneralGroup(items: [.language]))
        dataSource.append(SettingGeneralGroup(items: [.font, .backgroundImage, .emoticon, .files]))
        dataSource.append(SettingGeneralGroup(items: [.earmode]))
        dataSource.append(SettingGeneralGroup(items: [.discover, .assistant]))
        dataSource.append(SettingGeneralGroup(items: [.backup, .storage]))
        dataSource.append(SettingGeneralGroup(items: [.clearChatHistory]))
    }
    
}

extension SettingGeneralViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let item = dataSource[indexPath.section].items[indexPath.row]
        let block: ASCellNodeBlock = {
            return SettingGeneralCellNode(setting: item)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let item = dataSource[indexPath.section].items[indexPath.row]
        switch item {
        case .language:
            print("language")
        case .emoticon:
            let emoticonManageVC = EmoticonManageViewController()
            navigationController?.pushViewController(emoticonManageVC, animated: true)
        case .discover:
            let discoverEntranceVC = SettingDiscoverEntranceViewController()
            navigationController?.pushViewController(discoverEntranceVC, animated: true)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.1 : 8.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
}
