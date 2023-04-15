//
//  MomentCommentListViewController.swift
//  WeChatSwift
//
//  Created by alexiscn on 2019/8/15.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentCommentListViewController: ASDKViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .plain)
    
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
        tableNode.backgroundColor = .white
        tableNode.frame = node.bounds
        tableNode.view.separatorStyle = .none
        
        navigationItem.title = "消息"
        
        let rightButton = UIBarButtonItem(title: "清空", style: .plain, target: self, action: #selector(handleRightButtonClicked))
        navigationItem.rightBarButtonItem = rightButton
    }
}

// MARK: - Event Handlers
extension MomentCommentListViewController {
    
    @objc private func handleRightButtonClicked() {
        
    }
    
}

// MARK: - ASTableDelegate & ASTableDataSource
extension MomentCommentListViewController: ASTableDelegate, ASTableDataSource {
    
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
