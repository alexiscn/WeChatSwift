//
//  MomentGroupTagViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/9/10.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentGroupTagViewController: ASViewController<ASDisplayNode> {
    
    private let tableNode = ASTableNode(style: .plain)
    
    private var dataSource: [MomentGroupTag] = []
    
    init() {
        super.init(node: ASDisplayNode())
        node.addSubnode(tableNode)
        tableNode.delegate = self
        tableNode.dataSource = self
        setupDataSource()
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
        
        navigationItem.title = "谁可以看"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(handleCancelButtonClicked))
        
        let doneButton = wc_doneBarButton(title: "完成")
        doneButton.addTarget(self, action: #selector(handleDoneButtonClicked), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: doneButton)
    }
    
    private func setupDataSource() {
        dataSource.append(MomentGroupTag(type: .public))
        dataSource.append(MomentGroupTag(type: .secrect))
        dataSource.append(MomentGroupTag(type: .allow([])))
        dataSource.append(MomentGroupTag(type: .forbidden([])))
    }
}

// MARK: - Event Handlers
extension MomentGroupTagViewController {
    
    @objc private func handleCancelButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleDoneButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension MomentGroupTagViewController: ASTableDelegate, ASTableDataSource {
    
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
