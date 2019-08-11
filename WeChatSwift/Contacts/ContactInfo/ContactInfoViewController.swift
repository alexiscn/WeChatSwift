//
//  ContactInfoViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactInfoViewController: ASViewController<ASDisplayNode> {
    
    private let contact: Contact
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [ContactInfoGroup] = []
    
    init(contact: Contact) {
        self.contact = contact
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        setupDataSource()
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.white
        tableNode.frame = view.bounds
        tableNode.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.view.separatorStyle = .none
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 105))
        let headerNode = ContactInfoHeaderNode(contact: contact)
        headerNode.frame = headerView.bounds
        headerView.addSubnode(headerNode)
        tableNode.view.tableHeaderView = headerView
        
        let moreButtonItem = UIBarButtonItem(image: Constants.moreImage, style: .done, target: self, action: #selector(moreButtonClicked))
        navigationItem.rightBarButtonItem = moreButtonItem
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDataSource() {
        dataSource.append(ContactInfoGroup(items: [.remark]))
        dataSource.append(ContactInfoGroup(items: [.moments, .more]))
        dataSource.append(ContactInfoGroup(items: [.sendMessage, .voip]))
    }
    
    override var wc_navigationBarBackgroundColor: UIColor? {
        return .white
    }
}

// MARK: - Event Handlers

extension ContactInfoViewController {
    
    @objc private func moreButtonClicked() {
        let contactSettingVC = ContactSettingViewController(contact: contact)
        navigationController?.pushViewController(contactSettingVC, animated: true)
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension ContactInfoViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let info = dataSource[indexPath.section].items[indexPath.row]
        let isLastCell = indexPath.row == dataSource[indexPath.section].items.count - 1
        let block: ASCellNodeBlock = { [weak self] in
            switch info {
            case .sendMessage, .voip:
                return ContactInfoButtonCellNode(info: info, isLastCell: isLastCell)
            case .remark, .moments, .more:
                return ContactInfoCellNode(info: info, isLastCell: isLastCell)
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
