//
//  SettingGeneralViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingGeneralViewController: ASViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [SettingGeneralGroup] = []
    
    init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableNode.delegate = self
        tableNode.dataSource = self
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
        navigationItem.title = LocalizedString("Setting_GeneralTitle")
        
        setupDataSource()
    }
    
    private func setupDataSource() {
        dataSource.append(SettingGeneralGroup(items: [.language]))
        dataSource.append(SettingGeneralGroup(items: [.font, .backgroundImage, .emoticon, .files]))
        dataSource.append(SettingGeneralGroup(items: [.earmode]))
        dataSource.append(SettingGeneralGroup(items: [.discover, .plugins]))
        dataSource.append(SettingGeneralGroup(items: [.backup, .storage]))
        dataSource.append(SettingGeneralGroup(items: [.clearChatHistory]))
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension SettingGeneralViewController: ASTableDelegate, ASTableDataSource {
    
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
        
        let item = dataSource[indexPath.section].items[indexPath.row]
        switch item {
        case .language:
            let languageVC = SettingLanguageViewController()
            let nav = UINavigationController(rootViewController: languageVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .font:
            let fontSizeVC = SettingFontSizeViewController()
            let nav = UINavigationController(rootViewController: fontSizeVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .backgroundImage:
            let backgroundEntranceVC = ChatRoomBackgroundEntranceViewController(isFromGeneralSettings: true)
            navigationController?.pushViewController(backgroundEntranceVC, animated: true)
        case .files:
            let autoDownloadVC = SettingAutoDownloadViewController()
            navigationController?.pushViewController(autoDownloadVC, animated: true)
        case .emoticon:
            let emoticonManageVC = EmoticonManageViewController()
            navigationController?.pushViewController(emoticonManageVC, animated: true)
        case .discover:
            let discoverEntranceVC = SettingDiscoverEntranceViewController()
            navigationController?.pushViewController(discoverEntranceVC, animated: true)
        case .plugins:
            let pluginsVC = SettingPluginsViewController()
            navigationController?.pushViewController(pluginsVC, animated: true)
        case .storage:
            let storageUsageVC = StorageUsageViewController()
            navigationController?.pushViewController(storageUsageVC, animated: true)
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
