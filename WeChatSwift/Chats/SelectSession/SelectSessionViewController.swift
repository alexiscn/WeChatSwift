//
//  SelectSessionViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/8/31.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class SelectSessionViewController: ASViewController<ASDisplayNode> {
    
    private var closeButtonItem: UIBarButtonItem?
    private var cancelButtonItem: UIBarButtonItem?
    private var multiSelectButtonItem: UIBarButtonItem?
    private var doneButtonItem: UIBarButtonItem?
    
    private let tableNode = ASTableNode()
    private var dataSource: [SelectSessionModel] = []
    
    init() {
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
        
        navigationItem.title = "选择一个聊天"
        
        let closeButton = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(handleCloseButtonClicked))
        navigationItem.leftBarButtonItem = closeButton
        self.closeButtonItem = closeButton
        
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(handleCancelButtonClicked))
        self.cancelButtonItem = cancelButton
        
        let multiSelectButton = UIBarButtonItem(title: "多选", style: .plain, target: self, action: #selector(handleMultiSelectButtonClicked))
        navigationItem.rightBarButtonItem = multiSelectButton
        self.multiSelectButtonItem = multiSelectButton
        
        let doneButton = wc_doneBarButton()
        doneButton.addTarget(self, action: #selector(handleDoneButtonClicked), for: .touchUpInside)
        self.doneButtonItem = UIBarButtonItem(customView: doneButton)
    }
    
}

// MAKR: - Event Handlers
extension SelectSessionViewController {
    
    @objc private func handleCloseButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func handleCancelButtonClicked() {
        navigationItem.leftBarButtonItem = closeButtonItem
        navigationItem.rightBarButtonItem = multiSelectButtonItem
    }
    
    @objc private func handleMultiSelectButtonClicked() {
        navigationItem.leftBarButtonItem = cancelButtonItem
        navigationItem.rightBarButtonItem = doneButtonItem
    }
    
    @objc private func handleDoneButtonClicked() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - ASTableDelegate & ASTableDataSource
extension SelectSessionViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let model = dataSource[indexPath.item]
        let isLastCell = indexPath.item == dataSource.count - 1
        let block: ASCellNodeBlock = {
            return WCTableCellNode(model: model, isLastCell: isLastCell)
        }
        return block
    }
    
}
