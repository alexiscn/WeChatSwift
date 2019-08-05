//
//  SettingsViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/21.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingsViewController: ASViewController<ASTableNode> {
    
    private var dataSource: [SettingsTableGroupModel] = []
    
    init() {
        super.init(node: ASTableNode(style: .grouped))
        node.dataSource = self
        node.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        node.view.separatorStyle = .none
        navigationItem.title = "设置"
        setupDataSource()
        node.reloadData()
    }
    
    private func setupDataSource() {
        let accountModel = SettingsTableModel(type: .accountAndSecurity, title: "账号与安全")
        dataSource.append(SettingsTableGroupModel(models: [accountModel]))
        
        let messageModel = SettingsTableModel(type: .newMessageNotification, title: "新消息通知")
        let privacyModel = SettingsTableModel(type: .privacy, title: "隐私")
        let generalModel = SettingsTableModel(type: .general, title: "通用")
        dataSource.append(SettingsTableGroupModel(models: [messageModel, privacyModel, generalModel]))
        
        let helpModel = SettingsTableModel(type: .helpAndFeedback, title: "帮助与反馈")
        var aboutModel = SettingsTableModel(type: .about, title: "关于微信")
        aboutModel.value = "版本7.0.4"
        dataSource.append(SettingsTableGroupModel(models: [helpModel, aboutModel]))
        
        let pluginModel = SettingsTableModel(type: .plugins, title: "插件")
        dataSource.append(SettingsTableGroupModel(models: [pluginModel]))
        
        let switchAccountModel = SettingsTableModel(type: .switchAccount, title: "切换账号")
        dataSource.append(SettingsTableGroupModel(models: [switchAccountModel]))
        
        let logoutModel = SettingsTableModel(type: .logout, title: "退出登录")
        dataSource.append(SettingsTableGroupModel(models: [logoutModel]))
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension SettingsViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].models.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.section].models[indexPath.row]
        let isLastCell = indexPath.row == dataSource[indexPath.section].models.count - 1
        let block: ASCellNodeBlock = {
            return WCTableCellNode(model: model, isLastCell: isLastCell)
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
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let model = dataSource[indexPath.section].models[indexPath.row]
        switch model.type {
        case .about:
            let aboutVC = AboutViewController()
            navigationController?.pushViewController(aboutVC, animated: true)
        case .general:
            let generalVC = SettingGeneralViewController()
            navigationController?.pushViewController(generalVC, animated: true)
        default:
            break
        }
    }
}
