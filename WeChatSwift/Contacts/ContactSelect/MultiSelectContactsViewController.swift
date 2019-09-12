//
//  MultiSelectContactsViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/7.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MultiSelectContactsViewController: ASViewController<ASDisplayNode> {
    
    var selectionHandler: (([MultiSelectContact]) -> Void)?
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private var doneButton: UIButton?
    
    private var dataSource: [MultiSelectContactSection] = []
    
    init() {
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
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = view.bounds
        tableNode.backgroundColor = .clear
        tableNode.view.separatorStyle = .none
        navigationItem.title = "选择联系人"
        
        let cancelButton = UIBarButtonItem(title: LanguageManager.Common.cancel(), style: .plain, target: self, action: #selector(cancelButtonClicked))
        cancelButton.tintColor = .black
        navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = wc_doneBarButton(title: "完成")
        doneButton.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        self.doneButton = doneButton
    }
    
    private func setupDataSource() {
        let users = MockFactory.shared.multiSelectContacts()
        let groupingDict = Dictionary(grouping: users, by: { $0.letter })
        var contacts = groupingDict.map { return MultiSelectContactSection(title: $0.key, models: $0.value) }
        contacts.sort(by: { $0.title < $1.title })
        dataSource.append(contentsOf: contacts)
    }
    
    private func updateRightButton() {
        let count = dataSource.flatMap { return $0.models }.filter { return $0.isSelected }.count
        UIView.performWithoutAnimation {
            if count == 0 {
                doneButton?.setTitle("完成", for: .normal)
                doneButton?.isEnabled = false
                doneButton?.frame.size = CGSize(width: 56.0, height: 32.0)
            } else {
                doneButton?.isEnabled = true
                doneButton?.setTitle("完成(\(count))", for: .normal)
                doneButton?.frame.size = CGSize(width: 78.0, height: 32.0)
            }
            doneButton?.setNeedsLayout()
            doneButton?.layoutIfNeeded()
        }
    }
}

// MARK: - Event Handlers
extension MultiSelectContactsViewController {
    
    @objc private func cancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneButtonClicked() {
        let contacts = dataSource.flatMap { return $0.models }.filter { return $0.isSelected }
        selectionHandler?(contacts)
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - ASTableDelegate & ASTableDataSource
extension MultiSelectContactsViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].models.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let contact = dataSource[indexPath.section].models[indexPath.row]
        let isLastCell = indexPath.row == dataSource[indexPath.section].models.count - 1
        let block: ASCellNodeBlock = {
            return MultiSelectContactsCellNode(contact: contact, isLastCell: isLastCell)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
        
        let contact = dataSource[indexPath.section].models[indexPath.row]
        contact.isSelected.toggle()
        tableNode.reloadRows(at: [indexPath], with: .none)
        updateRightButton()
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
