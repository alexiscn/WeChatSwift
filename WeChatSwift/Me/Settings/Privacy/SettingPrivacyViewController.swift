//
//  SettingPrivacyViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingPrivacyViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [SettingPrivacySection] = []
    
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
        tableNode.frame = view.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        
        navigationItem.title = LocalizedString("Setting_Other_PrivateConfigEx")
    }
    
    private func setupDataSource() {
        dataSource.append(SettingPrivacySection(header: nil, items: [.enableVerifyWhenAddMe(true)], footer: nil))
        dataSource.append(SettingPrivacySection(header: nil, items: [.wayToAddMe, .enableAdressbookContacts(true)], footer: LocalizedString("Contacts_RecommendPhone_Footer")))
        dataSource.append(SettingPrivacySection(header: nil, items: [.blacklist], footer: nil))
        dataSource.append(SettingPrivacySection(header: "朋友圈和视频动态", items: [.momentForbidden, .momentIgnore, .momentTime("全部"), .momentAllowStranger(true)], footer: nil))
        dataSource.append(SettingPrivacySection(header: nil, items: [.momentUpdateNotify(true)], footer: LocalizedString("Album_Notification_ShowInMainTab_Explain")))
        dataSource.append(SettingPrivacySection(header: nil, items: [.authorization], footer: nil))
    }
}

extension SettingPrivacyViewController: ASTableDelegate, ASTableDataSource {
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
        return dataSource[section].heightForHeader
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = dataSource[section]
        guard let header = model.header else { return nil }
        let headerView = UIView()
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = header
        titleLabel.textColor = Colors.DEFAULT_TEXT_GRAY_COLOR
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.frame = CGRect(x: 16, y: 4, width: view.bounds.width - 32, height: model.heightForHeader - 12)
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return dataSource[section].heightForFooter
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let model = dataSource[section]
        guard let footer = model.footer else { return nil }
        let footerView = UIView()
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = footer
        titleLabel.textColor = Colors.DEFAULT_TEXT_GRAY_COLOR
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.frame = CGRect(x: 16, y: 4, width: view.bounds.width - 32, height: model.heightForFooter - 12)
        footerView.addSubview(titleLabel)
        return footerView
    }
    
    func tableNode(_ tableNode: ASTableNode, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let model = dataSource[indexPath.section].items[indexPath.row]
        return !model.wc_showSwitch
    }
}



