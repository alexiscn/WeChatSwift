//
//  MomentsViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/4.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import AsyncDisplayKit

class MomentsViewController: ASViewController<ASDisplayNode> {

    private let tableNode: ASTableNode = ASTableNode(style: .plain)
    private var dataSource: [Moment] = []
    private var statusBarStyle: UIStatusBarStyle = .lightContent
    
    private let toolNode = ChatRoomToolPanelNode(tools: ChatRoomTool.allCases)
    
    init() {
        super.init(node: ASDisplayNode())
        
        node.addSubnode(tableNode)
        node.addSubnode(toolNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        node.backgroundColor = Colors.backgroundColor
        
        tableNode.frame = view.bounds
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.view.allowsSelection = false
        tableNode.view.separatorStyle = .none
        
        toolNode.frame = CGRect(x: 0, y: 200, width: view.bounds.width, height: 216)
        
        setupDataSource()
    }
    
    private func setupDataSource() {
        dataSource = MockFactory.shared.moments()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}

extension MomentsViewController: ASTableDelegate, ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let moment = dataSource[indexPath.row]
        let block: ASCellNodeBlock = {
            return MomentCellNode(moment: moment)
        }
        return block
    }
}
