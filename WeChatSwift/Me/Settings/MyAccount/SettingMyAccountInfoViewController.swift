//
//  SettingMyAccountInfoViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/12.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingMyAccountInfoViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [SettingMyAccountInfoSection] = []
    
    override init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.delegate = self
        tableNode.dataSource = self
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
        
        navigationItem.title = LocalizedString("Setting_AccountSectionTitle")
    }
    
    private func setupDataSource() {
        dataSource.append(SettingMyAccountInfoSection(items: [.wechatId, .phoneNumber]))
        dataSource.append(SettingMyAccountInfoSection(items: [.wechatPassword, .voicePassword]))
        dataSource.append(SettingMyAccountInfoSection(items: [.emergencyContact, .deviceManagement, .moreSecuritySettings]))
        
        var more = SettingMyAccountInfoSection(items: [.freezeAccount, .securityCenter])
        more.footer = "如果遇到账号信息泄露、忘记密码、诈骗等账号安全问题，可前往微信安全中心。"
        dataSource.append(more)
    }
    
}


// MARK: - ASTableDelegate & ASTableDataSource
extension SettingMyAccountInfoViewController: ASTableDelegate, ASTableDataSource {
    
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
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
