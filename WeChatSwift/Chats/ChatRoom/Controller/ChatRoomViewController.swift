//
//  ChatRoomViewController.swift
//  WeChatSwift
//
//  Created by xu.shuifeng on 2019/7/9.
//  Copyright © 2019 alexiscn. All rights reserved.
//

import Foundation
import UIKit
import AsyncDisplayKit

class ChatRoomViewController: ASViewController<ASDisplayNode> {
    
    private let sessionID: String
    
    private let dataSource: ChatRoomDataSource
    
    private let user: MockFactory.MockUser
    
    private let inputNode = ChatRoomKeyboardNode()
    
    private let bottomNode = ASDisplayNode()
    
    private let tableNode = ASTableNode(style: .plain)
    
    init(sessionID: String) {
        self.sessionID = sessionID
        self.dataSource = ChatRoomDataSource(sessionID: sessionID)
        self.user = MockFactory.shared.users.first(where: { $0.identifier == sessionID })!
        
        super.init(node: ASDisplayNode())
        
        let toolBarHeight: CGFloat = 60.0
        let toolBarY = Constants.screenHeight - Constants.topInset - Constants.bottomInset - 44.0 - toolBarHeight
        let toolBarFrame = CGRect(x: 0, y: toolBarY, width: Constants.screenWidth, height: toolBarHeight)
        inputNode.frame = toolBarFrame
        inputNode.backgroundColor = UIColor(hexString: "#F5F6F7")
        
        bottomNode.backgroundColor = UIColor(hexString: "#F5F6F7")
        
        node.backgroundColor = Colors.DEFAULT_BACKGROUND_COLOR
        tableNode.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        node.addSubnode(tableNode)
        node.addSubnode(inputNode)
        node.addSubnode(bottomNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = user.name
        let moreButtonItem = UIBarButtonItem(image: UIImage.SVGImage(named: "icons_filled_more"), style: .done, target: self, action: #selector(moreButtonClicked))
        navigationItem.rightBarButtonItem = moreButtonItem
        
        tableNode.allowsSelection = false
        tableNode.view.separatorStyle = .none
        tableNode.dataSource = self
        tableNode.delegate = self
        tableNode.view.backgroundColor = Colors.backgroundColor //UIColor(hexString: "#EFEFF4")
        tableNode.frame = CGRect(x: 0, y: 0, width: Constants.screenWidth, height: Constants.screenHeight - 34 - 60)
        
        bottomNode.frame = CGRect(x: 0, y: inputNode.frame.maxY, width: Constants.screenWidth, height: Constants.bottomInset)
        
        scrollToLastMessage(animated: false)
    }
    
    func scrollToLastMessage(animated: Bool) {
        DispatchQueue.main.async {
            let last = self.dataSource.numberOfRows() - 1
            if last > 0 {
                let indexPath = IndexPath(row: last, section: 0)
                self.tableNode.scrollToRow(at: indexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    @objc private func moreButtonClicked() {
    
    }
}

// MARK: - ASTableDataSource & ASTableDelegate
extension ChatRoomViewController: ASTableDataSource, ASTableDelegate {
    
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfRows()
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let message = dataSource.itemAtIndexPath(indexPath)
        let nodeBlock: ASCellNodeBlock = {
            return ChatRoomCellNodeFactory.node(for: message)
        }
        return nodeBlock
    }
}
