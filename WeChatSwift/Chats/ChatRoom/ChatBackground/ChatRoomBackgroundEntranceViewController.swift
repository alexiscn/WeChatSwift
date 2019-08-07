//
//  ChatRoomBackgroundEntranceViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ChatRoomBackgroundEntranceViewController: ASViewController<ASTableNode> {
    
    private var isFromGeneralSettings = false
    
    private var dataSource: [ChatRoomBackgroundActionGroup] = []
    
    init(isFromGeneralSettings: Bool = false) {
        self.isFromGeneralSettings = isFromGeneralSettings
        super.init(node: ASTableNode(style: .grouped))
        node.dataSource = self
        node.delegate = self
     
        dataSource.append(ChatRoomBackgroundActionGroup(items: [.pick]))
        dataSource.append(ChatRoomBackgroundActionGroup(items: [.pickFromAlbum, .takeFromCamera]))
        if isFromGeneralSettings {
            dataSource.append(ChatRoomBackgroundActionGroup(items: [.applyToAllChats]))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        navigationItem.title = "聊天背景"
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension ChatRoomBackgroundEntranceViewController: ASTableDelegate, ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let action = dataSource[indexPath.section].items[indexPath.row]
        let block: ASCellNodeBlock = {
            return ChatRoomBackgroundEntranceCellNode(action: action)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let action = dataSource[indexPath.section].items[indexPath.row]
        switch action {
        case .pick:
            let backgroundSettingVC = ChatRoomBackgroundSettingViewController()
            let nav = WCNavigationController(rootViewController: backgroundSettingVC)
            present(nav, animated: true, completion: nil)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

struct ChatRoomBackgroundActionGroup {
    var items: [ChatRoomBackgroundAction]
}

enum ChatRoomBackgroundAction {
    case pick
    case pickFromAlbum
    case takeFromCamera
    case applyToAllChats
    
    var title: String {
        switch self {
        case .pick:
            return "选择背景图"
        case .pickFromAlbum:
            return "从手机相册选择"
        case .takeFromCamera:
            return "拍一张"
        case .applyToAllChats:
            return "将背景应用到所有聊天场景"
        }
    }
    
    func attributedStringForTitle() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17),
            NSAttributedString.Key.foregroundColor: UIColor(white: 0, alpha: 0.9)
        ]
        return NSAttributedString(string: title, attributes: attributes)
    }
}
