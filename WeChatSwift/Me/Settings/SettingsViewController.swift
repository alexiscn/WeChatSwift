//
//  SettingsViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/7/21.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingsViewController: ASViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [SettingsTableGroupModel] = []
    
    init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.view.separatorStyle = .none
        tableNode.frame = view.bounds
        tableNode.backgroundColor = .clear
        navigationItem.title = LocalizedString("Setting_Title")
        setupDataSource()
        tableNode.reloadData()
    }
    
    private func setupDataSource() {
        let accountModel = SettingsTableModel(type: .accountAndSecurity, title: LocalizedString("Setting_AccountSectionTitle"))
        dataSource.append(SettingsTableGroupModel(models: [accountModel]))
        
        let messageModel = SettingsTableModel(type: .newMessageNotification, title: LocalizedString("Setting_NotificationSectionTitle"))
        let privacyModel = SettingsTableModel(type: .privacy, title: LocalizedString("Setting_Other_PrivateConfigEx"))
        let generalModel = SettingsTableModel(type: .general, title: LocalizedString("Setting_GeneralTitle"))
        dataSource.append(SettingsTableGroupModel(models: [messageModel, privacyModel, generalModel]))
        
        let helpModel = SettingsTableModel(type: .helpAndFeedback, title: LocalizedString("Setting_QA"))
        var aboutModel = SettingsTableModel(type: .about, title: LocalizedString("Setting_Other_AboutMM"))
        aboutModel.value = "版本7.0.5"
        dataSource.append(SettingsTableGroupModel(models: [helpModel, aboutModel]))
        
        let pluginModel = SettingsTableModel(type: .plugins, title: LocalizedString("Wechat_Labs_Title"))
        dataSource.append(SettingsTableGroupModel(models: [pluginModel]))
        
        let switchAccountModel = SettingsTableModel(type: .switchAccount, title: LocalizedString("Login_LoginInfo_Mgr"))
        dataSource.append(SettingsTableGroupModel(models: [switchAccountModel]))
        
        let logoutModel = SettingsTableModel(type: .logout, title: LocalizedString("Setting_Quit_Title"))
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
        case .accountAndSecurity:
            let myAccountInfoVC = SettingMyAccountInfoViewController()
            navigationController?.pushViewController(myAccountInfoVC, animated: true)
        case .newMessageNotification:
            let notificationVC = SettingNotificationViewController()
            navigationController?.pushViewController(notificationVC, animated: true)
        case .about:
            let aboutVC = AboutViewController()
            navigationController?.pushViewController(aboutVC, animated: true)
        case .privacy:
            let privacyVC = SettingPrivacyViewController()
            navigationController?.pushViewController(privacyVC, animated: true)
        case .general:
            let generalVC = SettingGeneralViewController()
            navigationController?.pushViewController(generalVC, animated: true)
        case .plugins:
            let labVC = SettingLabViewController()
            navigationController?.pushViewController(labVC, animated: true)
        default:
            break
        }
    }
}
