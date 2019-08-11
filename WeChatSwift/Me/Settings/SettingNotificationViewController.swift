//
//  SettingNotificationViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/11.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SettingNotificationViewController: ASViewController<ASDisplayNode> {
 
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [SettingNotificationSection] = []
    
    init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self
        setupDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = node.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        
        navigationItem.title = "新消息通知"
    }
    
    private func setupDataSource() {
        dataSource.append(SettingNotificationSection(title: "微信未打开时", items: [.enableNewMessagePushNotification(true), .enableVOIPPushNotification(true)]))
        dataSource.append(SettingNotificationSection(title: nil, items: [.showPushNotificationContent(true)]))
        dataSource.append(SettingNotificationSection(title: "微信打开时", items: [.enableSound(true), .enableVibrate(true)]))
    }
}

extension SettingNotificationViewController: ASTableDelegate, ASTableDataSource {
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource[section].title == nil ? 0.01 : 38.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = dataSource[section].title else {
            return nil
        }
        let headerView = UIView()
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = title
        label.textColor = Colors.DEFAULT_TEXT_GRAY_COLOR
        label.frame = CGRect(x: 16, y: 16, width: view.bounds.width - 32, height: 17)
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

struct SettingNotificationSection {
    var title: String?
    var items: [SettingNotificationModel]
}

enum SettingNotificationModel: WCTableCellModel {
    case enableNewMessagePushNotification(Bool)
    case enableVOIPPushNotification(Bool)
    case showPushNotificationContent(Bool)
    case enableSound(Bool)
    case enableVibrate(Bool)
    
    var wc_title: String {
        switch self {
        case .enableNewMessagePushNotification(_):
            return "新消息通知"
        case .enableVOIPPushNotification(_):
            return "语音和视频通话提醒"
        case .showPushNotificationContent(_):
            return "通知显示消息详情"
        case .enableSound(_):
            return "声音"
        case .enableVibrate(_):
            return "振动"
        }
    }
    
    var wc_showSwitch: Bool {
        return true
    }
    
    var wc_switchValue: Bool {
        switch self {
        case .enableNewMessagePushNotification(let isOn):
            return isOn
        case .enableVOIPPushNotification(let isOn):
            return isOn
        case .showPushNotificationContent(let isOn):
            return isOn
        case .enableSound(let isOn):
            return isOn
        case .enableVibrate(let isOn):
            return isOn
        }
    }
}
