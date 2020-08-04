//
//  ContactTagCreateDetailViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactTagCreateDetailViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .grouped)
    
    override init() {
        super.init(node: tableNode)
        node.addSubnode(tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = node.bounds
        tableNode.backgroundColor = .clear
        
        navigationItem.title = "新建标签"
        
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(handleCancelButtonClicked))
        navigationItem.leftBarButtonItem = cancelButton
        
        let rightButton = wc_doneBarButton(title: "完成")
        rightButton.addTarget(self, action: #selector(handleDoneButtonClicked), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    private func presentSelectContact() {
        let multiSelectContactsVC = MultiSelectContactsViewController()
        multiSelectContactsVC.selectionHandler = { selectedContacts in
            
        }
        let nav = UINavigationController(rootViewController: multiSelectContactsVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}

// MARK: - Event Handlers
extension ContactTagCreateDetailViewController {
    
    @objc private func handleCancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleDoneButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension ContactTagCreateDetailViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 3
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let block: ASCellNodeBlock = {
            return ASCellNode()
        }
        return block
    }
    
}
