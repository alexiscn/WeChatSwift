//
//  AddContactViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class AddContactViewController: ASViewController<ASTableNode> {
    
    init() {
        super.init(node: ASTableNode(style: .grouped))
        node.dataSource = self
        node.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var dataSource: [AddContactSource] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "添加朋友"
        
        node.backgroundColor = Colors.backgroundColor
        node.view.separatorStyle = .none
        
        setupDataSource()
    }
    
    private func setupDataSource() {
        dataSource = [.radar, .faceToFaceGroup, .scan, .phoneContacts, .officialAccounts, .enterpriseContacts]
    }
    
}

extension AddContactViewController: ASTableDelegate, ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.row]
        let block: ASCellNodeBlock = {
            return AddContactCellNode(model: model)
        }
        return block
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: false)
    }
}
