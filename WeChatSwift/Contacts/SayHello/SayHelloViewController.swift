//
//  SayHelloViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/15.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SayHelloViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .grouped)
    
    override init() {
        super.init(node: ASDisplayNode())
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
        tableNode.view.separatorStyle = .none
        
        navigationItem.title = LocalizedString("Contacts_Plugin_FriendAssist_Nickname")
        
        let rightButton = UIBarButtonItem(title: "添加朋友", style: .plain, target: self, action: #selector(handleRightButtonClicked))
        navigationItem.rightBarButtonItem = rightButton
    }
    
}

// MARK: - Event Handlers
extension SayHelloViewController {
    
    @objc private func handleRightButtonClicked() {
        let addContactVC = AddContactViewController()
        navigationController?.pushViewController(addContactVC, animated: true)
    }
    
}

// MARK: - ASTableDelegate &
extension SayHelloViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 0
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
