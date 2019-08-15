//
//  PublishMomentViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/29.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

enum PublishMomentSource {
    case text
    case media
}

class PublishMomentViewController: ASViewController<ASDisplayNode> {

    private let tableNode = ASTableNode(style: .plain)
    
    private var dataSource: [PublishMomentAction] = []
    
    private let source: PublishMomentSource
    
    init(source: PublishMomentSource) {
        self.source = source
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.dataSource = self
        tableNode.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.frame = node.bounds
        tableNode.view.separatorStyle = .none
        tableNode.backgroundColor = .clear
        
        if source == .text {
            navigationItem.title = "发表文字"
        }
        
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(handleCancelButtonClicked))
        navigationItem.leftBarButtonItem = cancelButton
        
        let publishButton = wc_doneBarButton(title: "发表")
        publishButton.isEnabled = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: publishButton)
    }
    
    
}

// MARK: - Event Handlers
extension PublishMomentViewController {
    
    @objc private func handleCancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handlePublishButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - ASTableDelegate & ASTableDataSource
extension PublishMomentViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let block: ASCellNodeBlock = {
            return ASCellNode()
        }
        return block
    }
}
