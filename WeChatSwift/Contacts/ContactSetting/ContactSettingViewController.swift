//
//  ContactSettingViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/6.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactSettingViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private let contact: Contact
    
    private var dataSource: [ContactSettingSection] = []
    
    init(contact: Contact) {
        self.contact = contact
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
        
        navigationItem.title = LocalizedString("Contacts_ContactInfoSetting")
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = view.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
    }
    
    private func setupDataSource() {
        dataSource.append(ContactSettingSection(title: nil, items: [ContactSettingModel(type: .remakAndTag, wc_title: LocalizedString("Contacts_Remark_Set"))]))
        
        let gender = contact.gender
        let recommentToFriendTitle = gender == .male ? LocalizedString("Contacts_Setting_Share_Male"): LocalizedString("Contacts_Setting_Share_Female")
        let recommendToFriend = ContactSettingModel(type: .recommendToFriend, wc_title: recommentToFriendTitle)
        dataSource.append(ContactSettingSection(title: nil, items: [recommendToFriend]))
        
        dataSource.append(ContactSettingSection(title: nil, items: [
            ContactSettingModel(type: .markAsStarFriend(false), wc_title: LocalizedString("Contacts_Setting_Favour"))]))
        
        let momentForbiddenTitle = gender == .male ? LocalizedString("Contacts_Setting_WC_Outsider_Male"): LocalizedString("Contacts_Setting_WC_Outsider_Female")
        let momentIgnoreTitle = gender == .male ? LocalizedString("Contacts_WCAddBlacklist_Male"): LocalizedString("Contacts_WCAddBlacklist_Female")
        
        dataSource.append(ContactSettingSection(title: LocalizedString("Contacts_Setting_WC_Title"), items: [
            ContactSettingModel(type: .momentForbidden(false), wc_title: momentForbiddenTitle),
            ContactSettingModel(type: .momentIgnore(false), wc_title: momentIgnoreTitle)]))
        
        dataSource.append(ContactSettingSection(title: nil, items: [
            ContactSettingModel(type: .addToBlackList(false), wc_title: LocalizedString("Contacts_Setting_AddToBlack")),
            ContactSettingModel(type: .report, wc_title: LocalizedString("Expose"))]))
        
        dataSource.append(ContactSettingSection(title: nil, items: [
            ContactSettingModel(type: .delete, wc_title: LocalizedString("Contacts_Delete"))]))
    }
}

extension ContactSettingViewController: ASTableDelegate, ASTableDataSource {
    
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
        
        let model = dataSource[indexPath.section].items[indexPath.row]
        switch model.type {
        case .remakAndTag:
            let remarkVC = RemarkViewController()
            let nav = UINavigationController(rootViewController: remarkVC)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        case .recommendToFriend:
            print("...")
        case .report:
            print("...")
        case .delete:
            print("....")
        default:
            break
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let model = dataSource[indexPath.section].items[indexPath.row]
        return !model.wc_showSwitch
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = dataSource[section].title else {
            return nil
        }
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = Colors.DEFAULT_TEXT_GRAY_COLOR
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.frame = CGRect(x: 16, y: 16, width: tableView.bounds.width - 32, height: 17)
        
        let headerView = UIView()
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return dataSource[section].title == nil ? 0.01: 37.0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8.0
    }
}
