//
//  RemarkViewController.swift
//  WeChatSwift
//
//  Created by xushuifeng on 2019/8/11.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class RemarkViewController: ASViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [RemarkViewModel] = []
    
    private var editNameNode: RemarkEditNameCellNode?
    
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
        tableNode.view.keyboardDismissMode = .interactive
        //tableNode.view.setEditing(true, animated: false)
        
        navigationItem.title = LocalizedString("Contacts_Remark_Set")
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonClicked))
        cancelButton.tintColor = .black
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = wc_doneBarButton()
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
    }
    
    private func setupDataSource() {
        dataSource.append(RemarkViewModel(title: "备注名", type: .remarkName))
        dataSource.append(RemarkViewModel(title: "标签", type: .tag))
        dataSource.append(RemarkViewModel(title: "电话号码", type: .phoneNumber))
        dataSource.append(RemarkViewModel(title: "描述", type: .description))
    }
}

// MARK: - Event Handler

extension RemarkViewController {
    
    @objc private func cancelButtonClicked() {
        
        editNameNode?.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneButtonClicked() {
        
        editNameNode?.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension RemarkViewController: ASTableDelegate, ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.section]
        let block: ASCellNodeBlock = { [weak self] in
            switch model.type {
            case .remarkName:
                let cellNode = RemarkEditNameCellNode()
                self?.editNameNode = cellNode
                return cellNode
            case .tag:
                return RemarkTagCellNode()
            case .phoneNumber:
                return RemarkPhoneNumberCellNode(string: "1")
            case .description:
                return RemarkEditDescriptionCellNode()
            }
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let model = dataSource[indexPath.section]
        
        if model.type == .tag {
            let contactTagVC = ContactTagViewController()
            let nav = WCNavigationController(rootViewController: contactTagVC)
            present(nav, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 37.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = UILabel()
        titleLabel.text = dataSource[section].title
        titleLabel.textColor = UIColor(hexString: "#808080")
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.frame = CGRect(x: 16, y: 16, width: view.bounds.width - 32, height: 17)
        let headerView = UIView()
        headerView.addSubview(titleLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.section == 2 {
            return .insert
        }
        return .none
    }
}

struct RemarkViewModel {
    var title: String
    var type: RemarkType
}

enum RemarkType {
    case remarkName
    case tag
    case phoneNumber
    case description
}
