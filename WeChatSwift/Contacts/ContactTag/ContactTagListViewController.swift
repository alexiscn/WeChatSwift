//
//  ContactTagListViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/2.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class ContactTagListViewController: ASViewController<ASDisplayNode> {
    
    private var placeholder: ContactTagListPlacehoderNode?
    
    private var tableNode: ASTableNode
    
    private var dataSource: [ContactTag] = []
    
    init() {
        
        tableNode = ASTableNode(style: .plain)
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        super.init(node: ASDisplayNode())
        
        node.addSubnode(tableNode)
        tableNode.delegate = self
        tableNode.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        navigationItem.title = "标签"
        
        setupDataSource()
        
        if dataSource.count == 0 {
            let top = Constants.topInset + Constants.statusBarHeight
            let bottom = Constants.bottomInset
            let placeholder = ContactTagListPlacehoderNode()
            placeholder.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - top - bottom)
            node.addSubnode(placeholder)
            self.placeholder = placeholder
        }
    }
    
    private func setupDataSource() {
        
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension ContactTagListViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        if indexPath.section == 0 {
            let block: ASCellNodeBlock = {
                return ContactTagListAddTagCellNode()
            }
            return block
        } else {
            let tag = dataSource[indexPath.row]
            let block: ASCellNodeBlock = {
                return ContactTagListCellNode(tag: tag)
            }
            return block
        }
    }
}
