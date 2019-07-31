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
    private let header: MomentHeaderNode = MomentHeaderNode()
    private var newMessage: MomentNewMessage?
    private var hasNewMessage: Bool { return newMessage != nil }
    
    init() {
        super.init(node: ASDisplayNode())
        
        node.addSubnode(tableNode)
        
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableNode.delegate = self
        tableNode.dataSource = self
        newMessage = MomentNewMessage(userAvatar: UIImage(named: "JonSnow.jpg"), unread: 5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        node.backgroundColor = Colors.backgroundColor
        
        tableNode.frame = view.bounds
        tableNode.view.allowsSelection = false
        tableNode.view.separatorStyle = .none
        
        let tableHeader = UIView()
        tableHeader.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 307)
        header.frame = tableHeader.bounds
        tableHeader.addSubnode(header)
        tableNode.view.tableHeaderView = tableHeader
    
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
        return hasNewMessage ? 2: 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        
        if hasNewMessage && section == 0 {
            return 1
        }
        return dataSource.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let moment = dataSource[indexPath.row]
        let message = self.newMessage
        let block: ASCellNodeBlock = {
            if let message = message, indexPath.section == 0 {
                return MomentNewMessageCellNode(newMessage: message)
            }
            return MomentCellNode(moment: moment)
        }
        return block
    }
}
