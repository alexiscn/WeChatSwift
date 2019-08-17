//
//  EmoticonManageViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/25.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class EmoticonManageViewController: ASViewController<ASDisplayNode> {

    var isPresented: Bool = false
    
    private let tableNode = ASTableNode(style: .grouped)
    
    private var dataSource: [EmoticonManageGroup] = []
    
    init() {
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
        
        navigationItem.title = "我的表情"
        
        let sortButton = UIBarButtonItem(title: "排序", style: .plain, target: self, action: #selector(handleSortButtonClicked))
        navigationItem.rightBarButtonItem = sortButton
    }

    private func setupDataSource() {
        dataSource.append(EmoticonManageGroup(items: [.addSingleEmoticon, .selfieEmoticon]))
        dataSource.append(EmoticonManageGroup(items: [.emoticons([""])]))
        dataSource.append(EmoticonManageGroup(items: [.addHistory]))
    }
}

// MARK: - Event Handlers

extension EmoticonManageViewController {
    
    @objc private func handleSortButtonClicked() {
        tableNode.view.setEditing(true, animated: true)
    }
    
    @objc private func handleCancelButtonClicked() {
        tableNode.view.endEditing(true)
    }
    
    @objc private func handleDoneButtonClicked() {
        
    }
    
}

// MARK: - ASTableDelegate & ASTableDataSource
extension EmoticonManageViewController: ASTableDelegate, ASTableDataSource {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].items.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let block: ASCellNodeBlock = {
            return ASCellNode()
        }
        return block
    }
}

enum EmoticonManageItem {
    case addHistory
    case emoticons([String])
    case addSingleEmoticon
    case selfieEmoticon
}

struct EmoticonManageGroup {
    var items: [EmoticonManageItem]
}
