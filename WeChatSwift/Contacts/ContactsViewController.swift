//
//  ContactsViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactsViewController: ASViewController<ASTableNode> {

    private var dataSource: [ContactSection] = []
    
    private lazy var rightButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_outlined_addfriends"), style: .done, target: self, action: #selector(handleRightBarButtonTapped(_:)))
        return button
    }()
    
    init() {
        super.init(node: ASTableNode(style: .grouped))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        
        node.dataSource = self
        node.delegate = self
        
        setupDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.navigationItem.rightBarButtonItem = rightButtonItem
        tabBarController?.navigationItem.title = "通讯录"
    }
    
    private func setupDataSource() {
        let searchSection = ContactSection(title: "🔍", models: [.newFriends, .groupChats, .tags, .officialAccounts])
        dataSource.append(searchSection)
        
        let users = MockFactory.shared.users.map { return $0.toContact() }
        let contactUsers = users.map { return ContactModel.contact($0) }
        dataSource.append(ContactSection(title: "", models: contactUsers))
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
        let block: ASCellNodeBlock = {
            return ContactCellNode(model: model)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let contact = dataSource[indexPath.section].models[indexPath.row]
        switch contact {
        case .groupChats:
            print("group chats")
        case .newFriends:
            print("new friends")
        case .officialAccounts:
            print("official")
        case .tags:
            let contactTagListVC = ContactTagListViewController()
            navigationController?.pushViewController(contactTagListVC, animated: true)
        case .contact(let contact):
            let contactInfoVC = ContactInfoViewController(contact: contact)
            navigationController?.pushViewController(contactInfoVC, animated: true)
        }
        
    }
}
