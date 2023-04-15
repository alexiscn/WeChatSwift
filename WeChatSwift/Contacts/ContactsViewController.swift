//
//  ContactsViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactsViewController: ASDKViewController<ASDisplayNode> {

    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [ContactSection] = []
    
    override init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
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
    
        setupDataSource()
        
        let rightButtonItem = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_addfriends"), style: .done, target: self, action: #selector(handleRightBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = rightButtonItem
        navigationItem.title = LocalizedString("TabBar_ContactsTitle")
    }
    
    private func setupDataSource() {
        let searchSection = ContactSection(title: "", models: [.newFriends, .groupChats, .tags, .officialAccounts])
        dataSource.append(searchSection)
        
        let users = MockFactory.shared.contacts()
        let groupingDict = Dictionary(grouping: users, by: { $0.letter })
        var contacts = groupingDict.map { return ContactSection(title: $0.key, models: $0.value.map { return ContactModel.contact($0) }) }
        contacts.sort(by: { $0.title < $1.title })
        dataSource.append(contentsOf: contacts)
    }
    
}

// MARK: - Event Handlers
extension ContactsViewController {
    
    @objc private func handleRightBarButtonTapped(_ sender: Any) {
        let controller = AddContactViewController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - ASTableDelegate & ASTableDataSource

extension ContactsViewController: ASTableDelegate, ASTableDataSource {
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
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let contact = dataSource[indexPath.section].models[indexPath.row]
        switch contact {
        case .groupChats:
            let chatRoomListVC = ChatRoomListViewController()
            navigationController?.pushViewController(chatRoomListVC, animated: true)
        case .newFriends:
            let sayHelloVC = SayHelloViewController()
            navigationController?.pushViewController(sayHelloVC, animated: true)
        case .officialAccounts:
            let brandContactsVC = BrandContactsViewController()
            navigationController?.pushViewController(brandContactsVC, animated: true)
        case .tags:
            let contactTagListVC = ContactTagListViewController()
            navigationController?.pushViewController(contactTagListVC, animated: true)
        case .contact(let contact):
            let contactInfoVC = ContactInfoViewController(contact: contact)
            navigationController?.pushViewController(contactInfoVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.01 : 32.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return nil
        }
        
        let title = dataSource[section].title
        let headerLabel = UILabel(frame: CGRect(x: 16, y: 0, width: view.bounds.width - 32, height: 32))
        headerLabel.text = title.uppercased()
        headerLabel.textColor = UIColor(white: 0, alpha: 0.5)
        headerLabel.font = UIFont.systemFont(ofSize: 14)
        let header = UIView()
        header.addSubview(headerLabel)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}
