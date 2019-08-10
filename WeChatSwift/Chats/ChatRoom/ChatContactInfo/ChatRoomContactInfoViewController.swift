//
//  ChatRoomContactInfoViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/7.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ChatRoomContactInfoViewController: ASViewController<ASDisplayNode> {
    private let tableNode = ASTableNode(style: .grouped)
    private var dataSource: [ChatRoomContactInfoSection] = []
    private var members: [AddChatRoomMemberItem] = []
    private let contact: Contact
    init(contact: Contact) {
        self.contact = contact
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableNode.dataSource = self
        tableNode.delegate = self
        setupDataSource()
        setupMembers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = view.bounds
        tableNode.view.separatorStyle = .none
        navigationItem.title = "聊天详情"
    }
    
    private func setupDataSource() {
        dataSource.append(ChatRoomContactInfoSection(items: [.addContactToChatRoom]))
        dataSource.append(ChatRoomContactInfoSection(items: [.searchChatHistory]))
        dataSource.append(ChatRoomContactInfoSection(items: [.mute, .stickToTop, .forceNotify]))
        dataSource.append(ChatRoomContactInfoSection(items: [.chatBackground]))
        dataSource.append(ChatRoomContactInfoSection(items: [.clearChat]))
        dataSource.append(ChatRoomContactInfoSection(items: [.report]))
    }
    
    private func setupMembers() {
        members.append(.contact(contact))
        members.append(.addButton)
    }
    
    private func presentMultiSelectContacts() {
        let multiSelectContactsVC = MultiSelectContactsViewController(string: "TODO")
        let nav = WCNavigationController(rootViewController: multiSelectContactsVC)
        present(nav, animated: true, completion: nil)
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension ChatRoomContactInfoViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.section].items[indexPath.row]
        let isLastCell = indexPath.row == dataSource[indexPath.section].items.count - 1
        let members = self.members
        let block: ASCellNodeBlock = { [weak self] in
            if indexPath.section == 0 {
                let addContactCell = ChatRoomAddContactCellNode(members: members)
                addContactCell.addButtonHandler = { [weak self] in
                    self?.presentMultiSelectContacts()
                }
                return addContactCell
            } else {
                return WCTableCellNode(model: model, isLastCell: isLastCell)
            }
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let model = dataSource[indexPath.section].items[indexPath.row]
        switch model {
        case .chatBackground:
            let chatBackgroundVC = ChatRoomBackgroundEntranceViewController()
            navigationController?.pushViewController(chatBackgroundVC, animated: true)
        default:
            break
        }
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
    
    func tableNode(_ tableNode: ASTableNode, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let model = dataSource[indexPath.section].items[indexPath.row]
        switch model {
        case .addContactToChatRoom, .mute, .stickToTop, .forceNotify:
            return false
        default:
            return true
        }
    }
    
}

struct ChatRoomContactInfoSection {
    var items: [ChatRoomContactInfoModel]
}

enum AddChatRoomMemberItem {
    case contact(Contact)
    case addButton
}

enum ChatRoomContactInfoModel: WCTableCellModel {
    case addContactToChatRoom
    case searchChatHistory
    case mute
    case stickToTop
    case forceNotify
    case chatBackground
    case clearChat
    case report
    
    var wc_title: String {
        switch self {
        case .addContactToChatRoom:
            return ""
        case .searchChatHistory:
            return "查找聊天内容"
        case .mute:
            return "消息免打扰"
        case .stickToTop:
            return "置顶聊天"
        case .forceNotify:
            return "强提醒"
        case .chatBackground:
            return "设置当前聊天背景"
        case .clearChat:
            return "清空聊天消息"
        case .report:
            return "投诉"
        }
    }
    
    var wc_image: UIImage? { return nil }
    
    var wc_showSwitch: Bool {
        switch self {
        case .mute, .stickToTop, .forceNotify:
            return true
        default:
            return false
        }
    }
    
    var wc_switchValue: Bool {
        switch self {
        case .mute:
            return true
        case .stickToTop:
            return false
        case .forceNotify:
            return false
        default:
            return false
        }
    }
}
