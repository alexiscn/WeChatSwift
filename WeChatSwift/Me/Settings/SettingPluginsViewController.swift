//
//  SettingPluginsViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingPluginsViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [SettingPluginSection] = []
    
    override init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self
        setupDataSource()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = node.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        
        navigationItem.title = LocalizedString("Setting_PluginsTitle")
    }
    
    private func setupDataSource() {
        dataSource.append(SettingPluginSection(title: LocalizedString("Plugin_HasOpenPlugins"), items: [.groupMessageAssistant]))
        dataSource.append(SettingPluginSection(title: LocalizedString("Plugin_NotOpenPlugins"), items: [.news, .qqMail, .weSport]))
    }
}

extension SettingPluginsViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.section].items[indexPath.row]
        let isLastCell = indexPath.row == dataSource[indexPath.section].items.count - 1
        let block: ASCellNodeBlock = {
            return WCTableCellNode(model: model, isLastCell: isLastCell)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 38.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let icon = section == 0 ? "setting_pluginInstall_18x18_": "setting_pluginUnInstall_18x18_"
        let title = dataSource[section].title
        
        let iconView = UIImageView(image: UIImage(named: icon))
        iconView.frame = CGRect(x: 10, y: 10, width: 18, height: 18)
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = title
        label.textColor = Colors.DEFAULT_TEXT_GRAY_COLOR
        label.frame = CGRect(x: 33, y: 0, width: 200, height: 38)
        
        headerView.addSubview(iconView)
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

