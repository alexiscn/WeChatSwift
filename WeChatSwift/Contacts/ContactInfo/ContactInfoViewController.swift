//
//  ContactInfoViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactInfoViewController: ASViewController<ASTableNode> {
    
    private let contact: ContactModel
    
    private var dataSource: [ContactInfoGroup] = []
    
    init(contact: ContactModel) {
        self.contact = contact
        super.init(node: ASTableNode(style: .grouped))
        setupDataSource()
        node.dataSource = self
        node.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.backgroundColor
        node.view.separatorStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDataSource() {
        dataSource.append(ContactInfoGroup(items: [.profile, .remark]))
        dataSource.append(ContactInfoGroup(items: [.moments, .more]))
        dataSource.append(ContactInfoGroup(items: [.sendMessage, .voip]))
    }
}

extension ContactInfoViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let info = dataSource[indexPath.section].items[indexPath.row]
        let block: ASCellNodeBlock = { [weak self] in
            guard let strongSelf = self else { return ASCellNode() }
            switch info {
            case .profile:
                return ContactInfoProfileCellNode(contact: strongSelf.contact)
            case .sendMessage, .voip:
                return ContactInfoButtonCellNode(info: info)
            case .remark, .moments, .more:
                return ContactInfoCellNode(info: info)
            }
        }
        return block
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
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
    }
}







enum ContactInfo {
    case profile
    case remark
    case moments
    case more
    case sendMessage
    case voip
    
    var title: String {
        switch self {
        case .profile:
            return ""
        case .remark:
            return "设置备注和标签"
        case .moments:
            return "朋友圈"
        case .more:
            return "更多信息"
        case .sendMessage:
            return "发消息"
        case .voip:
            return "音视频通话"
        }
    }
    
    var image: UIImage? {
        switch self {
        case .sendMessage:
            return UIImage.SVGImage(named: "icons_outlined_chats")
        case .voip:
            return UIImage.SVGImage(named: "icons_outlined_videocall")
        default:
            return nil
        }
    }
}

struct ContactInfoGroup {
    var items: [ContactInfo]
}
